Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B4714B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908593; cv=none; b=ZNttgglAI46xft2efwwMNntMaB4hMXhC1/fouN7lwwh0X/YPNK/TnTxZMcOQqFYjL9MfpLD0c4L1iFk12atuAyWhpdr0W/FsTfZOhV2sahZGmvqcNOMc8cEJCIp2+ybnj8ZPPIYFdtVHxlMp/B54WYdMY4jMqgCTPD0R46VuW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908593; c=relaxed/simple;
	bh=WptmHO+PilLvMG/DwEUdUk/TCHbD1vI6Q7D01GlXMbY=;
	h=Date:To:From:Subject:Message-Id; b=byWMfdVk2Bp/omRpKeAiBzTT22QvuSrCAs+A987Kw8g67mtsN91DR0W1PYwtY4FfF/1KUGNUfCpnZvbkCQQjaV3bIIGwOfppmtncMGtZC+9GHVf6BPNq0z0iw8WSwCq9iFnSfbg2yzcLc56rcgrRbrEk4gzR5FiMBFFaSKSlFUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B1htzLmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B1htzLmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD067C116D0;
	Wed, 12 Nov 2025 00:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908592;
	bh=WptmHO+PilLvMG/DwEUdUk/TCHbD1vI6Q7D01GlXMbY=;
	h=Date:To:From:Subject:From;
	b=B1htzLmo72wkMnjULVUKW2n5ZwuN7U9y0vVVna2Qc3Q0AX566YugiDvZyt3Lmokxl
	 f3tqMC+BBDem1uY8ljCKEvI79qxZt4yH8XtMBSeqKsYcZi50BryiH/4+JOXlLzYezI
	 UiB0uaI6KOYTtaDC9USPUQfr6JRPMa0ypaZmAWJQ=
Date: Tue, 11 Nov 2025 16:49:52 -0800
To: mm-commits@vger.kernel.org,vlad_kulikov_c@pm.me,mawupeng1@huawei.com,jack@suse.cz,david@redhat.com,cyphar@cyphar.com,brauner@kernel.org,vlad.kulikov.c@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-create_ipc_ns-drop-mqueue-mount-on-sysctl-setup-failure.patch removed from -mm tree
Message-Id: <20251112004952.BD067C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure
has been removed from the -mm tree.  Its filename was
     ipc-create_ipc_ns-drop-mqueue-mount-on-sysctl-setup-failure.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
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


