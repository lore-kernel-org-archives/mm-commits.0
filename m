From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-must-include-asm-ioh.patch added to -mm tree
Date: Sun, 27 Jul 2008 12:19:42 -0700
Message-ID: <200807271919.m6RJJgtU000816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757508AbYG0TUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 15:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, takata@linux-m32r.org


The patch titled
     mm/hugetlb.c must #include <asm/io.h>
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-must-include-asm-ioh.patch

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
Subject: mm/hugetlb.c must #include <asm/io.h>
From: Adrian Bunk <bunk@kernel.org>

This patch fixes the following build error on sh caused by
commit aa888a74977a8f2120ae9332376e179c39a6b07d
(hugetlb: support larger than MAX_ORDER):

/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/hugetlb.c:958: error: implicit declaration of function 'virt_to_phys'

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~mm-hugetlbc-must-include-asm-ioh mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-must-include-asm-ioh
+++ a/mm/hugetlb.c
@@ -20,6 +20,7 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/io.h>
 
 #include <linux/hugetlb.h>
 #include "internal.h"
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
exec-include-pagemaph-again-to-fix-build.patch
mm-utilc-must-include-linux-schedh.patch
mm-hugetlbc-must-include-asm-ioh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

