From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch added to -mm tree
Date: Wed, 15 Oct 2008 17:51:09 -0700
Message-ID: <200810160105.m9G15h8R032723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYJPBF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 21:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu


The patch titled
     arch/x86/kernel/setup.c: omit dmi_low_memory_corruption() when it is unneeded
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/setup.c: omit dmi_low_memory_corruption() when it is unneeded
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allnoconfig:

arch/x86/kernel/setup.c:736: warning: 'dmi_low_memory_corruption' defined but not used

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/setup.c~arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded
+++ a/arch/x86/kernel/setup.c
@@ -732,6 +732,7 @@ void start_periodic_check_for_corruption
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -746,7 +747,6 @@ static int __init dmi_low_memory_corrupt
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
-#ifdef CONFIG_X86_RESERVE_LOW_64K
 	{
 		.callback = dmi_low_memory_corruption,
 		.ident = "AMI BIOS",
@@ -761,10 +761,19 @@ static struct dmi_system_id __initdata b
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
 		},
 	},
-#endif
 	{}
 };
 
+static inline void handle_bad_bios_dmi_table(void)
+{
+	dmi_check_system(bad_bios_dmi_table);
+}
+#else
+static inline void handle_bad_bios_dmi_table(void)
+{
+}
+#endif
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -901,7 +910,7 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
-	dmi_check_system(bad_bios_dmi_table);
+	handle_bad_bios_dmi_table();
 
 #ifdef CONFIG_X86_32
 	probe_roms();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-new-driver-ds2431-chip.patch
gru-driver-minor-updates.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch

