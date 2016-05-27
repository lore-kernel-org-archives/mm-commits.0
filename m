From: akpm@linux-foundation.org
Subject: [merged]
 drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch removed from -mm tree
Date: Fri, 27 May 2016 11:45:15 -0700
Message-ID: <574895bb.Dfa4koCyXPPtDVi8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0SpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, airlied@linux.ie, alexander.deucher@amd.com, arnd@arndb.de, christian.koenig@amd.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdgpu: make amdgpu_mn_get wait for mmap_sem killable
has been removed from the -mm tree.  Its filename was
     drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

[arnd@arndb.de: use ERR_PTR() to return from amdgpu_mn_get]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Christian K=F6nig <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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
+		return ERR_PTR(-EINTR);
+	}
=20
 	hash_for_each_possible(adev->mn_hash, rmn, node, (unsigned long)mm)
 		if (rmn->mm =3D=3D mm)
_

Patches currently in -mm which might be from mhocko@suse.com are

oom_reaper-close-race-with-exiting-task.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
