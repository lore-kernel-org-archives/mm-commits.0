From: akpm@linux-foundation.org
Subject: + thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef.patch added
 to -mm tree
Date: Tue, 09 Aug 2016 15:29:31 -0700
Message-ID: <57aa594b.w8wbqnP7x4anV/C8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbcHIW3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 18:29:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: move shmem_huge_enabled() outside of SYSFS ifdef
has been added to the -mm tree.  Its filename is
     thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

thp-move-shmem_huge_enabled-outside-of-sysfs-ifdef.patch
compat-remove-compat_printk.patch

