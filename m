From: akpm@linux-foundation.org
Subject: +
 ima-define-a-canonical-binary_runtime_measurements-list-format-v3.patch
 added to -mm tree
Date: Tue, 06 Sep 2016 13:30:05 -0700
Message-ID: <57cf274d.jUg78evU/TaV2DOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59665 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933647AbcIFUaG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 16:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima-define-a-canonical-binary_runtime_measurements-list-format-v3
has been added to the -mm tree.  Its filename is
     ima-define-a-canonical-binary_runtime_measurements-list-format-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-define-a-canonical-binary_runtime_measurements-list-format-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-define-a-canonical-binary_runtime_measurements-list-format-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima-define-a-canonical-binary_runtime_measurements-list-format-v3

Changelog v3:
- restore PCR value properly

Link: http://lkml.kernel.org/r/1473170584-15094-9-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_template.c     |    4 ++--
 security/integrity/ima/ima_template_lib.c |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN security/integrity/ima/ima_template.c~ima-define-a-canonical-binary_runtime_measurements-list-format-v3 security/integrity/ima/ima_template.c
--- a/security/integrity/ima/ima_template.c~ima-define-a-canonical-binary_runtime_measurements-list-format-v3
+++ a/security/integrity/ima/ima_template.c
@@ -462,8 +462,8 @@ int ima_restore_measurement_list(loff_t
 			break;
 
 		memcpy(entry->digest, hdr_v1->digest, TPM_DIGEST_SIZE);
-		if (ima_canonical_fmt)
-			entry->pcr = le32_to_cpu(hdr_v1->pcr);
+		entry->pcr =
+		    !ima_canonical_fmt ? hdr_v1->pcr : le32_to_cpu(hdr_v1->pcr);
 		ret = ima_restore_measurement_entry(entry);
 		if (ret < 0)
 			break;
diff -puN security/integrity/ima/ima_template_lib.c~ima-define-a-canonical-binary_runtime_measurements-list-format-v3 security/integrity/ima/ima_template_lib.c
--- a/security/integrity/ima/ima_template_lib.c~ima-define-a-canonical-binary_runtime_measurements-list-format-v3
+++ a/security/integrity/ima/ima_template_lib.c
@@ -105,6 +105,7 @@ static void ima_show_template_data_binar
 
 	if (show != IMA_SHOW_BINARY_NO_FIELD_LEN) {
 		u32 field_len = !ima_canonical_fmt ? len : cpu_to_le32(len);
+
 		ima_putc(m, &field_len, sizeof(field_len));
 	}
 
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-restore-the-measurement-list.patch
ima-permit-duplicate-measurement-list-entries.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3.patch
ima-serialize-the-binary_runtime_measurements.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-store-the-builtin-custom-template-definitions-in-a-list-v3.patch
ima-support-restoring-multiple-template-formats.patch
ima-support-restoring-multiple-template-formats-v3.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch
ima-define-a-canonical-binary_runtime_measurements-list-format-v3.patch

