Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6793618D4BD
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 21:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722287341; cv=none; b=B/ZkI2nEzD97eeIHMRm7ceAxAgiRmoEAyt+gF9rlMr6OSeJcNPOnglEIJeaSOHv4i0foJwBdWCf9qbVCJHCX6Gjrf+4DuesfCAdYdzFNmltsUtzOHs8/A3gvc/bP3XuS1ln4gHi3/STEj+Nj2YdhYqBalAfqaaiMR8agiFoTEqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722287341; c=relaxed/simple;
	bh=Z9mWyhyNCIkdgkmQH1suF7/icYnT26si/+SlQ6YBI3Y=;
	h=Date:To:From:Subject:Message-Id; b=CK6ozHUF1zstki/XsuVwE8OqLUUFSh4IyqDo6/zSLLsghzDMRv07AxdR2RKvoK0YriK7msP6SYbnz1LYN6fQJlKOeX1GQoWYQRiUQaAGjXYAjLtzE6fwLImI3C9duCjFcKkKf/Abk+j+PTOYE0h1vXrMVPVlGB0a97MQhwcQ4Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s64MShQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s64MShQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16902C32786;
	Mon, 29 Jul 2024 21:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722287341;
	bh=Z9mWyhyNCIkdgkmQH1suF7/icYnT26si/+SlQ6YBI3Y=;
	h=Date:To:From:Subject:From;
	b=s64MShQtc46rXQisEZsN9VeLAnTR4syvcdawdLsgWBlAgoINPlGX+tQW6ToHIK493
	 vEutKpEbpFTfKEL1wX6zvuNjucGuUFjwOz0vebDgEF2jeX++Vfj2QLM4DDvLbWhh+8
	 f7qzpwCsLWNKMRFUvU0A+g96N9//MUI+QZOBW67s=
Date: Mon, 29 Jul 2024 14:09:00 -0700
To: mm-commits@vger.kernel.org,jannh@google.com,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-procfs-remove-build-id-related-code-duplication-in-procmap_query.patch added to mm-nonmm-unstable branch
Message-Id: <20240729210901.16902C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/procfs: remove build ID-related code duplication in PROCMAP_QUERY
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-procfs-remove-build-id-related-code-duplication-in-procmap_query.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-procfs-remove-build-id-related-code-duplication-in-procmap_query.patch

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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: fs/procfs: remove build ID-related code duplication in PROCMAP_QUERY
Date: Mon, 29 Jul 2024 10:40:44 -0700

A piece of build ID handling code in PROCMAP_QUERY ioctl() was
accidentally duplicated.  It wasn't meant to be part of ed5d583a88a9
("fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps")
commit, which is what introduced duplication.

It has no correctness implications, but we unnecessarily perform the same
work twice, if build ID parsing is requested.  Drop the duplication.

Link: https://lkml.kernel.org/r/20240729174044.4008399-1-andrii@kernel.org
Fixes: ed5d583a88a9 ("fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reported-by: Jann Horn <jannh@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/fs/proc/task_mmu.c~fs-procfs-remove-build-id-related-code-duplication-in-procmap_query
+++ a/fs/proc/task_mmu.c
@@ -543,21 +543,6 @@ static int do_procmap_query(struct proc_
 		}
 	}
 
-	if (karg.build_id_size) {
-		__u32 build_id_sz;
-
-		err = build_id_parse(vma, build_id_buf, &build_id_sz);
-		if (err) {
-			karg.build_id_size = 0;
-		} else {
-			if (karg.build_id_size < build_id_sz) {
-				err = -ENAMETOOLONG;
-				goto out;
-			}
-			karg.build_id_size = build_id_sz;
-		}
-	}
-
 	if (karg.vma_name_size) {
 		size_t name_buf_sz = min_t(size_t, PATH_MAX, karg.vma_name_size);
 		const struct path *path;
_

Patches currently in -mm which might be from andrii@kernel.org are

fs-procfs-remove-build-id-related-code-duplication-in-procmap_query.patch

