Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EE5440B
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 01:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AjNQBvjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9965C433C9;
	Wed, 20 Dec 2023 01:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703034122;
	bh=IGLD3r7rBeNrA+CoEQqmxlOqFPR2EnnWEklVx/zraMM=;
	h=Date:To:From:Subject:From;
	b=AjNQBvjc7mG9N4KASE3qC4Lso5zYLvmcdwIqeLrSfzHt8tpveP3HIEQAUDsUVvMXq
	 OHIJI/Ye6xbdW+yEbZGGLFpqvaEioJELqfUcI+hghtUO3dKhsR1PDGz8XKjyscz8Ig
	 gQR41E0163nYHX/ui8ms6G3lm4QQzsbDFeIYM9U4=
Date: Tue, 19 Dec 2023 17:02:02 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-missing-set_freezable-for-freezable-kthread.patch added to mm-nonmm-unstable branch
Message-Id: <20231220010202.A9965C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add missing set_freezable() for freezable kthread
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-missing-set_freezable-for-freezable-kthread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-missing-set_freezable-for-freezable-kthread.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: nilfs2: add missing set_freezable() for freezable kthread
Date: Tue, 19 Dec 2023 18:09:18 +0900

The kernel thread function nilfs_segctor_thread() invokes the
try_to_freeze() in its loop.  But all the kernel threads are non-freezable
by default.  So if we want to make a kernel thread to be freezable, we
have to invoke set_freezable() explicitly.

Link: https://lkml.kernel.org/r/20231219090918.2329-1-konishi.ryusuke@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/segment.c~nilfs2-add-missing-set_freezable-for-freezable-kthread
+++ a/fs/nilfs2/segment.c
@@ -2588,6 +2588,7 @@ static int nilfs_segctor_thread(void *ar
 		   "segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds",
 		   sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
 
+	set_freezable();
 	spin_lock(&sci->sc_state_lock);
  loop:
 	for (;;) {
_

Patches currently in -mm which might be from haokexin@gmail.com are

mm-ksm-remove-unnecessary-try_to_freeze.patch
fork-remove-redundant-task_uninterruptible.patch
nilfs2-add-missing-set_freezable-for-freezable-kthread.patch

