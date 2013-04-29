From: akpm@linux-foundation.org
Subject: [folded-merged] mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:50:44 -0700
Message-ID: <20130429215045.3AFAB5A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:39342 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab3D2Vuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:50:46 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so146882qen.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:50:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agshew@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9
has been removed from the -mm tree.  Its filename was
     mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9.patch

This patch was dropped because it was folded into mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch

------------------------------------------------------
From: Andrew Shewmaker <agshew@gmail.com>
Subject: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9

 * Explanatory comments for magic numbers in memory notifier



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/mmap.c~mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9 mm/mmap.c
--- a/mm/mmap.c~mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9
+++ a/mm/mmap.c
@@ -3147,6 +3147,13 @@ module_init(init_admin_reserve)
 /*
  * Reinititalise user and admin reserves if memory is added or removed.
  *
+ * The default user reserve max is 128MB, and the default max for the
+ * admin reserve is 8MB. These are usually, but not always, enough to
+ * enable recovery from a memory hogging process using login/sshd, a shell,
+ * and tools like top. It may make sense to increase or even disable the
+ * reserve depending on the existence of swap or variations in the recovery
+ * tools. So, the admin may have changed them.
+ *
  * If memory is added and the reserves have been eliminated or increased above
  * the default max, then we'll trust the admin.
  *
@@ -3162,10 +3169,16 @@ static int reserve_mem_notifier(struct n
 
 	switch (action) {
 	case MEM_ONLINE:
+		/*
+		 * Default max is 128MB. Leave alone if modified by operator.
+ 		 */
 		tmp = sysctl_user_reserve_kbytes;
 		if (0 < tmp && tmp < (1UL << 17))
 			init_user_reserve();
 
+		/*
+		 * Default max is 8MB. Leave alone if modified by operator.
+ 		 */
 		tmp = sysctl_admin_reserve_kbytes;
 		if (0 < tmp && tmp < (1UL << 13))
 			init_admin_reserve();
_

Patches currently in -mm which might be from agshew@gmail.com are

include-linux-memoryh-implement-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix.patch

