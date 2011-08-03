From: akpm@linux-foundation.org
Subject: [merged] acpi-add-missing-_osi-strings-resend.patch removed from -mm tree
Date: Wed, 03 Aug 2011 11:59:56 -0700
Message-ID: <201108031857.p73IvPw8006735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349Ab1HCS6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, lenb@kernel.org, mjg@redhat.com, sebastian.jarosz@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: add missing _OSI strings
has been removed from the -mm tree.  Its filename was
     acpi-add-missing-_osi-strings-resend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: add missing _OSI strings
From: Shaohua Li <shaohua.li@intel.com>

Linux supports some optional features, but it should notify the BIOS about
them via the _OSI method.  Currently Linux doesn't notify any, which might
make such features not work because the BIOS doesn't know about them.

Jarosz has a system which needs this to make ACPI processor aggregator
device work.

Reported-by: "Jarosz, Sebastian" <sebastian.jarosz@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/osl.c~acpi-add-missing-_osi-strings-resend drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~acpi-add-missing-_osi-strings-resend
+++ a/drivers/acpi/osl.c
@@ -1098,7 +1098,13 @@ struct osi_setup_entry {
 	bool enable;
 };
 
-static struct osi_setup_entry __initdata osi_setup_entries[OSI_STRING_ENTRIES_MAX];
+static struct osi_setup_entry __initdata
+		osi_setup_entries[OSI_STRING_ENTRIES_MAX] = {
+	{"Module Device", true},
+	{"Processor Device", true},
+	{"3.0 _SCP Extensions", true},
+	{"Processor Aggregator Device", true},
+};
 
 void __init acpi_osi_setup(char *str)
 {
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
vmscan-add-block-plug-for-page-reclaim.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

