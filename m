Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544D333442
	for <mm-commits@vger.kernel.org>; Thu, 30 Apr 2026 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777563476; cv=none; b=OnhskDnxUl13R11C2VH2f+838asQXFOk86+jVsRXex0GuccllzWAdlfpBG1dg78RcT/Wju+1hZHEU+Hz1SvZXLK2pnocXuP3vAkGVwc+hP/lB3YyaHokVmg2M5h6yOewKzuX4tlZBsiFK4HUt2I30tiIB1cXK2VQ61Zl5UBaThY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777563476; c=relaxed/simple;
	bh=ceRyVpQbv2q9uifaMvIbAlmOsi06l0AZm1w6IvX3I2M=;
	h=Date:To:From:Subject:Message-Id; b=IUk0YD2oQyB+mJE853Ro/DvkgneZg5CITRx3xKJr3d3Ds4MKth9t5tmQUyc2FXBQqsW/OiwlBZg5+g3PyBtY+ASp6SvLT8ETT7t36cjWX9fjcTkeSW0NoaQleceCtI2NXTrpCYEUyfGsBA2o27isdjD9Z/ZmiN7Fin2fpOatyEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EP11xZDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EP11xZDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E362FC2BCB8;
	Thu, 30 Apr 2026 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777563475;
	bh=ceRyVpQbv2q9uifaMvIbAlmOsi06l0AZm1w6IvX3I2M=;
	h=Date:To:From:Subject:From;
	b=EP11xZDqLDWrhBuph+M77OaJquSzjbVO5mNb3u4/pVUX2k30g2FwMjUacMhH41m2W
	 cRBNUY7tUEkyuQt8jLnB2yO6YFS156FDnHMgObK2dIyZxFl50H7oKFoGWGELj3nn8M
	 /ZGVAeQHne4020jWcAHHElWNGqEsnsuSSZcuNOps=
Date: Thu, 30 Apr 2026 08:37:54 -0700
To: mm-commits@vger.kernel.org,yuantan098@gmail.com,yifanwucs@gmail.com,tomapufckgml@gmail.com,stable@kernel.org,sergeh@kernel.org,serge@hallyn.com,segoon@openwall.com,oleg@redhat.com,n05ec@lzu.edu.cn,ljs@kernel.org,liam@infradead.org,kees@kernel.org,dave@stgolabs.net,brauner@kernel.org,bird@lzu.edu.cn,aha310510@gmail.com,zylzyl2333@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-shm-serialize-orphan-cleanup-with-shm_nattch-updates.patch added to mm-hotfixes-unstable branch
Message-Id: <20260430153754.E362FC2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc/shm: serialize orphan cleanup with shm_nattch updates
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ipc-shm-serialize-orphan-cleanup-with-shm_nattch-updates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-shm-serialize-orphan-cleanup-with-shm_nattch-updates.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yilin Zhu <zylzyl2333@gmail.com>
Subject: ipc/shm: serialize orphan cleanup with shm_nattch updates
Date: Thu, 30 Apr 2026 13:21:34 +0800

shm_destroy_orphaned() walks the shm idr under shm_ids(ns).rwsem, but that
does not serialize all fields tested by shm_may_destroy().  In particular,
shm_nattch is updated while holding shm_perm.lock, and attach paths can do
that without holding the rwsem.

Do not decide that an orphaned segment is unused before taking the object
lock.  Move the shm_may_destroy() check under shm_perm.lock, matching the
other destroy paths, and unlock the segment when it no longer qualifies
for removal.

Link: https://lore.kernel.org/9d97cc1031de2d0bace0edf3a668818aa2f4eca6.1777410234.git.zylzyl2333@gmail.com
Fixes: 4c677e2eefdb ("shm: optimize locking and ipc_namespace getting")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yilin Zhu <zylzyl2333@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Serge Hallyn <sergeh@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/ipc/shm.c~ipc-shm-serialize-orphan-cleanup-with-shm_nattch-updates
+++ a/ipc/shm.c
@@ -418,15 +418,17 @@ static int shm_try_destroy_orphaned(int
 	 * We want to destroy segments without users and with already
 	 * exit'ed originating process.
 	 *
-	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
+	 * shm_nattch can be changed under shm_perm.lock without holding the
+	 * rwsem, so take the object lock before checking shm_may_destroy().
 	 */
 	if (!list_empty(&shp->shm_clist))
 		return 0;
 
-	if (shm_may_destroy(shp)) {
-		shm_lock_by_ptr(shp);
+	shm_lock_by_ptr(shp);
+	if (shm_may_destroy(shp))
 		shm_destroy(ns, shp);
-	}
+	else
+		shm_unlock(shp);
 	return 0;
 }
 
_

Patches currently in -mm which might be from zylzyl2333@gmail.com are

ipc-shm-serialize-orphan-cleanup-with-shm_nattch-updates.patch

