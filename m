From: akpm@linux-foundation.org
Subject: - powerpc-ps3-use-__maybe_unused.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:18 -0700
Message-ID: <200706292041.l5TKfICj022566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035AbXF2Uuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, geoffrey.levand@am.sony.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: ps3: use __maybe_unused
has been removed from the -mm tree.  Its filename was
     powerpc-ps3-use-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: ps3: use __maybe_unused
From: David Rientjes <rientjes@google.com>

Replace function instances of __attribute__ ((unused)) with
__maybe_unused.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
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
@@ -533,7 +533,7 @@ static void _dump_64_bmp(const char *hea
 		*p & 0xffff);
 }
 
-static void __attribute__ ((unused)) _dump_256_bmp(const char *header,
+static void __maybe_unused _dump_256_bmp(const char *header,
 	const u64 *p, unsigned cpu, const char* func, int line)
 {
 	pr_debug("%s:%d: %s %u {%016lx:%016lx:%016lx:%016lx}\n",
@@ -552,7 +552,7 @@ static void _dump_bmp(struct ps3_private
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

git-scsi-misc.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
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
