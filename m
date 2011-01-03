From: akpm@linux-foundation.org
Subject: + crypto-dont-return-ptr_err-of-wrong-pointer.patch added to -mm tree
Date: Mon, 03 Jan 2011 12:02:56 -0800
Message-ID: <201101032002.p03K2ueV025960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837Ab1ACUDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 15:03:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, herbert@gondor.hengli.com.au


The patch titled
     crypto: don't return PTR_ERR() of wrong pointer
has been added to the -mm tree.  Its filename is
     crypto-dont-return-ptr_err-of-wrong-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

btrfs-dont-dereference-extent_mapping-if-null.patch
regulator-missing-index-in-ptr_err-in-isl6271a_probe.patch
crypto-dont-return-ptr_err-of-wrong-pointer.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

