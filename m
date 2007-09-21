From: akpm@linux-foundation.org
Subject: + acpi-suspend-consolidate-handling-of-sx-states-addendum.patch added to -mm tree
Date: Fri, 21 Sep 2007 12:00:23 -0700
Message-ID: <200709211900.l8LJ0N7f017806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58597 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbXIUTAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 15:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, astarikovskiy@suse.de, lenb@kernel.org, rjw@sisk.pl


The patch titled
     ACPI: suspend: consolidate handling of Sx states addendum
has been added to the -mm tree.  Its filename is
     acpi-suspend-consolidate-handling-of-sx-states-addendum.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: suspend: consolidate handling of Sx states addendum
From: Frans Pop <elendil@planet.nl>

Make the S0 state be always reported as supported

Signed-off-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/sleep/main.c~acpi-suspend-consolidate-handling-of-sx-states-addendum drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-suspend-consolidate-handling-of-sx-states-addendum
+++ a/drivers/acpi/sleep/main.c
@@ -406,9 +406,11 @@ int __init acpi_sleep_init(void)
 	if (acpi_disabled)
 		return 0;
 
-printk(KERN_INFO PREFIX "(supports");
+	sleep_states[ACPI_STATE_S0] = 1;
+	printk(KERN_INFO PREFIX "(supports S0");
+
 #ifdef CONFIG_SUSPEND
-	for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {
+	for (i = ACPI_STATE_S1; i < ACPI_STATE_S4; i++) {
 		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
 			sleep_states[i] = 1;
_

Patches currently in -mm which might be from elendil@planet.nl are

acpi-suspend-consolidate-handling-of-sx-states-addendum.patch
