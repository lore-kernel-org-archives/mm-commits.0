From: akpm@linux-foundation.org
Subject: [merged] crypto-dont-return-ptr_err-of-wrong-pointer.patch removed from -mm tree
Date: Wed, 05 Jan 2011 11:28:32 -0800
Message-ID: <201101051930.p05JU7tf014083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab1AETaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 14:30:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, herbert@gondor.hengli.com.au, mm-commits@vger.kernel.org


The patch titled
     crypto: don't return PTR_ERR() of wrong pointer
has been removed from the -mm tree.  Its filename was
     crypto-dont-return-ptr_err-of-wrong-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crypto: don't return PTR_ERR() of wrong pointer
From: roel kluin <roel.kluin@gmail.com>

Fix a PTR_ERR() return of the wrong pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/mv_cesa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/crypto/mv_cesa.c~crypto-dont-return-ptr_err-of-wrong-pointer drivers/crypto/mv_cesa.c
--- a/drivers/crypto/mv_cesa.c~crypto-dont-return-ptr_err-of-wrong-pointer
+++ a/drivers/crypto/mv_cesa.c
@@ -857,7 +857,7 @@ static int mv_cra_hash_init(struct crypt
 			printk(KERN_WARNING MV_CESA
 			       "Base driver '%s' could not be loaded!\n",
 			       base_hash_name);
-			err = PTR_ERR(fallback_tfm);
+			err = PTR_ERR(base_hash);
 			goto err_bad_base;
 		}
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
macintosh-wrong-test-in-fan_readwrite_reg.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

