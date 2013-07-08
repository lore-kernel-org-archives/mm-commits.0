From: akpm@linux-foundation.org
Subject: [folded-merged] crypto-add-lz4-cryptographic-api-fix.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 15:35:21 -0700
Message-ID: <51db3ea9.1X8pWnu208CMGH55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3GHWfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, rpearson@systemfabricworks.com, richard@nod.at, kyungsik.lee@lge.com, herbert@gondor.hengli.com.au, fengguang.wu@intel.com, djwong@us.ibm.com, chanho.min@lge.com, akpm@linux-foundation.org

Subject: [folded-merged] crypto-add-lz4-cryptographic-api-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,chanho.min@lge.com,djwong@us.ibm.com,fengguang.wu@intel.com,herbert@gondor.hengli.com.au,kyungsik.lee@lge.com,richard@nod.at,rpearson@systemfabricworks.com,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:35:21 -0700


The patch titled
     Subject: crypto-add-lz4-cryptographic-api-fix
has been removed from the -mm tree.  Its filename was
     crypto-add-lz4-cryptographic-api-fix.patch

This patch was dropped because it was folded into crypto-add-lz4-cryptographic-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: crypto-add-lz4-cryptographic-api-fix

fix warnings

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Yann Collet <yann.collet.73@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/lz4.c   |    3 ++-
 crypto/lz4hc.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN crypto/lz4.c~crypto-add-lz4-cryptographic-api-fix crypto/lz4.c
--- a/crypto/lz4.c~crypto-add-lz4-cryptographic-api-fix
+++ a/crypto/lz4.c
@@ -66,8 +66,9 @@ static int lz4_decompress_crypto(struct
 {
 	int err;
 	size_t tmp_len = *dlen;
+	size_t __slen = slen;
 
-	err = lz4_decompress(src, &slen, dst, tmp_len);
+	err = lz4_decompress(src, &__slen, dst, tmp_len);
 	if (err < 0)
 		return -EINVAL;
 
diff -puN crypto/lz4hc.c~crypto-add-lz4-cryptographic-api-fix crypto/lz4hc.c
--- a/crypto/lz4hc.c~crypto-add-lz4-cryptographic-api-fix
+++ a/crypto/lz4hc.c
@@ -66,8 +66,9 @@ static int lz4hc_decompress_crypto(struc
 {
 	int err;
 	size_t tmp_len = *dlen;
+	size_t __slen = slen;
 
-	err = lz4_decompress(src, &slen, dst, tmp_len);
+	err = lz4_decompress(src, &__slen, dst, tmp_len);
 	if (err < 0)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
partitions-add-aix-lvm-partition-support-files.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch

