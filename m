From: akpm@linux-foundation.org
Subject: - hugetlb-follow_hugetlb_page-for-write-access-fix.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:42:28 -0800
Message-ID: <200711150042.lAF0gSj5001966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755644AbXKOAnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:43:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ezk@cs.sunysb.edu, agl@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     mm/memory.c follow_hugetlb_page compiler error (MMOTM)
has been removed from the -mm tree.  Its filename was
     hugetlb-follow_hugetlb_page-for-write-access-fix.patch

This patch was dropped because it was folded into hugetlb-follow_hugetlb_page-for-write-access.patch

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

hugetlb-follow_hugetlb_page-for-write-access.patch
hugetlb-follow_hugetlb_page-for-write-access-fix.patch
