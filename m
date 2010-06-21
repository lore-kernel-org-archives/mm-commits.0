From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-i915-remove-duplicate-structure-field-initialization.patch added to -mm tree
Date: Mon, 21 Jun 2010 15:58:19 -0700
Message-ID: <201006212258.o5LMwJFG010129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881Ab0FUW6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 18:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/gpu/drm/i915: remove duplicate structure field initialization
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-i915-remove-duplicate-structure-field-initialization.patch

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
Subject: drivers/gpu/drm/i915: remove duplicate structure field initialization
From: Julia Lawall <julia@diku.dk>

In each case, is_mobile is defined twice to 1.  Drop one initialization.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier I, s, fld;
position p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@s@
identifier I, s, r.fld;
position r.p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@script:python@
p0 << r.p0;
fld << r.fld;
ps << s.p;
pr << r.p;
@@

if int(ps[0].line)<int(pr[0].line) or int(ps[0].column)<int(pr[0].column):
  cocci.print_main(fld,p0)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_drv.c~drivers-gpu-drm-i915-remove-duplicate-structure-field-initialization drivers/gpu/drm/i915/i915_drv.c
--- a/drivers/gpu/drm/i915/i915_drv.c~drivers-gpu-drm-i915-remove-duplicate-structure-field-initialization
+++ a/drivers/gpu/drm/i915/i915_drv.c
@@ -97,7 +97,7 @@ static const struct intel_device_info in
 };
 
 static const struct intel_device_info intel_i965gm_info = {
-	.is_i965g = 1, .is_mobile = 1, .is_i965gm = 1, .is_i9xx = 1,
+	.is_i965g = 1, .is_i965gm = 1, .is_i9xx = 1,
 	.is_mobile = 1, .has_fbc = 1, .has_rc6 = 1,
 	.has_hotplug = 1,
 };
@@ -114,7 +114,7 @@ static const struct intel_device_info in
 };
 
 static const struct intel_device_info intel_gm45_info = {
-	.is_i965g = 1, .is_mobile = 1, .is_g4x = 1, .is_i9xx = 1,
+	.is_i965g = 1, .is_g4x = 1, .is_i9xx = 1,
 	.is_mobile = 1, .need_gfx_hws = 1, .has_fbc = 1, .has_rc6 = 1,
 	.has_pipe_cxsr = 1,
 	.has_hotplug = 1,
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-hid-eliminate-a-double-lock.patch
arch-sh-mm-eliminate-a-double-lock.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-gpu-drm-i915-remove-duplicate-structure-field-initialization.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch

