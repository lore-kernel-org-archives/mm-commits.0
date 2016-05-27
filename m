From: akpm@linux-foundation.org
Subject: [merged]
 drm-radeon-make-radeon_mn_get-wait-for-mmap_sem-killable.patch removed from -mm tree
Date: Fri, 27 May 2016 11:45:12 -0700
Message-ID: <574895b8.0vApDEV5DaM23bEd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0SpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, airlied@linux.ie, alexander.deucher@amd.com, christian.koenig@amd.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/radeon: make radeon_mn_get wait for mmap_sem killable
has been removed from the -mm tree.  Its filename was
     drm-radeon-make-radeon_mn_get-wait-for-mmap_sem-killable.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Michal Hocko <mhocko@suse.com>
Subject: drm/radeon: make radeon_mn_get wait for mmap_sem killable

radeon_mn_get which is called during ioct path relies on mmap_sem for
write.  If the waiting task gets killed by the oom killer it would bloc=
k
oom_reaper from asynchronous address space reclaim and reduce the chanc=
es
of timely OOM resolving.  Wait for the lock in the killable mode and
return with EINTR if the task got killed while waiting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Christian K=F6nig <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_mn.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/radeon/radeon_mn.c~drm-radeon-make-radeon_mn_=
get-wait-for-mmap_sem-killable drivers/gpu/drm/radeon/radeon_mn.c
--- a/drivers/gpu/drm/radeon/radeon_mn.c~drm-radeon-make-radeon_mn_get-=
wait-for-mmap_sem-killable
+++ a/drivers/gpu/drm/radeon/radeon_mn.c
@@ -186,7 +186,9 @@ static struct radeon_mn *radeon_mn_get(s
 	struct radeon_mn *rmn;
 	int r;
=20
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return ERR_PTR(-EINTR);
+
 	mutex_lock(&rdev->mn_lock);
=20
 	hash_for_each_possible(rdev->mn_hash, rmn, node, (unsigned long)mm)
_

Patches currently in -mm which might be from mhocko@suse.com are

oom_reaper-close-race-with-exiting-task.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
