From: akpm@linux-foundation.org
Subject: +
 mm-shmem-fix-handling-sys-kernel-mm-transparent_hugepage-shmem_enabled.patch added to -mm tree
Date: Tue, 22 Aug 2017 15:20:30 -0700
Message-ID: <599cae2e.uy/shvvel4lX3yc7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbdHVWUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 18:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dan.carpenter@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, shmem: fix handling /sys/kernel/mm/transparent_hugepage/shmem_enabled
has been added to the -mm tree.  Its filename is
     mm-shmem-fix-handling-sys-kernel-mm-transparent_hugepage-shmem_enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-fix-handling-sys-kernel-mm-transparent_hugepage-shmem_enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-fix-handling-sys-kernel-mm-transparent_hugepage-shmem_enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, shmem: fix handling /sys/kernel/mm/transparent_hugepage/shmem_enabled

/sys/kernel/mm/transparent_hugepage/shmem_enabled controls if we want to
allocate huge pages when allocate pages for private in-kernel shmem mount.

Unfortunately, as Dan noticed, I've screwed it up and the only way to make
kernel allocate huge page for the mount is to use "force" there.  All
other values will be effectively ignored.

Link: http://lkml.kernel.org/r/20170822144254.66431-1-kirill.shutemov@linux.intel.com
Fixes: 5a6e75f8110c ("shmem: prepare huge= mount option and sysfs knob")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org> [4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/shmem.c~mm-shmem-fix-handling-sys-kernel-mm-transparent_hugepage-shmem_enabled mm/shmem.c
--- a/mm/shmem.c~mm-shmem-fix-handling-sys-kernel-mm-transparent_hugepage-shmem_enabled
+++ a/mm/shmem.c
@@ -3967,7 +3967,7 @@ int __init shmem_init(void)
 	}
 
 #ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
-	if (has_transparent_hugepage() && shmem_huge < SHMEM_HUGE_DENY)
+	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = 0; /* just in case it was patched */
@@ -4028,7 +4028,7 @@ static ssize_t shmem_enabled_store(struc
 		return -EINVAL;
 
 	shmem_huge = huge;
-	if (shmem_huge < SHMEM_HUGE_DENY)
+	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	return count;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-shmem-fix-handling-sys-kernel-mm-transparent_hugepage-shmem_enabled.patch

