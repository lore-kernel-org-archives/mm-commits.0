From: akpm@linux-foundation.org
Subject: + acpi-fix-unused-variable-warning-in-sbsc.patch added to -mm tree
Date: Thu, 07 Jan 2010 15:04:27 -0800
Message-ID: <201001072304.o07N4Ri5022831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840Ab0AGXFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 18:05:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, astarikovskiy@suse.de, lenb@kernel.org


The patch titled
     acpi: fix unused variable warning in sbs.c
has been added to the -mm tree.  Its filename is
     acpi-fix-unused-variable-warning-in-sbsc.patch

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

linux-next.patch
acpi-fix-unused-variable-warning-in-sbsc.patch
hugetlb-fix-section-mismatch-warning-in-hugetlbc.patch

