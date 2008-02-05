From: akpm@linux-foundation.org
Subject: - acpi-enable-c3-power-state-on-dell-inspiron-8200-update.patch removed from -mm tree
Date: Mon, 04 Feb 2008 23:29:20 -0800
Message-ID: <200802050729.m157T1Xi009584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbYBEHaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 02:30:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dag@bakke.com, arjan@infradead.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi-enable-c3-power-state-on-dell-inspiron-8200-update
has been removed from the -mm tree.  Its filename was
     acpi-enable-c3-power-state-on-dell-inspiron-8200-update.patch

This patch was dropped because it was folded into acpi-enable-c3-power-state-on-dell-inspiron-8200.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi-enable-c3-power-state-on-dell-inspiron-8200-update
From: Dag Bakke <dag@bakke.com>

Tested-by: Arjan van de Ven <arjan@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-enable-c3-power-state-on-dell-inspiron-8200-update drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-enable-c3-power-state-on-dell-inspiron-8200-update
+++ a/drivers/acpi/processor_idle.c
@@ -123,9 +123,9 @@ static int set_max_cstate(const struct d
 }
 
 /*
- * Some (Dell) machines have a too large C3 latency set, but it still works
- * completely.  Dell provides a driver for other operating systems to hack
- * around this bug, so we know it's safe.
+ * Some (Dell) machines set the C3 latency to a value which effectively says:
+ * "Don't use C3." Still, C3 works if we force it.
+ * This enables C3 on Dell Inspiron 8200 machines.
  */
 static int dmi_force_c3(const struct dmi_system_id *id)
 {
_

Patches currently in -mm which might be from dag@bakke.com are

acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-update.patch
