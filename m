From: akpm@linux-foundation.org
Subject: + sysctl-protect-poll-in-entries-that-may-go-away.patch added to -mm tree
Date: Tue, 20 Mar 2012 13:12:32 -0700
Message-ID: <20120320201233.118FAA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:39401 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2CTUMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Mar 2012 16:12:34 -0400
Received: by vcbfk26 with SMTP id fk26so77115vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Mar 2012 13:12:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucas.demarchi@profusion.mobi, adobriyan@gmail.com, davej@redhat.com, ebiederm@xmission.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: sysctl: protect poll() in entries that may go away
has been added to the -mm tree.  Its filename is
     sysctl-protect-poll-in-entries-that-may-go-away.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: sysctl: protect poll() in entries that may go away

Protect code accessing ctl_table by grabbing the header with grab_header()
and after releasing with sysctl_head_finish().  This is needed if poll()
is called in entries created by modules: currently only hostname and
domainname support poll(), but this bug may be triggered when/if modules
use it and if user called poll() in a file that doesn't support it.

Dave Jones reported the following when using a syscall fuzzer while
hibernating/resuming:

RIP: 0010:[<ffffffff81233e3e>]  [<ffffffff81233e3e>] proc_sys_poll+0x4e/0x90
RAX: 0000000000000145 RBX: ffff88020cab6940 RCX: 0000000000000000
RDX: ffffffff81233df0 RSI: 6b6b6b6b6b6b6b6b RDI: ffff88020cab6940
[ ... ]
Code: 00 48 89 fb 48 89 f1 48 8b 40 30 4c 8b 60 e8 b8 45 01 00 00 49 83
7c 24 28 00 74 2e 49 8b 74 24 30 48 85 f6 74 24 48 85 c9 75 32 <8b> 16
b8 45 01 00 00 48 63 d2 49 39 d5 74 10 8b 06 48 98 48 89

If an entry goes away while we are polling() it, ctl_table may not exist
anymore.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-protect-poll-in-entries-that-may-go-away fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-protect-poll-in-entries-that-may-go-away
+++ a/fs/proc/proc_sysctl.c
@@ -527,20 +527,32 @@ static ssize_t proc_sys_write(struct fil
 
 static int proc_sys_open(struct inode *inode, struct file *filp)
 {
+	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 
+	/* sysctl was unregistered */
+	if (IS_ERR(head))
+		return PTR_ERR(head);
+
 	if (table->poll)
 		filp->private_data = proc_sys_poll_event(table->poll);
 
+	sysctl_head_finish(head);
+
 	return 0;
 }
 
 static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
-	unsigned long event = (unsigned long)filp->private_data;
 	unsigned int ret = DEFAULT_POLLMASK;
+	unsigned long event;
+
+	/* sysctl was unregistered */
+	if (IS_ERR(head))
+		return POLLERR | POLLHUP;
 
 	if (!table->proc_handler)
 		goto out;
@@ -548,6 +560,7 @@ static unsigned int proc_sys_poll(struct
 	if (!table->poll)
 		goto out;
 
+	event = (unsigned long)filp->private_data;
 	poll_wait(filp, &table->poll->wait, wait);
 
 	if (event != atomic_read(&table->poll->event)) {
@@ -556,6 +569,8 @@ static unsigned int proc_sys_poll(struct
 	}
 
 out:
+	sysctl_head_finish(head);
+
 	return ret;
 }
 
_
Subject: Subject: sysctl: protect poll() in entries that may go away

Patches currently in -mm which might be from lucas.demarchi@profusion.mobi are

linux-next.patch
sysctl-protect-poll-in-entries-that-may-go-away.patch

