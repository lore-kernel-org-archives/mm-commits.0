From: akpm@linux-foundation.org
Subject: + lguest-fix-non-tsc-guest-clocksource-lockup.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:40:23 -0700
Message-ID: <200708092140.l79LeND4020952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbXHIVkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: fix non-TSC guest clocksource lockup
has been added to the -mm tree.  Its filename is
     lguest-fix-non-tsc-guest-clocksource-lockup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: fix non-TSC guest clocksource lockup
From: Rusty Russell <rusty@rustcorp.com.au>

lguest uses a host-supplied wallclock-based clocksource when the TSC is not
reliable.  As this is already in nanoseconds, I naively used a multiplier of 1
and a shift of 0.

But update_wall_time() in its infinite wisdom decides to adjust the clock a
little (where does it think it's getting a more accurate time from?)

It will happily tweak the multiplier... to 0, then -1.

So the "fix" is to use a shift of 22 like everyone else, and a
multiplier of 1 << 22.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-fix-non-tsc-guest-clocksource-lockup drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-fix-non-tsc-guest-clocksource-lockup
+++ a/drivers/lguest/lguest.c
@@ -687,7 +687,8 @@ static struct clocksource lguest_clock =
 	.rating		= 400,
 	.read		= lguest_clock_read,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1,
+	.mult		= 1 << 22,
+	.shift		= 22,
 };
 
 /* The "scheduler clock" is just our real clock, adjusted to start at zero */
@@ -770,7 +771,6 @@ static void lguest_time_init(void)
 	 * way, the "rating" is initialized so high that it's always chosen
 	 * over any other clocksource. */
 	if (lguest_data.tsc_khz) {
-		lguest_clock.shift = 22;
 		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
 							 lguest_clock.shift);
 		lguest_clock.flags = CLOCK_SOURCE_IS_CONTINUOUS;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
lguest-fix-non-tsc-guest-clocksource-lockup.patch
lguest-ldso-on-fc7-is-mmaping-shared-libraries-right-in-over-guest-memory.patch
git-kvm.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
