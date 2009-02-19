From: akpm@linux-foundation.org
Subject: + drm-radeon-fix-unaligned-access-in-r300_scratch.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:48:13 -0800
Message-ID: <200902192048.n1JKmDY7021936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757693AbZBSUsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:48:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, airlied@linux.ie, benh@kernel.crashing.org


The patch titled
     drm: radeon: fix unaligned access in r300_scratch().
has been added to the -mm tree.  Its filename is
     drm-radeon-fix-unaligned-access-in-r300_scratch.patch

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
Subject: drm: radeon: fix unaligned access in r300_scratch().
From: David Miller <davem@davemloft.net>

In compat mode, the cmdbuf->buf 64-bit address cookie can potentially be
only 32-bit aligned.  Dereferencing this as 64-bit causes expensive
unaligned traps on platforms like sparc64.

Use get_unaligned() to fix.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/r300_cmdbuf.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/radeon/r300_cmdbuf.c~drm-radeon-fix-unaligned-access-in-r300_scratch drivers/gpu/drm/radeon/r300_cmdbuf.c
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c~drm-radeon-fix-unaligned-access-in-r300_scratch
+++ a/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -37,6 +37,8 @@
 #include "radeon_drv.h"
 #include "r300_reg.h"
 
+#include <asm/unaligned.h>
+
 #define R300_SIMULTANEOUS_CLIPRECTS		4
 
 /* Values for R300_RE_CLIPRECT_CNTL depending on the number of cliprects
@@ -917,6 +919,7 @@ static int r300_scratch(drm_radeon_priva
 {
 	u32 *ref_age_base;
 	u32 i, buf_idx, h_pending;
+	u64 ptr_addr;
 	RING_LOCALS;
 
 	if (cmdbuf->bufsz <
@@ -930,7 +933,8 @@ static int r300_scratch(drm_radeon_priva
 
 	dev_priv->scratch_ages[header.scratch.reg]++;
 
-	ref_age_base =  (u32 *)(unsigned long)*((uint64_t *)cmdbuf->buf);
+	ptr_addr = get_unaligned((u64 *)cmdbuf->buf);
+	ref_age_base = (u32 *)(unsigned long)ptr_addr;
 
 	cmdbuf->buf += sizeof(u64);
 	cmdbuf->bufsz -= sizeof(u64);
_

Patches currently in -mm which might be from davem@davemloft.net are

linux-next.patch
sfc-modify-allocation-error-message.patch
drm-only-use-drm_ioctl_update_draw-compat-wrapper-for-compat-x86.patch
drm-radeon-fix-unaligned-access-in-r300_scratch.patch
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

