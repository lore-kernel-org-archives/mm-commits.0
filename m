From: akpm@linux-foundation.org
Subject: + mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch added
 to -mm tree
Date: Mon, 01 Aug 2016 13:16:10 -0700
Message-ID: <579fae0a.IMF4hteFEcXqitj4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbcHAUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, davej@codemonkey.org.uk, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: don't reduce quarantine in atomic contexts
has been added to the -mm tree.  Its filename is
     mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: don't reduce quarantine in atomic contexts

Currently we call quarantine_reduce() for ___GFP_KSWAPD_RECLAIM (implied
by __GFP_RECLAIM) allocation.  So, basically we call it on almost every
allocation.  quarantine_reduce() sometimes is heavy operation, and calling
it with disabled interrupts may trigger hard LOCKUP:

 NMI watchdog: Watchdog detected hard LOCKUP on cpu 2irq event stamp: 1411258
 Call Trace:
  <NMI>  [<ffffffff98a48532>] dump_stack+0x68/0x96
  [<ffffffff98357fbb>] watchdog_overflow_callback+0x15b/0x190
  [<ffffffff9842f7d1>] __perf_event_overflow+0x1b1/0x540
  [<ffffffff98455b14>] perf_event_overflow+0x14/0x20
  [<ffffffff9801976a>] intel_pmu_handle_irq+0x36a/0xad0
  [<ffffffff9800ba4c>] perf_event_nmi_handler+0x2c/0x50
  [<ffffffff98057058>] nmi_handle+0x128/0x480
  [<ffffffff980576d2>] default_do_nmi+0xb2/0x210
  [<ffffffff980579da>] do_nmi+0x1aa/0x220
  [<ffffffff99a0bb07>] end_repeat_nmi+0x1a/0x1e
  <<EOE>>  [<ffffffff981871e6>] __kernel_text_address+0x86/0xb0
  [<ffffffff98055c4b>] print_context_stack+0x7b/0x100
  [<ffffffff98054e9b>] dump_trace+0x12b/0x350
  [<ffffffff98076ceb>] save_stack_trace+0x2b/0x50
  [<ffffffff98573003>] set_track+0x83/0x140
  [<ffffffff98575f4a>] free_debug_processing+0x1aa/0x420
  [<ffffffff98578506>] __slab_free+0x1d6/0x2e0
  [<ffffffff9857a9b6>] ___cache_free+0xb6/0xd0
  [<ffffffff9857db53>] qlist_free_all+0x83/0x100
  [<ffffffff9857df07>] quarantine_reduce+0x177/0x1b0
  [<ffffffff9857c423>] kasan_kmalloc+0xf3/0x100

Reduce the quarantine_reduce iff direct reclaim is allowed.

Fixes: 55834c59098d("mm: kasan: initial memory quarantine implementation")
Link: http://lkml.kernel.org/r/1470062715-14077-2-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.c~mm-kasan-dont-reduce-quarantine-in-atomic-contexts mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-dont-reduce-quarantine-in-atomic-contexts
+++ a/mm/kasan/kasan.c
@@ -565,7 +565,7 @@ void kasan_kmalloc(struct kmem_cache *ca
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
-	if (flags & __GFP_RECLAIM)
+	if (gfpflags_allow_blocking(flags))
 		quarantine_reduce();
 
 	if (unlikely(object == NULL))
@@ -596,7 +596,7 @@ void kasan_kmalloc_large(const void *ptr
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
-	if (flags & __GFP_RECLAIM)
+	if (gfpflags_allow_blocking(flags))
 		quarantine_reduce();
 
 	if (unlikely(ptr == NULL))
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-fix-corruptions-and-false-positive-reports.patch
mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
kasan-improve-double-free-reports.patch

