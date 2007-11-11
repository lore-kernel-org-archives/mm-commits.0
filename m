From: akpm@linux-foundation.org
Subject: + hugetlb-follow_hugetlb_page-for-write-access-fix.patch added to -mm tree
Date: Sat, 10 Nov 2007 18:19:28 -0800
Message-ID: <200711110219.lAB2JSw7015891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbXKKCT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Nov 2007 21:19:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu, agl@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, wli@holomorphy.com


The patch titled
     mm/memory.c follow_hugetlb_page compiler error (MMOTM)
has been added to the -mm tree.  Its filename is
     hugetlb-follow_hugetlb_page-for-write-access-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/memory.c follow_hugetlb_page compiler error (MMOTM)
From: Erez Zadok <ezk@cs.sunysb.edu>

Using http://userweb.kernel.org/~akpm/mmotm/ timestamped "10-Nov-2007
22:46". CONFIG_HUGETLB_PAGE not set.

$ make
  CC      mm/memory.o
mm/memory.c:1040:29: error: macro "follow_hugetlb_page" passed 8 arguments, but takes just 7
mm/memory.c: In function 'get_user_pages':
mm/memory.c:1039: error: 'follow_hugetlb_page' undeclared (first use in this function)
mm/memory.c:1039: error: (Each undeclared identifier is reported only once
mm/memory.c:1039: error: for each function it appears in.)
make[1]: *** [mm/memory.o] Error 1
make: *** [mm] Error 2

Small patch below fixes compile error.

Erez.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlb-follow_hugetlb_page-for-write-access-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-follow_hugetlb_page-for-write-access-fix
+++ a/include/linux/hugetlb.h
@@ -106,7 +106,7 @@ static inline unsigned long hugetlb_tota
 	return 0;
 }
 
-#define follow_hugetlb_page(m,v,p,vs,a,b,i)	({ BUG(); 0; })
+#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
 #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

hugetlb-follow_hugetlb_page-for-write-access-fix.patch
git-unionfs.patch
unionfs-clear-partial-read.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
