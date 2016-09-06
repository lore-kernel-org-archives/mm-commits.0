From: akpm@linux-foundation.org
Subject: +
 ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3.patch added to -mm tree
Date: Tue, 06 Sep 2016 13:29:56 -0700
Message-ID: <57cf2744.HXIKwMfYE1NN0IqF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59655 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933647AbcIFU35 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 16:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3
has been added to the -mm tree.  Its filename is
     ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3.patch

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
Subject: ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3

Changelog v3:
- include the ima_kexec_hdr size in the binary_runtime_measurement size.

Link: http://lkml.kernel.org/r/1473170584-15094-4-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_queue.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN security/integrity/ima/ima_queue.c~ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3 security/integrity/ima/ima_queue.c
--- a/security/integrity/ima/ima_queue.c~ima-maintain-memory-size-needed-for-serializing-the-measurement-list-v3
+++ a/security/integrity/ima/ima_queue.c
@@ -126,11 +126,15 @@ static int ima_add_digest_entry(struct i
 
 /*
  * Return the amount of memory required for serializing the
- * entire binary_runtime_measurement list.
+ * entire binary_runtime_measurement list, including the ima_kexec_hdr
+ * structure.
  */
 unsigned long ima_get_binary_runtime_size(void)
 {
-	return binary_runtime_size;
+	if (binary_runtime_size >= (ULONG_MAX - sizeof(struct ima_kexec_hdr)))
+		return ULONG_MAX;
+	else
+		return binary_runtime_size + sizeof(struct ima_kexec_hdr);
 };
 
 static int ima_pcr_extend(const u8 *hash, int pcr)
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

