From: akpm@linux-foundation.org
Subject: [merged] edac-build-fix.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:01:55 -0700
Message-ID: <200906032001.n53K1tGe001246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbZFCUB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borislav.petkov@amd.com, mm-commits@vger.kernel.org


The patch titled
     edac: build fix
has been removed from the -mm tree.  Its filename was
     edac-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: build fix
From: Borislav Petkov <borislav.petkov@amd.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd64_edac.c |    2 +-
 drivers/edac/amd64_edac.h |   13 -------------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff -puN drivers/edac/amd64_edac.c~edac-build-fix drivers/edac/amd64_edac.c
--- a/drivers/edac/amd64_edac.c~edac-build-fix
+++ a/drivers/edac/amd64_edac.c
@@ -1419,7 +1419,7 @@ static u32 f10_determine_channel(struct 
 		if (dct_sel_interleave_addr(pvt) == 0)
 			cs = sys_addr >> 6 & 1;
 		else if ((dct_sel_interleave_addr(pvt) >> 1) & 1) {
-			temp = popcnt((u32) ((sys_addr >> 16) & 0x1F)) % 2;
+			temp = hweight_long((u32) ((sys_addr >> 16) & 0x1F)) % 2;
 
 			if (dct_sel_interleave_addr(pvt) & 1)
 				cs = (sys_addr >> 9 & 1) ^ temp;
diff -puN drivers/edac/amd64_edac.h~edac-build-fix drivers/edac/amd64_edac.h
--- a/drivers/edac/amd64_edac.h~edac-build-fix
+++ a/drivers/edac/amd64_edac.h
@@ -443,19 +443,6 @@ enum {
 #define K8_MSR_MC4STAT			0x0411
 #define K8_MSR_MC4ADDR			0x0412
 
-/*
- * popcnt - count the set bits in a bit vector.
- * @vec - bit vector
- *
- * This instruction is supported only on F10h and later CPUs.
- */
-#define popcnt(x)						\
-({								\
-	typeof(x) __ret;					\
-	__asm__("popcnt %1, %0" : "=r" (__ret) : "r" (x));	\
-	__ret;							\
-})
