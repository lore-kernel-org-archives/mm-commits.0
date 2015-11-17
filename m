From: akpm@linux-foundation.org
Subject: + mm-hugetlb-is_file_hugepages-can-be-boolean.patch added to -mm
 tree
Date: Tue, 17 Nov 2015 15:55:24 -0800
Message-ID: <564bbe6c.NZsFBsrp/72D/xK8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbbKQXzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 18:55:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/hugetlb.h: is_file_hugepages() can be boolean
has been added to the -mm tree.  Its filename is
     mm-hugetlb-is_file_hugepages-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-is_file_hugepages-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-is_file_hugepages-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -265,20 +265,18 @@ struct file *hugetlb_file_setup(const ch
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

mm-hugetlb-is_file_hugepages-can-be-boolean.patch
fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

