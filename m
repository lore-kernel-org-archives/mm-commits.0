From: akpm@linux-foundation.org
Subject: + cris-cpuinfo_op-should-depend-on-config_proc_fs.patch added to
 -mm tree
Date: Tue, 04 Mar 2014 12:14:17 -0800
Message-ID: <53163419.qjV/AsKhapgRpSIS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbaCDUOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, sfr@canb.auug.org.au, jesper.nilsson@axis.com, geert@linux-m68k.org

Subject: + cris-cpuinfo_op-should-depend-on-config_proc_fs.patch added to -mm tree
To: geert@linux-m68k.org,jesper.nilsson@axis.com,sfr@canb.auug.org.au,starvik@axis.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:14:17 -0800


The patch titled
     Subject: cris: cpuinfo_op should depend on CONFIG_PROC_FS
has been added to the -mm tree.  Its filename is
     cris-cpuinfo_op-should-depend-on-config_proc_fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cris-cpuinfo_op-should-depend-on-config_proc_fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cris-cpuinfo_op-should-depend-on-config_proc_fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
sh-prefix-sh-specific-ccr-and-ccr2-by-sh_.patch
arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch
cris-cpuinfo_op-should-depend-on-config_proc_fs.patch
linux-next.patch

