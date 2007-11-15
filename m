From: akpm@linux-foundation.org
Subject: - cris-array_size-cleanup.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:58 -0800
Message-ID: <200711152111.lAFLBwnu015814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932213AbXKOVRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@flawedcode.org, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: ARRAY_SIZE() cleanup
has been removed from the -mm tree.  Its filename was
     cris-array_size-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris: ARRAY_SIZE() cleanup
From: Alex Unleashed <alex@flawedcode.org>

I'm converting most array size calculations under arch/ to use
ARRAY_SIZE().  This is the patch for CRIS.

Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/io_interface_mux.c |    2 +-
 arch/cris/arch-v10/kernel/setup.c            |    4 ++--
 arch/cris/arch-v32/drivers/sync_serial.c     |    2 +-
 arch/cris/arch-v32/kernel/io.c               |    2 +-
 arch/cris/arch-v32/kernel/setup.c            |    6 ++----
 5 files changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/cris/arch-v10/kernel/io_interface_mux.c~cris-array_size-cleanup arch/cris/arch-v10/kernel/io_interface_mux.c
--- a/arch/cris/arch-v10/kernel/io_interface_mux.c~cris-array_size-cleanup
+++ a/arch/cris/arch-v10/kernel/io_interface_mux.c
@@ -304,7 +304,7 @@ static unsigned char clear_group_from_se
 static struct if_group *get_group(const unsigned char groups)
 {
 	int i;
-	for (i = 0; i < sizeof(if_groups)/sizeof(struct if_group); i++) {
+	for (i = 0; i < ARRAY_SIZE(if_groups); i++) {
 		if (groups & if_groups[i].group) {
 			return &if_groups[i];
 		}
diff -puN arch/cris/arch-v10/kernel/setup.c~cris-array_size-cleanup arch/cris/arch-v10/kernel/setup.c
--- a/arch/cris/arch-v10/kernel/setup.c~cris-array_size-cleanup
+++ a/arch/cris/arch-v10/kernel/setup.c
@@ -57,8 +57,8 @@ int show_cpuinfo(struct seq_file *m, voi
 
 	revision = rdvr();
 
-	if (revision >= sizeof cpu_info/sizeof *cpu_info)
-		info = &cpu_info[sizeof cpu_info/sizeof *cpu_info - 1];
+	if (revision >= ARRAY_SIZE(cpu_info))
+		info = &cpu_info[ARRAY_SIZE(cpu_info) - 1];
 	else
 		info = &cpu_info[revision];
 
diff -puN arch/cris/arch-v32/drivers/sync_serial.c~cris-array_size-cleanup arch/cris/arch-v32/drivers/sync_serial.c
--- a/arch/cris/arch-v32/drivers/sync_serial.c~cris-array_size-cleanup
+++ a/arch/cris/arch-v32/drivers/sync_serial.c
@@ -185,7 +185,7 @@ static struct sync_port ports[]=
 	}
 };
 
-#define NUMBER_OF_PORTS (sizeof(ports)/sizeof(sync_port))
+#define NUMBER_OF_PORTS ARRAY_SIZE(ports)
 
 static const struct file_operations sync_serial_fops = {
 	.owner   = THIS_MODULE,
diff -puN arch/cris/arch-v32/kernel/io.c~cris-array_size-cleanup arch/cris/arch-v32/kernel/io.c
--- a/arch/cris/arch-v32/kernel/io.c~cris-array_size-cleanup
+++ a/arch/cris/arch-v32/kernel/io.c
@@ -49,7 +49,7 @@ struct crisv32_ioport crisv32_ioports[] 
 	}
 };
 
-#define NBR_OF_PORTS sizeof(crisv32_ioports)/sizeof(struct crisv32_ioport)
+#define NBR_OF_PORTS ARRAY_SIZE(crisv32_ioports)
 
 struct crisv32_iopin crisv32_led1_green;
 struct crisv32_iopin crisv32_led1_red;
diff -puN arch/cris/arch-v32/kernel/setup.c~cris-array_size-cleanup arch/cris/arch-v32/kernel/setup.c
--- a/arch/cris/arch-v32/kernel/setup.c~cris-array_size-cleanup
+++ a/arch/cris/arch-v32/kernel/setup.c
@@ -54,12 +54,10 @@ show_cpuinfo(struct seq_file *m, void *v
 {
 	int i;
 	int cpu = (int)v - 1;
-	int entries;
 	unsigned long revision;
 	struct cpu_info *info;
 
-	entries = sizeof cpinfo / sizeof(struct cpu_info);
-	info = &cpinfo[entries - 1];
+	info = &cpinfo[ARRAY_SIZE(cpinfo) - 1];
 
 #ifdef CONFIG_SMP
 	if (!cpu_online(cpu))
@@ -68,7 +66,7 @@ show_cpuinfo(struct seq_file *m, void *v
 
 	revision = rdvr();
 
-	for (i = 0; i < entries; i++) {
+	for (i = 0; i < ARRAY_SIZE(cpinfo); i++) {
 		if (cpinfo[i].rev == revision) {
 			info = &cpinfo[i];
 			break;
_

Patches currently in -mm which might be from alex@flawedcode.org are

origin.patch
git-arm.patch
git-mips.patch
git-netdev-all.patch
