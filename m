From: akpm@linux-foundation.org
Subject: + ima-platform-independent-hash-value.patch added to -mm tree
Date: Mon, 24 Oct 2016 12:42:54 -0700
Message-ID: <580e643e.UDgpfdWDAzhYlZDg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56775 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941125AbcJXTmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.steffen@strongswan.org, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, sklar@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: platform-independent hash value
has been added to the -mm tree.  Its filename is
     ima-platform-independent-hash-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-platform-independent-hash-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-platform-independent-hash-value.patch

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
Subject: ima: platform-independent hash value

For remote attestion it is important for the ima measurement values to be
platform-independent.  Therefore integer fields to be hashed must be
converted to canonical format.

Link: http://lkml.kernel.org/r/1477017898-10375-11-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Andreas Steffen <andreas.steffen@strongswan.org>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_crypto.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN security/integrity/ima/ima_crypto.c~ima-platform-independent-hash-value security/integrity/ima/ima_crypto.c
--- a/security/integrity/ima/ima_crypto.c~ima-platform-independent-hash-value
+++ a/security/integrity/ima/ima_crypto.c
@@ -477,11 +477,13 @@ static int ima_calc_field_array_hash_tfm
 		u8 buffer[IMA_EVENT_NAME_LEN_MAX + 1] = { 0 };
 		u8 *data_to_hash = field_data[i].data;
 		u32 datalen = field_data[i].len;
+		u32 datalen_to_hash =
+		    !ima_canonical_fmt ? datalen : cpu_to_le32(datalen);
 
 		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
 			rc = crypto_shash_update(shash,
-						(const u8 *) &field_data[i].len,
-						sizeof(field_data[i].len));
+						(const u8 *) &datalen_to_hash,
+						sizeof(datalen_to_hash));
 			if (rc)
 				break;
 		} else if (strcmp(td->fields[i]->field_id, "n") == 0) {
_

Patches currently in -mm which might be from andreas.steffen@strongswan.org are

ima-platform-independent-hash-value.patch

