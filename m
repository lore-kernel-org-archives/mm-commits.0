From: akpm@linux-foundation.org
Subject: [patch 81/84] drm/i915: make i915_gem_mmap_ioctl wait for
 mmap_sem killable
Date: Mon, 23 May 2016 16:26:11 -0700
Message-ID: <57439193.nLEJbnY04OkwBVS0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbcEWX0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:26:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, airlied@linux.ie, daniel.vetter@intel.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: drm/i915: make i915_gem_mmap_ioctl wait for mmap_sem killable

i915_gem_mmap_ioctl relies on mmap_sem for write.  If the waiting task
gets killed by the oom killer it would block oom_reaper from asynchronous
address space reclaim and reduce the chances of timely OOM resolving. 
Wait for the lock in the killable mode and return with EINTR if the task
got killed while waiting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~drm-i915-make-i915_gem_mmap_ioctl-wait-for-mmap_sem-killable drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drm-i915-make-i915_gem_mmap_ioctl-wait-for-mmap_sem-killable
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -1754,7 +1754,10 @@ i915_gem_mmap_ioctl(struct drm_device *d
 		struct mm_struct *mm = current->mm;
 		struct vm_area_struct *vma;
 
-		down_write(&mm->mmap_sem);
+		if (down_write_killable(&mm->mmap_sem)) {
+			drm_gem_object_unreference_unlocked(obj);
+			return -EINTR;
+		}
 		vma = find_vma(mm, addr);
 		if (vma)
 			vma->vm_page_prot =
_
