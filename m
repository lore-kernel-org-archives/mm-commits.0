From: akpm@linux-foundation.org
Subject: + lguest-documentation-and-example-updates.patch added to -mm tree
Date: Fri, 04 May 2007 14:00:19 -0700
Message-ID: <200705042100.l44L0Jqv014034@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031393AbXEDVAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 17:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, tony@bakeyournoodle.com


The patch titled
     lguest: documentation and example updates
has been added to the -mm tree.  Its filename is
     lguest-documentation-and-example-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: documentation and example updates
From: Rusty Russell <rusty@rustcorp.com.au>

1) Example code: old libc headers don't have SIOCBRADDIF, and old zlibs
   don't have gzdirect() -- it's a sanity check anyway.
2) Some people don't build in their source directories, so .config
   isn't there (thanks to Tony Breeds <tony@bakeyournoodle.com>).
3) Point out that guest and host kernel are usually the same.
4) Set the "no checksum" option on the tun device as a minor optimization.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/Makefile   |    9 ++++++++-
 Documentation/lguest/lguest.c   |    6 ++++--
 Documentation/lguest/lguest.txt |    8 ++++++--
 3 files changed, 18 insertions(+), 5 deletions(-)

diff -puN Documentation/lguest/Makefile~lguest-documentation-and-example-updates Documentation/lguest/Makefile
--- a/Documentation/lguest/Makefile~lguest-documentation-and-example-updates
+++ a/Documentation/lguest/Makefile
@@ -1,7 +1,14 @@
 # This creates the demonstration utility "lguest" which runs a Linux guest.
 
+# For those people that have a separate object dir, look there for .config
+KBUILD_OUTPUT := ../..
+ifdef O
+  ifeq ("$(origin O)", "command line")
+    KBUILD_OUTPUT := $(O)
+  endif
+endif
 # We rely on CONFIG_PAGE_OFFSET to know where to put lguest binary.
-include ../../.config
+include $(KBUILD_OUTPUT)/.config
 LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
 
 CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 \
diff -puN Documentation/lguest/lguest.c~lguest-documentation-and-example-updates Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-documentation-and-example-updates
+++ a/Documentation/lguest/lguest.c
@@ -38,6 +38,9 @@ typedef uint8_t u8;
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
 #define NET_PEERNUM 1
 #define BRIDGE_PFX "bridge:"
+#ifndef SIOCBRADDIF
+#define SIOCBRADDIF	0x89a2		/* add interface to bridge      */
+#endif
 
 static bool verbose;
 #define verbose(args...) \
@@ -164,8 +167,6 @@ static unsigned long unpack_bzimage(int 
 	void *img = (void *)0x100000;
 
 	f = gzdopen(fd, "rb");
-	if (gzdirect(f))
-		errx(1, "did not find correct gzip header");
 	while ((ret = gzread(f, img + len, 65536)) > 0)
 		len += ret;
 	if (ret < 0)
@@ -816,6 +817,7 @@ static void setup_tun_net(const char *ar
 	strcpy(ifr.ifr_name, "tap%d");
 	if (ioctl(netfd, TUNSETIFF, &ifr) != 0)
 		err(1, "configuring /dev/net/tun");
+	ioctl(netfd, TUNSETNOCSUM, 1);
 
 	/* You will be peer 1: we should create enough jitter to randomize */
 	dev = new_device(devices, LGUEST_DEVICE_T_NET, 1,
diff -puN Documentation/lguest/lguest.txt~lguest-documentation-and-example-updates Documentation/lguest/lguest.txt
--- a/Documentation/lguest/lguest.txt~lguest-documentation-and-example-updates
+++ a/Documentation/lguest/lguest.txt
@@ -23,7 +23,10 @@ Developer features:
 
 Running Lguest:
 
-- You will need to configure your kernel with the following options:
+- Lguest runs the same kernel as guest and host.  You can configure
+  them differently, but usually it's easiest not to.
+
+  You will need to configure your kernel with the following options:
 
   CONFIG_HIGHMEM64G=n ("High Memory Support" "64GB")[1]
   CONFIG_TUN=y/m ("Universal TUN/TAP device driver support")
@@ -35,7 +38,8 @@ Running Lguest:
   CONFIG_HZ=100 ("Timer frequency")[2]
 
 - A tool called "lguest" is available in this directory: type "make"
-  to build it.
+  to build it.  If you didn't build your kernel in-tree, use "make
+  O=<builddir>".
 
 - Create or find a root disk image.  There are several useful ones
   around, such as the xm-test tiny root image at
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
array_size-check-for-type.patch
git-kbuild.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
module-use-krealloc.patch
get_futex_key-get_key_refs-and-drop_key_refs.patch
futex-restartable-futex_wait.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
