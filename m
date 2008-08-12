From: akpm@linux-foundation.org
Subject: - acpi-ec-avoid-dropping-rapid-hotkey-events-or-other-gpes-on-asus-eeepc.patch removed from -mm tree
Date: Tue, 12 Aug 2008 16:29:06 -0700
Message-ID: <200808122329.m7CNT6eA019336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbYHLX3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aj504@student.cs.york.ac.uk, alan-jenkins@tuffmail.co.uk, andi@firstfloor.org, astarikovskiy@suse.de, len.brown@intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: ec: avoid dropping rapid hotkey events (or other GPEs) on Asus EeePC
has been removed from the -mm tree.  Its filename was
     acpi-ec-avoid-dropping-rapid-hotkey-events-or-other-gpes-on-asus-eeepc.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: ec: avoid dropping rapid hotkey events (or other GPEs) on Asus EeePC
From: Alan Jenkins <aj504@student.cs.york.ac.uk>

It looks like this EC clears the SMI_EVT bit after every query, even if
there are more events pending.  The workaround is to repeatedly query the
EC until it reports that no events remain.

This fixes a regression in 2.6.26 (from 2.6.25.3).  Initially reported as
"Asus Eee PC hotkeys stop working if pressed quickly" in bugzilla
<http://bugzilla.kernel.org/show_bug.cgi?id=11089>.

The regression was caused by a recently added check for interrupt storms. 
The Eee PC triggers this check and switches to polling.  When multiple
events arrive between polling intervals, only one is fetched from the EC. 
This causes erroneous behaviour; ultimately events stop being delivered
altogether when the EC buffer overflows.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ec.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/ec.c~acpi-ec-avoid-dropping-rapid-hotkey-events-or-other-gpes-on-asus-eeepc drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-ec-avoid-dropping-rapid-hotkey-events-or-other-gpes-on-asus-eeepc
+++ a/drivers/acpi/ec.c
@@ -461,14 +461,10 @@ void acpi_ec_remove_query_handler(struct
 
 EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
 
-static void acpi_ec_gpe_query(void *ec_cxt)
+static void acpi_ec_gpe_run_handler(struct acpi_ec *ec, u8 value)
 {
-	struct acpi_ec *ec = ec_cxt;
-	u8 value = 0;
 	struct acpi_ec_query_handler *handler, copy;
 
-	if (!ec || acpi_ec_query(ec, &value))
-		return;
 	mutex_lock(&ec->lock);
 	list_for_each_entry(handler, &ec->list, node) {
 		if (value == handler->query_bit) {
@@ -486,6 +482,18 @@ static void acpi_ec_gpe_query(void *ec_c
 	mutex_unlock(&ec->lock);
 }
 
+static void acpi_ec_gpe_query(void *ec_cxt)
+{
+	struct acpi_ec *ec = ec_cxt;
+	u8 value = 0;
+
+	if (!ec)
+		return;
+
+	while (!acpi_ec_query(ec, &value))
+		acpi_ec_gpe_run_handler(ec, value);
+}
+
 static u32 acpi_ec_gpe_handler(void *data)
 {
 	acpi_status status = AE_OK;
_

Patches currently in -mm which might be from aj504@student.cs.york.ac.uk are

acpi-ec-avoid-dropping-rapid-hotkey-events-or-other-gpes-on-asus-eeepc.patch

