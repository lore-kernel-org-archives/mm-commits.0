From: akpm@linux-foundation.org
Subject: + acpi-use-macro-to-replace-hard-number.patch added to -mm tree
Date: Tue, 28 Oct 2008 13:17:09 -0700
Message-ID: <200810282017.m9SKH9B9015216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbYJ1URw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 16:17:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org


The patch titled
     acpi: use macro to replace hard number
has been added to the -mm tree.  Its filename is
     acpi-use-macro-to-replace-hard-number.patch

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
Subject: acpi: use macro to replace hard number
From: Yinghai Lu <yinghai@kernel.org>

Impact: cleanup

Use MACRO for rev 3 fadt id instead of 3 directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/tables/tbfadt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/tables/tbfadt.c~acpi-use-macro-to-replace-hard-number drivers/acpi/tables/tbfadt.c
--- a/drivers/acpi/tables/tbfadt.c~acpi-use-macro-to-replace-hard-number
+++ a/drivers/acpi/tables/tbfadt.c
@@ -304,7 +304,7 @@ static void acpi_tb_convert_fadt(void)
 	 * The ACPI 1.0 reserved fields that will be zeroed are the bytes located at
 	 * offset 45, 55, 95, and the word located at offset 109, 110.
 	 */
-	if (acpi_gbl_FADT.header.revision < 3) {
+	if (acpi_gbl_FADT.header.revision < FADT2_REVISION_ID) {
 		acpi_gbl_FADT.preferred_profile = 0;
 		acpi_gbl_FADT.pstate_control = 0;
 		acpi_gbl_FADT.cst_control = 0;
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
acpi-use-macro-to-replace-hard-number.patch

