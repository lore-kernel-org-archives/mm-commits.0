From: akpm@linux-foundation.org
Subject: + powerpc-replace-__function__-with-__func__.patch added to -mm tree
Date: Tue, 29 Jul 2008 16:46:03 -0700
Message-ID: <200807292346.m6TNk3Jl028455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbYG2XqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 19:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, benh@kernel.crashing.org


The patch titled
     powerpc: replace __FUNCTION__ with __func__
has been added to the -mm tree.  Its filename is
     powerpc-replace-__function__-with-__func__.patch

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
Subject: powerpc: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

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
@@ -505,10 +505,10 @@ static ssize_t update_ppp(u64 *entitleme
 		return -EINVAL;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-	         __FUNCTION__, ppp_data.entitlement, ppp_data.weight);
+	         __func__, ppp_data.entitlement, ppp_data.weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-		 __FUNCTION__, new_entitled, new_weight);
+		 __func__, new_entitled, new_weight);
 
 	retval = plpar_hcall_norets(H_SET_PPP, new_entitled, new_weight);
 	return retval;
@@ -551,10 +551,10 @@ static ssize_t update_mpp(u64 *entitleme
 		return -EINVAL;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-	         __FUNCTION__, mpp_data.entitled_mem, mpp_data.mem_weight);
+	         __func__, mpp_data.entitled_mem, mpp_data.mem_weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-	         __FUNCTION__, new_entitled, new_weight);
+	         __func__, new_entitled, new_weight);
 
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

omfs-sparse-annotations.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
irda-replace-__function__-with-__func__.patch
isdn-use-the-common-ascii-hex-helpers.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
misc-replace-__function__-with-__func__.patch

