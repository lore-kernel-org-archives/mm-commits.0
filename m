From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-platform-x86.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:17 -0700
Message-ID: <20121005201317.A10F81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52543 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:18 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so234983ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/platform/x86
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-platform-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/platform/x86

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/amilo-rfkill.c   |    2 +-
 drivers/platform/x86/fujitsu-tablet.c |   10 +++++-----
 drivers/platform/x86/thinkpad_acpi.c  |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/platform/x86/amilo-rfkill.c~sections-fix-section-conflicts-in-drivers-platform-x86 drivers/platform/x86/amilo-rfkill.c
--- a/drivers/platform/x86/amilo-rfkill.c~sections-fix-section-conflicts-in-drivers-platform-x86
+++ a/drivers/platform/x86/amilo-rfkill.c
@@ -74,7 +74,7 @@ static const struct rfkill_ops amilo_m74
 	.set_block = amilo_m7440_rfkill_set_block
 };
 
-static const struct dmi_system_id __devinitdata amilo_rfkill_id_table[] = {
+static const struct dmi_system_id __devinitconst amilo_rfkill_id_table[] = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
diff -puN drivers/platform/x86/fujitsu-tablet.c~sections-fix-section-conflicts-in-drivers-platform-x86 drivers/platform/x86/fujitsu-tablet.c
--- a/drivers/platform/x86/fujitsu-tablet.c~sections-fix-section-conflicts-in-drivers-platform-x86
+++ a/drivers/platform/x86/fujitsu-tablet.c
@@ -52,7 +52,7 @@ struct fujitsu_config {
 	unsigned int quirks;
 };
 
-static unsigned short keymap_Lifebook_Tseries[KEYMAP_LEN] __initconst = {
+static unsigned short keymap_Lifebook_Tseries[KEYMAP_LEN] __initdata = {
 	KEY_RESERVED,
 	KEY_RESERVED,
 	KEY_RESERVED,
@@ -71,7 +71,7 @@ static unsigned short keymap_Lifebook_Ts
 	KEY_LEFTALT
 };
 
-static unsigned short keymap_Lifebook_U810[KEYMAP_LEN] __initconst = {
+static unsigned short keymap_Lifebook_U810[KEYMAP_LEN] __initdata = {
 	KEY_RESERVED,
 	KEY_RESERVED,
 	KEY_RESERVED,
@@ -90,7 +90,7 @@ static unsigned short keymap_Lifebook_U8
 	KEY_LEFTALT
 };
 
-static unsigned short keymap_Stylistic_Tseries[KEYMAP_LEN] __initconst = {
+static unsigned short keymap_Stylistic_Tseries[KEYMAP_LEN] __initdata = {
 	KEY_RESERVED,
 	KEY_RESERVED,
 	KEY_RESERVED,
@@ -109,7 +109,7 @@ static unsigned short keymap_Stylistic_T
 	KEY_LEFTALT
 };
 
-static unsigned short keymap_Stylistic_ST5xxx[KEYMAP_LEN] __initconst = {
+static unsigned short keymap_Stylistic_ST5xxx[KEYMAP_LEN] __initdata = {
 	KEY_RESERVED,
 	KEY_RESERVED,
 	KEY_RESERVED,
@@ -299,7 +299,7 @@ static int __devinit fujitsu_dmi_stylist
 	return 1;
 }
 
-static struct dmi_system_id dmi_ids[] __initconst = {
+static const struct dmi_system_id dmi_ids[] __initconst = {
 	{
 		.callback = fujitsu_dmi_lifebook,
 		.ident = "Fujitsu Siemens P/T Series",
diff -puN drivers/platform/x86/thinkpad_acpi.c~sections-fix-section-conflicts-in-drivers-platform-x86 drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~sections-fix-section-conflicts-in-drivers-platform-x86
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -522,7 +522,7 @@ static acpi_handle ec_handle;
 
 #define TPACPI_HANDLE(object, parent, paths...)			\
 	static acpi_handle  object##_handle;			\
-	static const acpi_handle *object##_parent __initdata =	\
+	static const acpi_handle * const object##_parent __initconst =	\
 						&parent##_handle; \
 	static char *object##_paths[] __initdata = { paths }
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

