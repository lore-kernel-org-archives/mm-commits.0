From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-i915-intel_spritec-fix-build.patch added to -mm tree
Date: Fri, 22 May 2015 13:51:31 -0700
Message-ID: <555f96d3.E5cqy5ePb/LlUc6Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbbEVUvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 16:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.vetter@ffwll.ch, gustavo.padovan@collabora.co.uk, ville.syrjala@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/i915/intel_sprite.c: fix build
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-i915-intel_spritec-fix-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-gpu-drm-i915-intel_spritec-fix-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-gpu-drm-i915-intel_spritec-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/gpu/drm/i915/intel_sprite.c: fix build

gcc-4.4.4:

cc1: warnings being treated as errors
drivers/gpu/drm/i915/intel_sprite.c: In function 'intel_check_sprite_plane':
drivers/gpu/drm/i915/intel_sprite.c:767: error: 'src_x' may be used uninitialized in this function
drivers/gpu/drm/i915/intel_sprite.c:767: error: 'src_y' may be used uninitialized in this function
drivers/gpu/drm/i915/intel_sprite.c:767: error: 'src_w' may be used uninitialized in this function
drivers/gpu/drm/i915/intel_sprite.c:767: error: 'src_h' may be used uninitialized in this function

Fixes: 96d61a7f267f ("drm/i915: split intel_update_plane into check() and commit()")
Cc: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_sprite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/intel_sprite.c~drivers-gpu-drm-i915-intel_spritec-fix-build drivers/gpu/drm/i915/intel_sprite.c
--- a/drivers/gpu/drm/i915/intel_sprite.c~drivers-gpu-drm-i915-intel_spritec-fix-build
+++ a/drivers/gpu/drm/i915/intel_sprite.c
@@ -764,7 +764,7 @@ intel_check_sprite_plane(struct drm_plan
 	struct drm_framebuffer *fb = state->base.fb;
 	int crtc_x, crtc_y;
 	unsigned int crtc_w, crtc_h;
-	uint32_t src_x, src_y, src_w, src_h;
+	uint32_t src_x = 0, src_y = 0, src_w = 0, src_h = 0;
 	struct drm_rect *src = &state->src;
 	struct drm_rect *dst = &state->dst;
 	const struct drm_rect *clip = &state->clip;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-kvm-mmuc-work-around-gcc-444-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch

