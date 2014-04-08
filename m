From: akpm@linux-foundation.org
Subject: [merged] cris-cpuinfo_op-should-depend-on-config_proc_fs.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:32:17 -0700
Message-ID: <53446ae1.4GHgf4kO2p/KElDB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbaDHVcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:32:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, sfr@canb.auug.org.au, jesper.nilsson@axis.com, geert@linux-m68k.org

Subject: [merged] cris-cpuinfo_op-should-depend-on-config_proc_fs.patch removed from -mm tree
To: geert@linux-m68k.org,jesper.nilsson@axis.com,sfr@canb.auug.org.au,starvik@axis.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:32:17 -0700


The patch titled
     Subject: cris: cpuinfo_op should depend on CONFIG_PROC_FS
has been removed from the -mm tree.  Its filename was
     cris-cpuinfo_op-should-depend-on-config_proc_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: cris: cpuinfo_op should depend on CONFIG_PROC_FS

Fix breakage which will be exposed by the patch "kconfig: make allnoconfig
disable options behind EMBEDDED and EXPERT".

Now allnoconfig started disabling CONFIG_PROC_FS:

    arch/cris/kernel/built-in.o:(.rodata+0xc): undefined reference to `show_cpuinfo'
    make: *** [vmlinux] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/cris/kernel/setup.c~cris-cpuinfo_op-should-depend-on-config_proc_fs arch/cris/kernel/setup.c
--- a/arch/cris/kernel/setup.c~cris-cpuinfo_op-should-depend-on-config_proc_fs
+++ a/arch/cris/kernel/setup.c
@@ -165,6 +165,7 @@ void __init setup_arch(char **cmdline_p)
 	strcpy(init_utsname()->machine, cris_machine_name);
 }
 
+#ifdef CONFIG_PROC_FS
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	return *pos < nr_cpu_ids ? (void *)(int)(*pos + 1) : NULL;
@@ -188,6 +189,7 @@ const struct seq_operations cpuinfo_op =
 	.stop  = c_stop,
 	.show  = show_cpuinfo,
 };
+#endif /* CONFIG_PROC_FS */
 
 static int __init topology_init(void)
 {
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch

