From: akpm@linux-foundation.org
Subject: [merged] thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef.patch removed from -mm tree
Date: Thu, 11 Aug 2016 11:36:04 -0700
Message-ID: <57acc594.QNK6NFfddolH7x0m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbcHKSgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 14:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: move shmem_huge_enabled() outside of SYSFS ifdef
has been removed from the -mm tree.  Its filename was
     thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: thp: move shmem_huge_enabled() outside of SYSFS ifdef

The newly introduced shmem_huge_enabled() function has two definitions,
but neither of them is visible if CONFIG_SYSFS is disabled, leading to a
build error:

mm/khugepaged.o: In function `khugepaged':
khugepaged.c:(.text.khugepaged+0x3ca): undefined reference to `shmem_huge_enabled'

This changes the #ifdef guards around the definition to match those that
are used in the header file.

Fixes: e496cf3d7821 ("thp: introduce CONFIG_TRANSPARENT_HUGE_PAGECACHE")
Link: http://lkml.kernel.org/r/20160809123638.1357593-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef mm/shmem.c
--- a/mm/shmem.c~thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef
+++ a/mm/shmem.c
@@ -3975,7 +3975,9 @@ static ssize_t shmem_enabled_store(struc
 
 struct kobj_attribute shmem_enabled_attr =
 	__ATTR(shmem_enabled, 0644, shmem_enabled_show, shmem_enabled_store);
+#endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE && CONFIG_SYSFS */
 
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
 bool shmem_huge_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(vma->vm_file);
@@ -4006,7 +4008,7 @@ bool shmem_huge_enabled(struct vm_area_s
 			return false;
 	}
 }
-#endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE && CONFIG_SYSFS */
+#endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE */
 
 #else /* !CONFIG_SHMEM */
 
_

Patches currently in -mm which might be from arnd@arndb.de are

compat-remove-compat_printk.patch

