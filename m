From: akpm@linux-foundation.org
Subject: [folded] fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:08:54 -0700
Message-ID: <200906162208.n5GM8sGl004910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbZFPWJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@redhat.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm, pjones@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch

This patch was dropped because it was folded into fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#86: FILE: drivers/video/fbmem.c:1471:
+	if (gen->aperture_base > hw->aperture_base && gen->aperture_base <= hw->aperture_base + hw->aperture_size)

WARNING: line over 80 characters
#103: FILE: drivers/video/fbmem.c:1504:
+			if (fb_do_apertures_overlap(registered_fb[i], fb_info)) {

WARNING: printk() should include KERN_ facility level
#104: FILE: drivers/video/fbmem.c:1505:
+				printk("fb: conflicting fb hw usage %s vs %s - removing generic driver\n",

WARNING: line over 80 characters
#105: FILE: drivers/video/fbmem.c:1506:
+				       fb_info->fix.id, registered_fb[i]->fix.id);

total: 0 errors, 4 warnings, 143 lines checked

./patches/fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Airlie <airlied@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes
+++ a/drivers/video/fbmem.c
@@ -1502,8 +1502,10 @@ register_framebuffer(struct fb_info *fb_
 
 		if (registered_fb[i]->flags & FBINFO_MISC_FIRMWARE) {
 			if (fb_do_apertures_overlap(registered_fb[i], fb_info)) {
-				printk("fb: conflicting fb hw usage %s vs %s - removing generic driver\n",
-				       fb_info->fix.id, registered_fb[i]->fix.id);
+				printk(KERN_ERR "fb: conflicting fb hw usage "
+				       "%s vs %s - removing generic driver\n",
+				       fb_info->fix.id,
+				       registered_fb[i]->fix.id);
 				unregister_framebuffer(registered_fb[i]);
 				break;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
firmware_map-fix-hang-with-x86-32bit.patch
mm-consolidate-init_mm-definition.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
mm-clean-up-get_user_pages_fast-documentation.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool.patch
videobuf-dma-contig-zero-copy-userptr-support-v3.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch

