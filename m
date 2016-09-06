From: akpm@linux-foundation.org
Subject: + ima-platform-independent-hash-value-v3.patch added to -mm tree
Date: Tue, 06 Sep 2016 13:30:07 -0700
Message-ID: <57cf274f.LvFn6mX6DxTPF5aE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933647AbcIFUaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 16:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.steffen@strongswan.org, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima-platform-independent-hash-value-v3
has been added to the -mm tree.  Its filename is
     ima-platform-independent-hash-value-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-platform-independent-hash-value-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-platform-independent-hash-value-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Steffen <andreas.steffen@strongswan.org>
Subject: ima-platform-independent-hash-value-v3

Changelog:
- Define canonical format as little endian (Mimi)

Link: http://lkml.kernel.org/r/1473170584-15094-10-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Andreas Steffen <andreas.steffen@strongswan.org>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_crypto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/integrity/ima/ima_crypto.c~ima-platform-independent-hash-value-v3 security/integrity/ima/ima_crypto.c
--- a/security/integrity/ima/ima_crypto.c~ima-platform-independent-hash-value-v3
+++ a/security/integrity/ima/ima_crypto.c
@@ -477,8 +477,8 @@ static int ima_calc_field_array_hash_tfm
 		u8 buffer[IMA_EVENT_NAME_LEN_MAX + 1] = { 0 };
 		u8 *data_to_hash = field_data[i].data;
 		u32 datalen = field_data[i].len;
-		u32 datalen_to_hash = !ima_canonical_fmt ? datalen :
-			cpu_to_le32(datalen);
+		u32 datalen_to_hash =
+		    !ima_canonical_fmt ? datalen : cpu_to_le32(datalen);
 
 		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
 			rc = crypto_shash_update(shash,
_

Patches currently in -mm which might be from andreas.steffen@strongswan.org are

ima-platform-independent-hash-value.patch
ima-platform-independent-hash-value-v3.patch

