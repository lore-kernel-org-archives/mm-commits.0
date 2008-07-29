From: akpm@linux-foundation.org
Subject: - mm-hugetlbc-must-include-asm-ioh.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:29:53 -0700
Message-ID: <200807292029.m6TKTrZ4019732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbYG2UaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     mm/hugetlb.c must #include <asm/io.h>
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-must-include-asm-ioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
git-alsa-tiwai.patch
m32r-remove-the-unused-nohighmem-option.patch
git-security-testing.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

