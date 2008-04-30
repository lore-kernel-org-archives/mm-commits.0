From: akpm@linux-foundation.org
Subject: - edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:51 -0700
Message-ID: <200804300547.m3U5lpsw029739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758657AbYD3Fst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@canonical.com, Matt_Domsch@dell.com, hpa@zytor.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     edd: add default mode CONFIG_EDD_OFF=n, override with edd={on,off}
has been removed from the -mm tree.  Its filename was
     edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edd: add default mode CONFIG_EDD_OFF=n, override with edd={on,off}
From: Tim Gardner <tim.gardner@canonical.com>

Add a kernel parameter option to 'edd' to enable/disable BIOS Enhanced Disk
Drive Services.  CONFIG_EDD_OFF disables EDD while still compiling EDD into
the kernel.  Default behavior can be forced using 'edd=on' or 'edd=off' as
a kernel parameter.

[akpm@linux-foundation.org: fix kernel-parameters.txt]
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +--
 arch/x86/boot/edd.c                 |   10 +++++++++-
 drivers/firmware/Kconfig            |    9 +++++++++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff
+++ a/Documentation/kernel-parameters.txt
@@ -627,8 +627,7 @@ and is between 256 and 4096 characters. 
 	eata=		[HW,SCSI]
 
 	edd=		[EDD]
-			Format: {"of[f]" | "sk[ipmbr]"}
-			See comment in arch/i386/boot/edd.S
+			Format: {"off" | "on" | "skip[mbr]"}
 
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
diff -puN arch/x86/boot/edd.c~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff arch/x86/boot/edd.c
--- a/arch/x86/boot/edd.c~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff
+++ a/arch/x86/boot/edd.c
@@ -126,17 +126,25 @@ void query_edd(void)
 {
 	char eddarg[8];
 	int do_mbr = 1;
+#ifdef CONFIG_EDD_OFF
+	int do_edd = 0;
+#else
 	int do_edd = 1;
+#endif
 	int be_quiet;
 	int devno;
 	struct edd_info ei, *edp;
 	u32 *mbrptr;
 
 	if (cmdline_find_option("edd", eddarg, sizeof eddarg) > 0) {
-		if (!strcmp(eddarg, "skipmbr") || !strcmp(eddarg, "skip"))
+		if (!strcmp(eddarg, "skipmbr") || !strcmp(eddarg, "skip")) {
+			do_edd = 1;
 			do_mbr = 0;
+		}
 		else if (!strcmp(eddarg, "off"))
 			do_edd = 0;
+		else if (!strcmp(eddarg, "on"))
+			do_edd = 1;
 	}
 
 	be_quiet = cmdline_find_option_bool("quiet");
diff -puN drivers/firmware/Kconfig~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff drivers/firmware/Kconfig
--- a/drivers/firmware/Kconfig~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff
+++ a/drivers/firmware/Kconfig
@@ -17,6 +17,15 @@ config EDD
           obscure configurations. Most disk controller BIOS vendors do
           not yet implement this feature.
 
+config EDD_OFF
+	bool "Sets default behavior for EDD detection to off"
+	depends on EDD
+	default n
+	help
+	  Say Y if you want EDD disabled by default, even though it is compiled into the
+	  kernel. Say N if you want EDD enabled by default. EDD can be dynamically set
+	  using the kernel parameter 'edd={on|skipmbr|off}'.
+
 config EFI_VARS
 	tristate "EFI Variable Support via sysfs"
 	depends on EFI
_

Patches currently in -mm which might be from tim.gardner@canonical.com are

origin.patch

