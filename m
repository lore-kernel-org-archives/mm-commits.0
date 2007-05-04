From: akpm@linux-foundation.org
Subject: + powerpc-ps3-use-__maybe_unused.patch added to -mm tree
Date: Fri, 04 May 2007 15:00:52 -0700
Message-ID: <200705042200.l44M0q83019569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161558AbXEDWBE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 18:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, geoffrey.levand@am.sony.com, paulus@samba.org


The patch titled
     powerpc: ps3: use __maybe_unused
has been added to the -mm tree.  Its filename is
     powerpc-ps3-use-__maybe_unused.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: ps3: use __maybe_unused
From: David Rientjes <rientjes@google.com>

Replace function instances of __attribute__ ((unused)) with
__maybe_unused.

Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/ps3/interrupt.c |    4 ++--
 arch/powerpc/platforms/ps3/time.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/ps3/interrupt.c~powerpc-ps3-use-__maybe_unused arch/powerpc/platforms/ps3/interrupt.c
--- a/arch/powerpc/platforms/ps3/interrupt.c~powerpc-ps3-use-__maybe_unused
+++ a/arch/powerpc/platforms/ps3/interrupt.c
@@ -532,7 +532,7 @@ static void _dump_64_bmp(const char *hea
 		*p & 0xffff);
 }
 
-static void __attribute__ ((unused)) _dump_256_bmp(const char *header,
+static void __maybe_unused _dump_256_bmp(const char *header,
 	const u64 *p, unsigned cpu, const char* func, int line)
 {
 	pr_debug("%s:%d: %s %u {%016lx:%016lx:%016lx:%016lx}\n",
@@ -551,7 +551,7 @@ static void _dump_bmp(struct ps3_private
 }
 
 #define dump_mask(_x) _dump_mask(_x, __func__, __LINE__)
-static void __attribute__ ((unused)) _dump_mask(struct ps3_private* pd,
+static void __maybe_unused _dump_mask(struct ps3_private* pd,
 	const char* func, int line)
 {
 	unsigned long flags;
diff -puN arch/powerpc/platforms/ps3/time.c~powerpc-ps3-use-__maybe_unused arch/powerpc/platforms/ps3/time.c
--- a/arch/powerpc/platforms/ps3/time.c~powerpc-ps3-use-__maybe_unused
+++ a/arch/powerpc/platforms/ps3/time.c
@@ -39,7 +39,7 @@ static void _dump_tm(const struct rtc_ti
 }
 
 #define dump_time(_a) _dump_time(_a, __func__, __LINE__)
-static void __attribute__ ((unused)) _dump_time(int time, const char* func,
+static void __maybe_unused _dump_time(int time, const char* func,
 	int line)
 {
 	struct rtc_time tm;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
wavefront-only-declare-isapnp-on-config_pnp.patch
git-cpufreq.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
