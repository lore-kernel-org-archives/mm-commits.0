From: akpm@linux-foundation.org
Subject: +
 drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix.patch added to -mm tree
Date: Thu, 28 Apr 2016 14:13:08 -0700
Message-ID: <57227ce4.qih6hTR+j89///iE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbcD1VNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2016 17:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@suse.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdgpu: use ERR_PTR() to return from amdgpu_mn_get
has been added to the -mm tree.  Its filename is
     drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drm/amdgpu: use ERR_PTR() to return from amdgpu_mn_get

The newly added failure path in amdgpu_mn_get() use the
wrong return type:

drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c: In function 'amdgpu_mn_get':
drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:237:10: error: return makes pointer from integer without a cast

This adds the necessary ERR_PTR() conversion.

Fixes: ad35eee9fb17 ("drm/amdgpu: make amdgpu_mn_get wait for mmap_sem killable")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c~drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c~drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
@@ -234,7 +234,7 @@ static struct amdgpu_mn *amdgpu_mn_get(s
 	mutex_lock(&adev->mn_lock);
 	if (down_write_killable(&mm->mmap_sem)) {
 		mutex_unlock(&adev->mn_lock);
-		return -EINTR;
+		return ERR_PTR(-EINTR);
 	}
 
 	hash_for_each_possible(adev->mn_hash, rmn, node, (unsigned long)mm)
_

Patches currently in -mm which might be from arnd@arndb.de are

kernel-padata-hide-unused-functions.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix.patch

