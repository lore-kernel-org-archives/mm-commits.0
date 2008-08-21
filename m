From: akpm@linux-foundation.org
Subject: - powerpc-replace-__function__-with-__func__.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:50:05 -0700
Message-ID: <200808210350.m7L3o5U8015692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036AbYHUDuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: replace __FUNCTION__ with __func__
has been removed from the -mm tree.  Its filename was
     powerpc-replace-__function__-with-__func__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/lparcfg.c        |    8 ++++----
 arch/powerpc/platforms/pseries/cmm.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/kernel/lparcfg.c~powerpc-replace-__function__-with-__func__ arch/powerpc/kernel/lparcfg.c
--- a/arch/powerpc/kernel/lparcfg.c~powerpc-replace-__function__-with-__func__
+++ a/arch/powerpc/kernel/lparcfg.c
@@ -510,10 +510,10 @@ static ssize_t update_ppp(u64 *entitleme
 		return -EINVAL;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-	         __FUNCTION__, ppp_data.entitlement, ppp_data.weight);
+		 __func__, ppp_data.entitlement, ppp_data.weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-		 __FUNCTION__, new_entitled, new_weight);
+		 __func__, new_entitled, new_weight);
 
 	retval = plpar_hcall_norets(H_SET_PPP, new_entitled, new_weight);
 	return retval;
@@ -556,10 +556,10 @@ static ssize_t update_mpp(u64 *entitleme
 		return -EINVAL;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-	         __FUNCTION__, mpp_data.entitled_mem, mpp_data.mem_weight);
+	         __func__, mpp_data.entitled_mem, mpp_data.mem_weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-	         __FUNCTION__, new_entitled, new_weight);
+		 __func__, new_entitled, new_weight);
 
 	rc = plpar_hcall_norets(H_SET_MPP, new_entitled, new_weight);
 	return rc;
diff -puN arch/powerpc/platforms/pseries/cmm.c~powerpc-replace-__function__-with-__func__ arch/powerpc/platforms/pseries/cmm.c
--- a/arch/powerpc/platforms/pseries/cmm.c~powerpc-replace-__function__-with-__func__
+++ a/arch/powerpc/platforms/pseries/cmm.c
@@ -121,7 +121,7 @@ static long cmm_alloc_pages(long nr)
 			npa = (struct cmm_page_array *)__get_free_page(GFP_NOIO | __GFP_NOWARN |
 								       __GFP_NORETRY | __GFP_NOMEMALLOC);
 			if (!npa) {
-				pr_info("%s: Can not allocate new page list\n", __FUNCTION__);
+				pr_info("%s: Can not allocate new page list\n", __func__);
 				free_page(addr);
 				break;
 			}
@@ -138,7 +138,7 @@ static long cmm_alloc_pages(long nr)
 		}
 
 		if ((rc = plpar_page_set_loaned(__pa(addr)))) {
-			pr_err("%s: Can not set page to loaned. rc=%ld\n", __FUNCTION__, rc);
+			pr_err("%s: Can not set page to loaned. rc=%ld\n", __func__, rc);
 			spin_unlock(&cmm_lock);
 			free_page(addr);
 			break;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

