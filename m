From: akpm@linux-foundation.org
Subject: +
 ima-store-the-builtin-custom-template-definitions-in-a-list-v3.patch added
 to -mm tree
Date: Tue, 06 Sep 2016 13:30:01 -0700
Message-ID: <57cf2749.VLb2zNc8PfB4od/n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59659 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933647AbcIFUaC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 16:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima-store-the-builtin-custom-template-definitions-in-a-list-v3
has been added to the -mm tree.  Its filename is
     ima-store-the-builtin-custom-template-definitions-in-a-list-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-store-the-builtin-custom-template-definitions-in-a-list-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-store-the-builtin-custom-template-definitions-in-a-list-v3.patch

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
Subject: ima-store-the-builtin-custom-template-definitions-in-a-list-v3

Link: http://lkml.kernel.org/r/1473170584-15094-7-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_template.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN security/integrity/ima/ima_template.c~ima-store-the-builtin-custom-template-definitions-in-a-list-v3 security/integrity/ima/ima_template.c
--- a/security/integrity/ima/ima_template.c~ima-store-the-builtin-custom-template-definitions-in-a-list-v3
+++ a/security/integrity/ima/ima_template.c
@@ -193,14 +193,6 @@ static int template_desc_init_fields(con
 	return 0;
 }
 
-struct ima_template_desc *ima_template_desc_current(void)
-{
-	if (!ima_template)
-		ima_template =
-		    lookup_template_desc(CONFIG_IMA_DEFAULT_TEMPLATE);
-	return ima_template;
-}
-
 void __init ima_init_template_list(void)
 {
 	int i;
@@ -214,6 +206,14 @@ void __init ima_init_template_list(void)
 	synchronize_rcu();
 }
 
+struct ima_template_desc *ima_template_desc_current(void)
+{
+	if (!ima_template)
+		ima_template =
+		    lookup_template_desc(CONFIG_IMA_DEFAULT_TEMPLATE);
+	return ima_template;
+}
+
 int __init ima_init_template(void)
 {
 	struct ima_template_desc *template = ima_template_desc_current();
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

