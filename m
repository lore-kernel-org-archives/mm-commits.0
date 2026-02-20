Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5254A32
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 03:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771556673; cv=none; b=TJ2NoU1qXH9V0/VwOyDn6eU95YcU/+jOIljb9mjWTcsYGTKTuk/yeNh7QkroeRFHA6qhbmdZQTEhwK05IZuerVOps8oC6CpUgqdyAGt9d73E8cAor+MGB9vvlH9bcXjLCz5j4SS4U8+d6K4xLKkrLZLiVPBx6NiiwnP3KpS6fgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771556673; c=relaxed/simple;
	bh=TllIqGme3h/unG/e9/PSVn1nrEswuutUv56QIU7zmNE=;
	h=Date:To:From:Subject:Message-Id; b=bqn6hb5S4aC7T0gcRAbrbQuN3HLpsEyHMC4oi9EPtumcdiWgsA78ioQdfEzsoDu4ni+a7fyUj4FabC/kX0uu7XrM/Y/HIT8CQaZ29iApyrKUWtWYs59bgGdC9Ol4kf/RNV3q+SX0aJXt7PETWVLsSmOQ0ynPvS7AU3xjV93+O6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SzDRfiCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SzDRfiCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3145C4CEF7;
	Fri, 20 Feb 2026 03:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771556672;
	bh=TllIqGme3h/unG/e9/PSVn1nrEswuutUv56QIU7zmNE=;
	h=Date:To:From:Subject:From;
	b=SzDRfiCrKE955YqgmiNTxcGQyh9xIHVxGQrFoKviMb7go8ZifxT9CSp4dg4rWVUe9
	 c8OeZXeT+Xg+En9OaDp8hjeh38l6mlzbMOak86TXm5H8NY3plJobXNs+ZPaVyYtSF3
	 awCZyQFZ2vk2afl5KK6mAULtrCC7dKiOHGQTIpoM=
Date: Thu, 19 Feb 2026 19:04:31 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,legion@kernel.org,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,akpm@linux-foundation.org,mge@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + unshare-fix-nsproxy-leak-in-ksys_unshare-on-set_cred_ucounts-failure.patch added to mm-nonmm-unstable branch
Message-Id: <20260220030432.A3145C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() failure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     unshare-fix-nsproxy-leak-in-ksys_unshare-on-set_cred_ucounts-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/unshare-fix-nsproxy-leak-in-ksys_unshare-on-set_cred_ucounts-failure.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Michal Grzedzicki <mge@meta.com>
Subject: unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() failure
Date: Fri, 13 Feb 2026 11:39:59 -0800

When set_cred_ucounts() fails in ksys_unshare() new_nsproxy is leaked.

Let's call put_nsproxy() if that happens.

Link: https://lkml.kernel.org/r/20260213193959.2556730-1-mge@meta.com
Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
Signed-off-by: Michal Grzedzicki <mge@meta.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Gladkov (Intel) <legion@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/fork.c~unshare-fix-nsproxy-leak-in-ksys_unshare-on-set_cred_ucounts-failure
+++ a/kernel/fork.c
@@ -3179,11 +3179,10 @@ int ksys_unshare(unsigned long unshare_f
 					 new_cred, new_fs);
 	if (err)
 		goto bad_unshare_cleanup_cred;
-
 	if (new_cred) {
 		err = set_cred_ucounts(new_cred);
 		if (err)
-			goto bad_unshare_cleanup_cred;
+			goto bad_unshare_cleanup_nsproxy;
 	}
 
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
@@ -3199,8 +3198,10 @@ int ksys_unshare(unsigned long unshare_f
 			shm_init_task(current);
 		}
 
-		if (new_nsproxy)
+		if (new_nsproxy) {
 			switch_task_namespaces(current, new_nsproxy);
+			new_nsproxy = NULL;
+		}
 
 		task_lock(current);
 
@@ -3229,13 +3230,15 @@ int ksys_unshare(unsigned long unshare_f
 
 	perf_event_namespaces(current);
 
+bad_unshare_cleanup_nsproxy:
+	if (new_nsproxy)
+		put_nsproxy(new_nsproxy);
 bad_unshare_cleanup_cred:
 	if (new_cred)
 		put_cred(new_cred);
 bad_unshare_cleanup_fd:
 	if (new_fd)
 		put_files_struct(new_fd);
-
 bad_unshare_cleanup_fs:
 	if (new_fs)
 		free_fs_struct(new_fs);
_

Patches currently in -mm which might be from mge@meta.com are

unshare-fix-nsproxy-leak-in-ksys_unshare-on-set_cred_ucounts-failure.patch

