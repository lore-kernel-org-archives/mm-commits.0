From: akpm@linux-foundation.org
Subject: [patch 82/84] drm/radeon: make radeon_mn_get wait for mmap_sem
 killable
Date: Mon, 23 May 2016 16:26:14 -0700
Message-ID: <57439196.2nzAEj0dYFX2Cs8X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbcEWX0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:26:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, airlied@linux.ie, alexander.deucher@amd.com, christian.koenig@amd.com, vbabka@suse.cz

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
--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
