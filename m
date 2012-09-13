From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-drivers-platform-x86.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:37 -0700
Message-ID: <20120913233738.A82FA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44480 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab2IMXhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:41 -0400
Received: by fass10 with SMTP id s10so219312fas.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, mjg@redhat.com


The patch titled
     Subject: sections: fix section conflicts in drivers/platform/x86
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-drivers-platform-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

