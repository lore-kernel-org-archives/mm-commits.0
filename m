From: akpm@linux-foundation.org
Subject: - devcgroup-use-kmemdup.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:22 -0700
Message-ID: <200810202036.m9KKaMNs011356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYJTUg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devcgroup: use kmemdup()
has been removed from the -mm tree.  Its filename was
     devcgroup-use-kmemdup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

