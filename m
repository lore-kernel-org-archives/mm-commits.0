From: akpm@linux-foundation.org
Subject: [merged] acpi-fix-unused-variable-warning-in-sbsc.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:37 -0800
Message-ID: <201001212128.o0LLSbCC030726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363Ab0AUV3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, astarikovskiy@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix unused variable warning in sbs.c
has been removed from the -mm tree.  Its filename was
     acpi-fix-unused-variable-warning-in-sbsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix unused variable warning in sbs.c
From: Rakib Mullick <rakib.mullick@gmail.com>

When CONFIG_ACPI_SYSFS_POWER=n and CONFIG_ACPI_PROCFS_POWER=n, then
we're warned by the following warning:

drivers/acpi/sbs.c: In function `acpi_battery_remove':
drivers/acpi/sbs.c:825: warning: unused variable `battery'

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/acpi/sbs.c~acpi-fix-unused-variable-warning-in-sbsc drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-fix-unused-variable-warning-in-sbsc
+++ a/drivers/acpi/sbs.c
@@ -822,7 +822,10 @@ static int acpi_battery_add(struct acpi_
 
 static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
+#if defined(CONFIG_ACPI_SYSFS_POWER) || defined(CONFIG_ACPI_PROCFS_POWER)
 	struct acpi_battery *battery = &sbs->battery[id];
+#endif
+
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	if (battery->bat.dev) {
 		if (battery->have_sysfs_alarm)
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
linux-next.patch
smp-fix-documentation-in-include-linux-smph.patch

