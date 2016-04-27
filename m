From: akpm@linux-foundation.org
Subject: + drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch
 added to -mm tree
Date: Wed, 27 Apr 2016 13:51:13 -0700
Message-ID: <57212641.bdIvwluBXLYr4NhV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbcD0UvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 16:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, airlied@linux.ie, alexander.deucher@amd.com, christian.koenig@amd.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdgpu: make amdgpu_mn_get wait for mmap_sem killable
has been added to the -mm tree.  Its filename is
     drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-amdgpu-make-amdgpu_mn_=
get-wait-for-mmap_sem-killable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-amdgpu-make-amdgpu_mn_=
get-wait-for-mmap_sem-killable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Michal Hocko <mhocko@suse.com>
Subject: drm/amdgpu: make amdgpu_mn_get wait for mmap_sem killable

amdgpu_mn_get which is called during ioct path relies on mmap_sem for
write.  If the waiting task gets killed by the oom killer it would bloc=
k
oom_reaper from asynchronous address space reclaim and reduce the chanc=
es
of timely OOM resolving.  Wait for the lock in the killable mode and
return with EINTR if the task got killed while waiting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Christian K=F6nig <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c~drm-amdgpu-make-amdgpu=
_mn_get-wait-for-mmap_sem-killable drivers/gpu/drm/amd/amdgpu/amdgpu_mn=
=2Ec
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c~drm-amdgpu-make-amdgpu_mn_=
get-wait-for-mmap_sem-killable
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
@@ -232,7 +232,10 @@ static struct amdgpu_mn *amdgpu_mn_get(s
 	int r;
=20
 	mutex_lock(&adev->mn_lock);
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem)) {
+		mutex_unlock(&adev->mn_lock);
+		return -EINTR;
+	}
=20
 	hash_for_each_possible(adev->mn_hash, rmn, node, (unsigned long)mm)
 		if (rmn->mm =3D=3D mm)
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.pat=
ch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try=
-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patc=
h
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clea=
r-oom_reaper_list-before-clearing-tif_memdie.patch
vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.pat=
ch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.=
patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-use-compaction-feedback-for-thp-backoff-conditions.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-page=
s.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-fo=
r-costly-orders.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patc=
h
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.pa=
tch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fi=
x.patch
mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls.patch
mm-make-vm_mmap-killable.patch
mm-make-vm_munmap-killable.patch
mm-aout-handle-vm_brk-failures.patch
mm-elf-handle-vm_brk-error.patch
mm-make-vm_brk-killable.patch
mm-proc-make-clear_refs-killable.patch
mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable.patch
ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable.patch
vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killa=
ble.patch
coredump-make-coredump_wait-wait-for-mmap_sem-for-write-killable.patch
aio-make-aio_setup_ring-killable.patch
exec-make-exec-path-waiting-for-mmap_sem-killable.patch
prctl-make-pr_set_thp_disable-wait-for-mmap_sem-killable.patch
uprobes-wait-for-mmap_sem-for-write-killable.patch
drm-i915-make-i915_gem_mmap_ioctl-wait-for-mmap_sem-killable.patch
drm-radeon-make-radeon_mn_get-wait-for-mmap_sem-killable.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
