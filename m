From: akpm@linux-foundation.org
Subject: [obsolete] arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch removed from -mm tree
Date: Wed, 25 May 2011 16:13:44 -0700
Message-ID: <201105252350.p4PNoTcE025432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756377Ab1EYXvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 19:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben@decadent.org.uk, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     arch/alpha/include/asm/io.h: s/extern inline/static inline/
has been removed from the -mm tree.  Its filename was
     arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/alpha/include/asm/io.h: s/extern inline/static inline/
From: Andrew Morton <akpm@linux-foundation.org>

When building the kernel for alpha using gcc 4.4, many files will provoke these
warnings:

arch/alpha/include/asm/io.h: In function '__set_hae':
arch/alpha/include/asm/io.h:41: warning: 'arch_local_irq_save' is static but
used in inline function '__set_hae' which is not static
arch/alpha/include/asm/io.h:49: warning: 'arch_local_irq_restore' is static but
used in inline function '__set_hae' which is not static

and because the alpha makefiles include -Werror in CFLAGS, this is fatal.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=25432

(akpm: there are lots more extern inlines in there, but people have been
playing games mixing them up with extern non-inlines so it needs more work).

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/io.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/io.h~arch-alpha-include-asm-ioh-s-extern-inline-static-inline arch/alpha/include/asm/io.h
--- a/arch/alpha/include/asm/io.h~arch-alpha-include-asm-ioh-s-extern-inline-static-inline
+++ a/arch/alpha/include/asm/io.h
@@ -35,7 +35,7 @@
  * register not being up-to-date with respect to the hardware
  * value.
  */
-extern inline void __set_hae(unsigned long new_hae)
+static inline void __set_hae(unsigned long new_hae)
 {
 	unsigned long flags = swpipl(IPL_MAX);
 
@@ -51,7 +51,7 @@ extern inline void __set_hae(unsigned lo
 	barrier();
 }
 
-extern inline void set_hae(unsigned long new_hae)
+static inline void set_hae(unsigned long new_hae)
 {
 	if (new_hae != alpha_mv.hae_cache)
 		__set_hae(new_hae);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xx-i2cc-needs-delayh.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

