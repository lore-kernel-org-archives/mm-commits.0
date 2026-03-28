Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A096D2DEA75
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671879; cv=none; b=mA4ayZVE7F1d08A5f4zn38/6Q97gcTVDd2cfdBrTD6m0fRhIpQljzASoJsUsNe1njz/hu/3gBIrALgsQvB8Ej0acOo7xnvt9Il+HThg9f645k6t+jHdIt9AdS0eenxjNECJhjzPZXIiyYKxQlX8xFStuQZ5J4u4xZYlagnNh4/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671879; c=relaxed/simple;
	bh=zYkwLyYWNNpsfXintmQwwaGaJbGLr8MVi1didwYq+m4=;
	h=Date:To:From:Subject:Message-Id; b=PAVObThw2oZlQ/zSJSafkqQA2ht+uHvkgwl4mOnPxUHGkvgmW92nspRCe3RbJ42QUc2eKNQJ7m+pTxrRzszO8LJNIfKiIb535qDYd+JkRqH8yUnfA7dAUKXTXgNvcdqgtzrivnvcWo9DxQ/2+NnqpUqU3ByDmf4HafmLSMIH8o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t/uG28+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t/uG28+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49492C4CEF7;
	Sat, 28 Mar 2026 04:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671879;
	bh=zYkwLyYWNNpsfXintmQwwaGaJbGLr8MVi1didwYq+m4=;
	h=Date:To:From:Subject:From;
	b=t/uG28+IZT30VFkkpmB8dPJmk0M3Il2cyQjLFEhDD01qzM2AFtXpXg89mcK+CSMf4
	 0PmRdH96Ox0Ul7EN94bZrsPA+CgEqU0kUEe/P6+fc6+feCqU4lRkIs0SzMhKyHHpj6
	 uPwHFyp93d0hBLY7u1nw7GlyJ0DQZr/rloq+39uA=
Date: Fri, 27 Mar 2026 21:24:38 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,ljs@kernel.org,Liam.Howlett@oracle.com,legion@kernel.org,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,akpm@linux-foundation.org,mge@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] unshare-fix-nsproxy-leak-in-ksys_unshare-on-set_cred_ucounts-failure.patch removed from -mm tree
Message-Id: <20260328042439.49492C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() failure
has been removed from the -mm tree.  Its filename was
     unshare-fix-nsproxy-leak-in-ksys_unshare-on-set_cred_ucounts-failure.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
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
@@ -3174,11 +3174,10 @@ int ksys_unshare(unsigned long unshare_f
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
@@ -3194,8 +3193,10 @@ int ksys_unshare(unsigned long unshare_f
 			shm_init_task(current);
 		}
 
-		if (new_nsproxy)
+		if (new_nsproxy) {
 			switch_task_namespaces(current, new_nsproxy);
+			new_nsproxy = NULL;
+		}
 
 		task_lock(current);
 
@@ -3224,13 +3225,15 @@ int ksys_unshare(unsigned long unshare_f
 
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


