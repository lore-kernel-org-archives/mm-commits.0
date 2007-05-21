From: akpm@linux-foundation.org
Subject: + bug-in-i386-mtrr-initialization.patch added to -mm tree
Date: Sun, 20 May 2007 20:46:01 -0700
Message-ID: <200705210346.l4L3k0a0001764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754357AbXEUDs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righiandr@users.sourceforge.net, a.righi@cineca.it


The patch titled
     bug in i386 MTRR initialization
has been added to the -mm tree.  Its filename is
     bug-in-i386-mtrr-initialization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bug in i386 MTRR initialization
From: Andrea Righi <righiandr@users.sourceforge.net>

BUG: at include/linux/slub_def.h:77 kmalloc_index()
 [<c0168eb0>] get_slab+0x1d0/0x260
 [<c0169056>] __kmalloc+0x16/0x70
 [<c042b0ff>] sysenter_setup+0x6f/0x330
 [<c010baed>] mtrr_bp_init+0xcd/0x270
 [<c041a480>] unknown_bootoption+0x0/0x250
 [<c041a480>] unknown_bootoption+0x0/0x250
 [<c0423f78>] check_bugs+0x8/0x160
 [<c01a644c>] proc_sys_init+0xc/0x30
 [<c041a8ef>] start_kernel+0x21f/0x2b0
 [<c041a480>] unknown_bootoption+0x0/0x250
 =======================

Reproduced running 2.6.22-rc2 (using SLUB) in a virtual machine with qemu
0.9.0 + kqemu 1.3.0pre11.  It occurs only using "-kernel-kqemu" option (full
virtualization mode).

In this case mtrr is supported by the real cpu, but no mtrr range is found,
resulting in a kmalloc(0, GFP_KERNEL) in get_mtrr_state() and init_table().

Signed-off-by: Andrea Righi <a.righi@cineca.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    3 +++
 arch/i386/kernel/cpu/mtrr/main.c    |    5 +++++
 2 files changed, 8 insertions(+)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~bug-in-i386-mtrr-initialization arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~bug-in-i386-mtrr-initialization
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -84,6 +84,9 @@ void __init get_mtrr_state(void)
 	struct mtrr_var_range *vrs;
 	unsigned lo, dummy;
 
+	if (!num_var_ranges)
+		return;
+
 	if (!mtrr_state.var_ranges) {
 		mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct mtrr_var_range), 
 						GFP_KERNEL);
diff -puN arch/i386/kernel/cpu/mtrr/main.c~bug-in-i386-mtrr-initialization arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~bug-in-i386-mtrr-initialization
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -120,6 +120,11 @@ static void __init init_table(void)
 {
 	int i, max;
 
+        if (!num_var_ranges) {
+		printk(KERN_ERR "mtrr: no MTRR range found.\n");
+		return;
+        }
+
 	max = num_var_ranges;
 	if ((usage_table = kmalloc(max * sizeof *usage_table, GFP_KERNEL))
 	    == NULL) {
_

Patches currently in -mm which might be from righiandr@users.sourceforge.net are

bug-in-i386-mtrr-initialization.patch
vdso-print-fatal-signals-fix.patch
