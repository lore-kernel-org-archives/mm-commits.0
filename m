From: akpm@linux-foundation.org
Subject: - lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch removed from -mm tree
Date: Mon, 26 Mar 2007 22:02:57 -0800
Message-ID: <200703270602.l2R62vv7008900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41062 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965187AbXC0GDF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 02:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     lguest: documentation fixes
has been removed from the -mm tree.  Its filename was
     lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch

This patch was dropped because it was folded into lguest-documentatation-and-example-launcher.patch

------------------------------------------------------
Subject: lguest: documentation fixes
From: Rusty Russell <rusty@rustcorp.com.au>

1: It helps if you connect the bridge to a link.

Signed-off-by: James Morris <jmorris@namei.org>

2: You can theoretically run lguest with no boot parameters.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c   |    2 +-
 Documentation/lguest/lguest.txt |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/lguest/lguest.c~lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes
+++ a/Documentation/lguest/lguest.c
@@ -918,7 +918,7 @@ int main(int argc, char *argv[])
 		argc--;
 	}
 
-	if (argc < 4)
+	if (argc < 3)
 		errx(1, "Usage: lguest [--verbose] <mem> vmlinux "
 			"[--sharenet=<filename>|--tunnet=(<ipaddr>|bridge:<bridgename>)"
 			"|--block=<filename>|--initrd=<filename>]... [args...]");
diff -puN Documentation/lguest/lguest.txt~lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes Documentation/lguest/lguest.txt
--- a/Documentation/lguest/lguest.txt~lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes
+++ a/Documentation/lguest/lguest.txt
@@ -87,6 +87,7 @@ Running Lguest:
     ifconfig eth0 0.0.0.0
     brctl addbr lg0
     ifconfig lg0 up
+    brctl addif lg0 eth0
     dhclient lg0
 
   Then use --tunnet=bridge:lg0 when launching the guest.
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-clean-up-some-references-inittext-warnings.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
cleanup-rationalize-paravirt-wrappers.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
