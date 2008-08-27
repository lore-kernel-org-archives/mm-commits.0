From: akpm@linux-foundation.org
Subject: + devcgroup-use-kmemdup.patch added to -mm tree
Date: Wed, 27 Aug 2008 14:39:23 -0700
Message-ID: <200808272139.m7RLdN8T023951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYH0VkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 17:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com


The patch titled
     devcgroup: use kmemdup()
has been added to the -mm tree.  Its filename is
     devcgroup-use-kmemdup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: use kmemdup()
From: Li Zefan <lizf@cn.fujitsu.com>

This saves 40 bytes on my x86_32 box.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-use-kmemdup security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-use-kmemdup
+++ a/security/device_cgroup.c
@@ -84,13 +84,9 @@ static int dev_whitelist_copy(struct lis
 	struct dev_whitelist_item *wh, *tmp, *new;
 
 	list_for_each_entry(wh, orig, list) {
-		new = kmalloc(sizeof(*wh), GFP_KERNEL);
+		new = kmemdup(wh, sizeof(*wh), GFP_KERNEL);
 		if (!new)
 			goto free_and_exit;
-		new->major = wh->major;
-		new->minor = wh->minor;
-		new->type = wh->type;
-		new->access = wh->access;
 		list_add_tail(&new->list, dest);
 	}
 
@@ -114,11 +110,10 @@ static int dev_whitelist_add(struct dev_
 {
 	struct dev_whitelist_item *whcopy, *walk;
 
-	whcopy = kmalloc(sizeof(*whcopy), GFP_KERNEL);
+	whcopy = kmemdup(wh, sizeof(*wh), GFP_KERNEL);
 	if (!whcopy)
 		return -ENOMEM;
 
-	memcpy(whcopy, wh, sizeof(*whcopy));
 	spin_lock(&dev_cgroup->lock);
 	list_for_each_entry(walk, &dev_cgroup->whitelist, list) {
 		if (walk->type != wh->type)
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

devcgroup-fix-race-against-rmdir.patch
linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

