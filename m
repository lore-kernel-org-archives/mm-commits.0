From: akpm@linux-foundation.org
Subject: + include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch added to -mm tree
Date: Fri, 19 Nov 2010 14:08:06 -0800
Message-ID: <201011192208.oAJM86qP005566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932540Ab0KSWdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Nov 2010 17:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, eike-kernel@sf-tec.de, geert@linux-m68k.org, michalj@gmail.com


The patch titled
     include/linux/kernel.h: abs(): fix handling of 32-bit unsigneds on 64-bit
has been added to the -mm tree.  Its filename is
     include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/kernel.h: abs(): fix handling of 32-bit unsigneds on 64-bit
From: Andrew Morton <akpm@linux-foundation.org>

Michal reports:

In the framebuffer subsystem the abs() macro is often used as a part of
the calculation of a Manhattan metric, which in turn is used as a measure
of similarity between video modes.  The arguments of abs() are sometimes
unsigned numbers.  This worked fine until commit a49c59c0 ("Make sure the
value in abs() does not get truncated if it is greater than 2^32:) , which
changed the definition of abs() to prevent truncation.  As a result of
this change, in the following piece of code:

u32 a = 0, b = 1;
u32 c = abs(a - b);

'c' will end up with a value of 0xffffffff instead of the expected 0x1.

A problem caused by this change and visible by the end user is that
framebuffer drivers relying on functions from modedb.c will fail to find
high resolution video modes similar to that explicitly requested by the
user if an exact match cannot be found (see e.g.

Fix this by special-casing `long' types within abs().  

This patch reduces x86_64 code size a bit - drivers/video/uvesafb.o shrunk
by 15 bytes, presumably because it is doing abs() on 4-byte quantities,
and expanding those to 8-byte longs adds code.

testcase:

#define oldabs(x) ({				\
		long __x = (x);			\
		(__x < 0) ? -__x : __x;		\
	})

#define newabs(x) ({						\
		long ret;					\
		if (sizeof(x) == sizeof(long)) {		\
			long __x = (x);				\
			ret = (__x < 0) ? -__x : __x;		\
		} else {					\
			int __x = (x);				\
			ret = (__x < 0) ? -__x : __x;		\
		}						\
		ret;						\
	})

typedef unsigned int u32;

main()
{
	u32 a = 0;
	u32 b = 1;
	u32 oldc = oldabs(a - b);
	u32 newc = newabs(a - b);

	printf("%u %u\n", oldc, newc);
}

akpm:/home/akpm> gcc t.c
akpm:/home/akpm> ./a.out
4294967295 1

Reported-by: Michal Januszewski <michalj@gmail.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit
+++ a/include/linux/kernel.h
@@ -143,9 +143,16 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-#define abs(x) ({				\
-		long __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
+#define abs(x) ({						\
+		long ret;					\
+		if (sizeof(x) == sizeof(long)) {		\
+			long __x = (x);				\
+			ret = (__x < 0) ? -__x : __x;		\
+		} else {					\
+			int __x = (x);				\
+			ret = (__x < 0) ? -__x : __x;		\
+		}						\
+		ret;						\
 	})
 
 #define abs64(x) ({				\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hpet-factor-timer-allocate-from-open.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup.patch
mm-vmap-area-cache.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

