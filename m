From: akpm@linux-foundation.org
Subject: + do_sys_poll-simplify-playing-with-on-stack-data.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:04:32 -0700
Message-ID: <200707200104.l6K14W3O032286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934481AbXGTBEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:04:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ak@suse.de, davidel@xmailserver.org, vlobanov@speakeasy.net


The patch titled
     do_sys_poll: simplify playing with on-stack data
has been added to the -mm tree.  Its filename is
     do_sys_poll-simplify-playing-with-on-stack-data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_sys_poll: simplify playing with on-stack data
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup. Lessens both the source and compiled code (100 bytes) and imho makes
the code much more understandable.

With this patch "struct poll_list *head" always points to on-stack stack_pps,
so we can remove all "is it on-stack" and "was it initialized" checks.

Also, move poll_initwait/poll_freewait and -EINTR detection closer to the
do_poll()'s callsite.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Looks-good-to: Andi Kleen <ak@suse.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Vadim Lobanov <vlobanov@speakeasy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   92 +++++++++++++++++++-------------------------------
 1 files changed, 36 insertions(+), 56 deletions(-)

diff -puN fs/select.c~do_sys_poll-simplify-playing-with-on-stack-data fs/select.c
--- a/fs/select.c~do_sys_poll-simplify-playing-with-on-stack-data
+++ a/fs/select.c
@@ -653,86 +653,66 @@ static int do_poll(unsigned int nfds,  s
 int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout)
 {
 	struct poll_wqueues table;
- 	int fdcount, err;
- 	unsigned int i;
-	struct poll_list *head;
- 	struct poll_list *walk;
+ 	int err = -EFAULT, fdcount, len, size;
 	/* Allocate small arguments on the stack to save memory and be
 	   faster - use long to make sure the buffer is aligned properly
 	   on 64 bit archs to avoid unaligned access */
 	long stack_pps[POLL_STACK_ALLOC/sizeof(long)];
-	struct poll_list *stack_pp = NULL;
+	struct poll_list *const head = (struct poll_list *)stack_pps;
+ 	struct poll_list *walk = head;
+ 	unsigned long todo = nfds;
 
-	/* Do a sanity check on nfds ... */
 	if (nfds > current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
 		return -EINVAL;
 
-	poll_initwait(&table);
+	len = min(nfds, N_STACK_PPS);
+	for (;;) {
+		walk->next = NULL;
+		walk->len = len;
+		if (!len)
+			break;
 
-	head = NULL;
-	walk = NULL;
-	i = nfds;
-	err = -ENOMEM;
-	while(i!=0) {
-		struct poll_list *pp;
-		int num, size;
-		if (stack_pp == NULL)
-			num = N_STACK_PPS;
-		else
-			num = POLLFD_PER_PAGE;
-		if (num > i)
-			num = i;
-		size = sizeof(struct poll_list) + sizeof(struct pollfd)*num;
-		if (!stack_pp)
-			stack_pp = pp = (struct poll_list *)stack_pps;
-		else {
-			pp = kmalloc(size, GFP_KERNEL);
-			if (!pp)
-				goto out_fds;
-		}
-		pp->next=NULL;
-		pp->len = num;
-		if (head == NULL)
-			head = pp;
-		else
-			walk->next = pp;
+		if (copy_from_user(walk->entries, ufds + nfds-todo,
+					sizeof(struct pollfd) * walk->len))
+			goto out_fds;
 
-		walk = pp;
-		if (copy_from_user(pp->entries, ufds + nfds-i, 
-				sizeof(struct pollfd)*num)) {
-			err = -EFAULT;
+		todo -= walk->len;
+		if (!todo)
+			break;
+
+		len = min(todo, POLLFD_PER_PAGE);
+		size = sizeof(struct poll_list) + sizeof(struct pollfd) * len;
+		walk = walk->next = kmalloc(size, GFP_KERNEL);
+		if (!walk) {
+			err = -ENOMEM;
 			goto out_fds;
 		}
-		i -= pp->len;
 	}
 
+	poll_initwait(&table);
 	fdcount = do_poll(nfds, head, &table, timeout);
+	if (!fdcount && signal_pending(current))
+		fdcount = -EINTR;
+	poll_freewait(&table);
 
-	/* OK, now copy the revents fields back to user space. */
-	walk = head;
-	err = -EFAULT;
-	while(walk != NULL) {
+	for (walk = head; walk; walk = walk->next) {
 		struct pollfd *fds = walk->entries;
 		int j;
 
-		for (j=0; j < walk->len; j++, ufds++) {
-			if(__put_user(fds[j].revents, &ufds->revents))
+		for (j = 0; j < walk->len; j++, ufds++)
+			if (__put_user(fds[j].revents, &ufds->revents))
 				goto out_fds;
-		}
-		walk = walk->next;
   	}
+
 	err = fdcount;
-	if (!fdcount && signal_pending(current))
-		err = -EINTR;
 out_fds:
-	walk = head;
-	while(walk!=NULL) {
-		struct poll_list *pp = walk->next;
-		if (walk != stack_pp)
-			kfree(walk);
-		walk = pp;
+	walk = head->next;
+	while (walk) {
+		struct poll_list *pos = walk;
+		walk = walk->next;
+		kfree(pos);
 	}
-	poll_freewait(&table);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_poll-return-eintr-when-signalled.patch
