From: akpm@linux-foundation.org
Subject: - acpi-suspend-consolidate-handling-of-sx-states-addendum.patch removed from -mm tree
Date: Sun, 23 Sep 2007 17:51:37 -0700
Message-ID: <200709240051.l8O0pc7x002467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbXIXAvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 23 Sep 2007 20:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, astarikovskiy@suse.de, lenb@kernel.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     ACPI: suspend: consolidate handling of Sx states addendum
has been removed from the -mm tree.  Its filename was
     acpi-suspend-consolidate-handling-of-sx-states-addendum.patch

This patch was dropped because cpuidle got dropped from git-acpi

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

origin.patch
acpi-suspend-consolidate-handling-of-sx-states-addendum.patch
