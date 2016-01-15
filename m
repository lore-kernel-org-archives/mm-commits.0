From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-is_file_hugepages-can-be-boolean.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:32:50 -0800
Message-ID: <56997392.2r5o9qVMr1FGaLSg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbcAOWcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/hugetlb.h: is_file_hugepages() can be boolean
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-is_file_hugepages-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: include/linux/hugetlb.h: is_file_hugepages() can be boolean

Make is_file_hugepages() return bool to improve readability due to this
particular function only using either one or zero as its return value.

This patch also removed the if condition to make is_file_hugepages
return directly.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-is_file_hugepages-can-be-boolean include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-is_file_hugepages-can-be-boolean
+++ a/include/linux/hugetlb.h
@@ -263,20 +263,18 @@ struct file *hugetlb_file_setup(const ch
 				struct user_struct **user, int creat_flags,
 				int page_size_log);
 
-static inline int is_file_hugepages(struct file *file)
+static inline bool is_file_hugepages(struct file *file)
 {
 	if (file->f_op == &hugetlbfs_file_operations)
-		return 1;
-	if (is_file_shm_hugepages(file))
-		return 1;
+		return true;
 
-	return 0;
+	return is_file_shm_hugepages(file);
 }
 
 
 #else /* !CONFIG_HUGETLBFS */
 
-#define is_file_hugepages(file)			0
+#define is_file_hugepages(file)			false
 static inline struct file *
 hugetlb_file_setup(const char *name, size_t size, vm_flags_t acctflag,
 		struct user_struct **user, int creat_flags,
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
init-mainc-obsolete_checksetup-can-be-boolean.patch
init-do_mounts-initrd_load-can-be-boolean.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

