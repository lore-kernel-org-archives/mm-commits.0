From: akpm@linux-foundation.org
Subject: + tile-use-pr_warn-instead-of-pr_warning.patch added to -mm tree
Date: Thu, 30 Oct 2014 14:55:33 -0700
Message-ID: <5452b3d5.S2Bw4/IqG23fItCK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161324AbaJ3Vzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 17:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: use pr_warn instead of pr_warning
has been added to the -mm tree.  Its filename is
     tile-use-pr_warn-instead-of-pr_warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-use-pr_warn-instead-of-pr_warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-use-pr_warn-instead-of-pr_warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: tile: use pr_warn instead of pr_warning

Use the more common pr_warn.

Coalesce formats, realign arguments.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/setup.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff -puN arch/tile/kernel/setup.c~tile-use-pr_warn-instead-of-pr_warning arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~tile-use-pr_warn-instead-of-pr_warning
+++ a/arch/tile/kernel/setup.c
@@ -534,11 +534,10 @@ static void __init setup_memory(void)
 			}
 		}
 		physpages -= dropped_pages;
-		pr_warning("Only using %ldMB memory;"
-		       " ignoring %ldMB.\n",
-		       physpages >> (20 - PAGE_SHIFT),
-		       dropped_pages >> (20 - PAGE_SHIFT));
-		pr_warning("Consider using a larger page size.\n");
+		pr_warn("Only using %ldMB memory - ignoring %ldMB\n",
+			physpages >> (20 - PAGE_SHIFT),
+			dropped_pages >> (20 - PAGE_SHIFT));
+		pr_warn("Consider using a larger page size\n");
 	}
 #endif
 
@@ -566,9 +565,8 @@ static void __init setup_memory(void)
 
 #ifndef __tilegx__
 	if (node_end_pfn[0] > MAXMEM_PFN) {
-		pr_warning("Only using %ldMB LOWMEM.\n",
-		       MAXMEM>>20);
-		pr_warning("Use a HIGHMEM enabled kernel.\n");
+		pr_warn("Only using %ldMB LOWMEM\n", MAXMEM >> 20);
+		pr_warn("Use a HIGHMEM enabled kernel\n");
 		max_low_pfn = MAXMEM_PFN;
 		max_pfn = MAXMEM_PFN;
 		node_end_pfn[0] = MAXMEM_PFN;
@@ -1112,8 +1110,8 @@ static void __init load_hv_initrd(void)
 	fd = hv_fs_findfile((HV_VirtAddr) initramfs_file);
 	if (fd == HV_ENOENT) {
 		if (set_initramfs_file) {
-			pr_warning("No such hvfs initramfs file '%s'\n",
-				   initramfs_file);
+			pr_warn("No such hvfs initramfs file '%s'\n",
+				initramfs_file);
 			return;
 		} else {
 			/* Try old backwards-compatible name. */
@@ -1126,8 +1124,8 @@ static void __init load_hv_initrd(void)
 	stat = hv_fs_fstat(fd);
 	BUG_ON(stat.size < 0);
 	if (stat.flags & HV_FS_ISDIR) {
-		pr_warning("Ignoring hvfs file '%s': it's a directory.\n",
-			   initramfs_file);
+		pr_warn("Ignoring hvfs file '%s': it's a directory\n",
+			initramfs_file);
 		return;
 	}
 	initrd = alloc_bootmem_pages(stat.size);
@@ -1185,9 +1183,8 @@ static void __init validate_hv(void)
 	HV_Topology topology = hv_inquire_topology();
 	BUG_ON(topology.coord.x != 0 || topology.coord.y != 0);
 	if (topology.width != 1 || topology.height != 1) {
-		pr_warning("Warning: booting UP kernel on %dx%d grid;"
-			   " will ignore all but first tile.\n",
-			   topology.width, topology.height);
+		pr_warn("Warning: booting UP kernel on %dx%d grid; will ignore all but first tile\n",
+			topology.width, topology.height);
 	}
 #endif
 
@@ -1393,7 +1390,7 @@ static void __init setup_cpu_maps(void)
 
 static int __init dataplane(char *str)
 {
-	pr_warning("WARNING: dataplane support disabled in this kernel\n");
+	pr_warn("WARNING: dataplane support disabled in this kernel\n");
 	return 0;
 }
 
@@ -1411,8 +1408,8 @@ void __init setup_arch(char **cmdline_p)
 	len = hv_get_command_line((HV_VirtAddr) boot_command_line,
 				  COMMAND_LINE_SIZE);
 	if (boot_command_line[0])
-		pr_warning("WARNING: ignoring dynamic command line \"%s\"\n",
-			   boot_command_line);
+		pr_warn("WARNING: ignoring dynamic command line \"%s\"\n",
+			boot_command_line);
 	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
 #else
 	char *hv_cmdline;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
printk-remove-used-once-early_vprintk.patch
tile-neaten-early_printk-uses.patch
tile-use-pr_warn-instead-of-pr_warning.patch
maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
checkpatch-try-to-avoid-mask-and-shift-errors.patch
checkpatch-reduce-maintainers-update-message-frequency.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

