From: akpm@linux-foundation.org
Subject: [folded] epoll-epoll_wait-should-not-use-timespec_add_ns-fix.patch removed from -mm tree
Date: Tue, 01 Feb 2011 15:44:22 -0800
Message-ID: <201102012344.p11NiMf6005506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab1BAXo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 18:44:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, eric.dumazet@gmail.com, shawn.bohrer@gmail.com, sim@hostway.ca, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     epoll-epoll_wait-should-not-use-timespec_add_ns-fix
has been removed from the -mm tree.  Its filename was
     epoll-epoll_wait-should-not-use-timespec_add_ns-fix.patch

This patch was dropped because it was folded into epoll-epoll_wait-should-not-use-timespec_add_ns.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll-epoll_wait-should-not-use-timespec_add_ns-fix
From: Andrew Morton <akpm@linux-foundation.org>

s/epoll_set_mstimeout/ep_set_mstimeout/, per Davide

Cc: <stable@kernel.org>		[2.6.37.x]
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Simon Kirby <sim@hostway.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-epoll_wait-should-not-use-timespec_add_ns-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-epoll_wait-should-not-use-timespec_add_ns-fix
+++ a/fs/eventpoll.c
@@ -1114,7 +1114,7 @@ static int ep_send_events(struct eventpo
 	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
 }
 
-static inline struct timespec epoll_set_mstimeout(long ms)
+static inline struct timespec ep_set_mstimeout(long ms)
 {
 	struct timespec now, ts = {
 		.tv_sec = ms / MSEC_PER_SEC,
@@ -1135,7 +1135,7 @@ static int ep_poll(struct eventpoll *ep,
 	ktime_t expires, *to = NULL;
 
 	if (timeout > 0) {
-		struct timespec end_time = epoll_set_mstimeout(timeout);
+		struct timespec end_time = ep_set_mstimeout(timeout);
 
 		slack = select_estimate_accuracy(&end_time);
 		to = &expires;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-epoll_wait-should-not-use-timespec_add_ns.patch
maintainers-fixup-simtec-support-email-entries-fix.patch
thp-fix-splitting-of-hwpoisoned-hugepages-checkpatch-fixes.patch
thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix.patch
thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

