From: akpm@linux-foundation.org
Subject: + lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:13:07 -0800
Message-ID: <200703110913.l2B9D7K8008471@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40806 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbXCKJNQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, jmorris@namei.org


The patch titled
     lguest: documentation fixes
has been added to the -mm tree.  Its filename is
     lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

futex-restartable-futex_wait.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
lguest-pin-stack-page-optimization.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-dont-crash-host-on-nmi.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
____call_usermodehelper-dont-flush_signals.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
