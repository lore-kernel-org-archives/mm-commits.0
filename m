From: akpm@linux-foundation.org
Subject: + drm-only-use-drm_ioctl_update_draw-compat-wrapper-for-compat-x86.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:47:38 -0800
Message-ID: <200902192047.n1JKlcbb021917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856AbZBSUsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, airlied@linux.ie, benh@kernel.crashing.org


The patch titled
     drm: only use DRM_IOCTL_UPDATE_DRAW compat wrapper for compat X86.
has been added to the -mm tree.  Its filename is
     drm-only-use-drm_ioctl_update_draw-compat-wrapper-for-compat-x86.patch

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
Subject: drm: only use DRM_IOCTL_UPDATE_DRAW compat wrapper for compat X86.
From: David Miller <davem@davemloft.net>

Only X86 32-bit uses a different alignment for "unsigned long long" than
it's 64-bit counterpart.

Therefore this compat translation is only correct, and only needed, when
either CONFIG_X86 or CONFIG_IA64.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_ioc32.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/gpu/drm/drm_ioc32.c~drm-only-use-drm_ioctl_update_draw-compat-wrapper-for-compat-x86 drivers/gpu/drm/drm_ioc32.c
--- a/drivers/gpu/drm/drm_ioc32.c~drm-only-use-drm_ioctl_update_draw-compat-wrapper-for-compat-x86
+++ a/drivers/gpu/drm/drm_ioc32.c
@@ -954,6 +954,7 @@ static int compat_drm_sg_free(struct fil
 			 DRM_IOCTL_SG_FREE, (unsigned long)request);
 }
 
+#if defined(CONFIG_X86) || defined(CONFIG_IA64)
 typedef struct drm_update_draw32 {
 	drm_drawable_t handle;
 	unsigned int type;
@@ -984,6 +985,7 @@ static int compat_drm_update_draw(struct
 			DRM_IOCTL_UPDATE_DRAW, (unsigned long)request);
 	return err;
 }
+#endif
 
 struct drm_wait_vblank_request32 {
 	enum drm_vblank_seq_type type;
@@ -1066,7 +1068,9 @@ drm_ioctl_compat_t *drm_compat_ioctls[] 
 #endif
 	[DRM_IOCTL_NR(DRM_IOCTL_SG_ALLOC32)] = compat_drm_sg_alloc,
 	[DRM_IOCTL_NR(DRM_IOCTL_SG_FREE32)] = compat_drm_sg_free,
+#if defined(CONFIG_X86) || defined(CONFIG_IA64)
 	[DRM_IOCTL_NR(DRM_IOCTL_UPDATE_DRAW32)] = compat_drm_update_draw,
+#endif
 	[DRM_IOCTL_NR(DRM_IOCTL_WAIT_VBLANK32)] = compat_drm_wait_vblank,
 };
 
_

Patches currently in -mm which might be from davem@davemloft.net are

linux-next.patch
sfc-modify-allocation-error-message.patch
drm-only-use-drm_ioctl_update_draw-compat-wrapper-for-compat-x86.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch
kprobes-cleanup-aggr_kprobe-related-code.patch
kprobes-move-export_symbol_gpl-just-after-function-definitions.patch
kprobes-cleanup-comment-style-in-kprobesh.patch
kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch
kprobes-support-per-kprobe-disabling.patch
kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
sunxvr500-fix-cmap-memory-leaks.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

