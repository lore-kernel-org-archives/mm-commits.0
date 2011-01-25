From: akpm@linux-foundation.org
Subject: + drbd-fix-warning.patch added to -mm tree
Date: Tue, 25 Jan 2011 13:56:21 -0800
Message-ID: <201101252230.p0PMUHHl011859__26379.0450561375$1295994671$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255Ab1AYWa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 17:30:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, axboe@kernel.dk, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com


The patch titled
     drbd: fix warning
has been added to the -mm tree.  Its filename is
     drbd-fix-warning.patch

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
Subject: drbd: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

In file included from drivers/block/drbd/drbd_main.c:54:                        drivers/block/drbd/drbd_int.h:1190: warning: parameter has incomplete type

Forward declarations of enums do not work.

Fix it unpleasantly by moving the prototype.

Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_int.h |    2 --
 drivers/block/drbd/drbd_req.h |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/drbd/drbd_int.h~drbd-fix-warning drivers/block/drbd/drbd_int.h
--- a/drivers/block/drbd/drbd_int.h~drbd-fix-warning
+++ a/drivers/block/drbd/drbd_int.h
@@ -1186,8 +1186,6 @@ extern void drbd_free_resources(struct d
 extern void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 		       unsigned int set_size);
 extern void tl_clear(struct drbd_conf *mdev);
-enum drbd_req_event;
-extern void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
 extern void _tl_add_barrier(struct drbd_conf *, struct drbd_tl_epoch *);
 extern void drbd_free_sock(struct drbd_conf *mdev);
 extern int drbd_send(struct drbd_conf *mdev, struct socket *sock,
diff -puN drivers/block/drbd/drbd_req.h~drbd-fix-warning drivers/block/drbd/drbd_req.h
--- a/drivers/block/drbd/drbd_req.h~drbd-fix-warning
+++ a/drivers/block/drbd/drbd_req.h
@@ -357,4 +357,7 @@ static inline int req_mod(struct drbd_re
 
 	return rv;
 }
+
+extern void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
+
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-pgtable-genericc-fix-config_swap=n-build.patch
change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch
change-acquire-release_console_sem-to-console_lock-unlock-fix-2.patch
memcg-fix-race-at-move_parent-around-compound_order-checkpatch-fixes.patch
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
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

