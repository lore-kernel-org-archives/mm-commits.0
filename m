From: akpm@linux-foundation.org
Subject: + lguest-two-net-bugfixes-doc.patch added to -mm tree
Date: Tue, 08 May 2007 10:49:44 -0700
Message-ID: <200705081749.l48HniZ4029724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966014AbXEHRtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 13:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: two net bugfixes
has been added to the -mm tree.  Its filename is
     lguest-two-net-bugfixes-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: two net bugfixes
From: Rusty Russell <rusty@rustcorp.com.au>

1) Bridging via host is broken: we need to set "promisc" bit in MAC
   address published by the host so the guest sends us everything.
   Thanks James Morris for the report (I don't use bridging).

2) Lguest network device uses 0 to mean "noone at this slot".  It used to
   use 0xFF, and one spot was missed.  Minor: it just means we'll have a
   useless extra transmit for broadcast packets.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c |    4 ++++
 net/lguest_net.c              |    0 
 2 files changed, 4 insertions(+)

diff -puN Documentation/lguest/lguest.c~lguest-two-net-bugfixes-doc Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-two-net-bugfixes-doc
+++ a/Documentation/lguest/lguest.c
@@ -860,6 +860,10 @@ static void setup_tun_net(const char *ar
 
 	/* We are peer 0, ie. first slot. */
 	configure_device(ipfd, ifr.ifr_name, ip, dev->mem);
+
+	/* Set "promisc" bit: we want every single packet. */
+	*((u8 *)dev->mem) |= 0x1;
+
 	close(ipfd);
 
 	verbose("device %p: tun net %u.%u.%u.%u\n",
diff -puN drivers/net/lguest_net.c~lguest-two-net-bugfixes-doc drivers/net/lguest_net.c
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
module-use-krealloc.patch
get_futex_key-get_key_refs-and-drop_key_refs.patch
futex-restartable-futex_wait.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
