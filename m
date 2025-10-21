Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F10634D90E
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 18:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072025; cv=none; b=cmcEY95sto3ll6mQcux2judzRYYgs3Hxqu6lTvtFRK3Q/uRSf+oB3JfDAOxlCAvGpRIP5UZOO393IR7TmjmRMYcSbQQ5L7cVx3u5NOv4Tbk1BlEd9YLv/9Fm+oMDFG/+WUpmx/qL645Awf4xxkAJsiAH2fKTCR+r2YgEi8xPDVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072025; c=relaxed/simple;
	bh=AIolT2lbZB5hGUEPYk+t0eutmXHWYH5CPU9E76zPFRE=;
	h=Date:To:From:Subject:Message-Id; b=MksF3+cyML8Ork1rmJO9B+5P2bVkBT39tyv5hInZfv3a7McR8cN9hn5gZcEeHlXfn8XAKndomJnv4MznGx2XZP2j5YABZ3WN0kbYPnqgnuy6zTbV5w60vTCTsFBwxUH/8Yr2JlV9G8izavl580O0iemnBLvjlh++WEer1KflnZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KtsRoWxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KtsRoWxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E079C4CEF1;
	Tue, 21 Oct 2025 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761072025;
	bh=AIolT2lbZB5hGUEPYk+t0eutmXHWYH5CPU9E76zPFRE=;
	h=Date:To:From:Subject:From;
	b=KtsRoWxiDzI51slubM1frPDiNhzDDf/Ucpuo7KmGnSy1zEOR/yqWFJ8vb1txlI6wV
	 r6UNMupErSmBYhWNl38K3YkWKsYCF/XAJEifi3QPsVbxQDZ7sugFLax+MXmXEkVM29
	 lpcIU/iZOg1wFt+3LYxKDFsZBwTbzr4Ir+daGLDQ=
Date: Tue, 21 Oct 2025 11:40:24 -0700
To: mm-commits@vger.kernel.org,vlad_kulikov_c@pm.me,mawupeng1@huawei.com,jack@suse.cz,david@redhat.com,cyphar@cyphar.com,brauner@kernel.org,vlad.kulikov.c@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-create_ipc_ns-drop-mqueue-mount-on-sysctl-setup-failure.patch added to mm-nonmm-unstable branch
Message-Id: <20251021184025.1E079C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-create_ipc_ns-drop-mqueue-mount-on-sysctl-setup-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-create_ipc_ns-drop-mqueue-mount-on-sysctl-setup-failure.patch

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
From: Vlad Kulikov <vlad.kulikov.c@gmail.com>
Subject: ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure
Date: Tue, 21 Oct 2025 21:13:39 +0300

If setup_mq_sysctls(ns) fails after mq_init_ns(ns) succeeds, the error
path skipped releasing the internal kernel mqueue mount kept in
ns->mq_mnt. That leaves the vfsmount/superblock referenced until final
namespace teardown, i.e. a resource leak on this rare failure edge.

Unwind it by calling mntput(ns->mq_mnt) before dropping user_ns and
freeing the IPC namespace. This mirrors the normal ordering used in
free_ipc_ns().

Link: https://lkml.kernel.org/r/20251021181341.670297-1-vlad_kulikov_c@pm.me
Signed-off-by: Vlad Kulikov <vlad_kulikov_c@pm.me>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/ipc/namespace.c~ipc-create_ipc_ns-drop-mqueue-mount-on-sysctl-setup-failure
+++ a/ipc/namespace.c
@@ -75,10 +75,10 @@ static struct ipc_namespace *create_ipc_
 
 	err = -ENOMEM;
 	if (!setup_mq_sysctls(ns))
-		goto fail_put;
+		goto fail_mq_mount;
 
 	if (!setup_ipc_sysctls(ns))
-		goto fail_mq;
+		goto fail_mq_sysctls;
 
 	err = msg_init_ns(ns);
 	if (err)
@@ -92,9 +92,10 @@ static struct ipc_namespace *create_ipc_
 
 fail_ipc:
 	retire_ipc_sysctls(ns);
-fail_mq:
+fail_mq_sysctls:
 	retire_mq_sysctls(ns);
-
+fail_mq_mount:
+	mntput(ns->mq_mnt);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_common_free(ns);
_

Patches currently in -mm which might be from vlad.kulikov.c@gmail.com are

ipc-create_ipc_ns-drop-mqueue-mount-on-sysctl-setup-failure.patch

