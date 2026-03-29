Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A52236EE
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744793; cv=none; b=FhFl6W43BQuGpVFBb+RmzunR2JhYnMJPcVSJdPvoElOofHnyEs9m+NIOW7Z0IgnE5sI965hv14a87c/Cb+OnAcH7IAFKJmXxVAhezJnyjqqmvE6OJfoBwwTZ3YrxM6mu7UOC/7kTTl+MTnfAI+Q4AFOXbx0tqJ/16t2ekQidZmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744793; c=relaxed/simple;
	bh=mKuD8MBLQTXShkO1djIhAFPK/dEN8AwJeoQHYiCU6yA=;
	h=Date:To:From:Subject:Message-Id; b=VHl5GGzgIY2TxYB42bngpUzTfjmzaLnB7DAKgv/y7L4ztMgRMuZcQJTlY6K9s4EYL9Bo0pq/oS9yi+Bs5NOHa4PEryFm4BC2OOdf16nEFoNENKL0SxXOKyVq9YbRhoZTCPxC76R5y8NzosGarBUequ5v7z2ugOD2GHtECaHHZwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GG1et/ST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GG1et/ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA37C4CEF7;
	Sun, 29 Mar 2026 00:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744793;
	bh=mKuD8MBLQTXShkO1djIhAFPK/dEN8AwJeoQHYiCU6yA=;
	h=Date:To:From:Subject:From;
	b=GG1et/STTNDpfC4AWmtqSYJjk8ABtB2hPk5byibXBd0aDMRsbqxtJUTclQ2Ls+11s
	 a7GV2Slq/hN76MNkUMaXqS8hTRHHX/OSVbWvoLeZX5KKfQQf3xuUwd2bblbjbxoCQJ
	 VrhxHHUURmhLuF4qHmzVrmnJukj1eYb25sHubyYU=
Date: Sat, 28 Mar 2026 17:39:52 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,d@ilvokhin.com,maninder1.s@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_killc-simpilfy-rcu-call-with-guardrcu.patch removed from -mm tree
Message-Id: <20260329003952.ECA37C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill.c: simpilfy rcu call with guard(rcu)
has been removed from the -mm tree.  Its filename was
     mm-oom_killc-simpilfy-rcu-call-with-guardrcu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: mm/oom_kill.c: simpilfy rcu call with guard(rcu)
Date: Tue, 3 Mar 2026 15:56:00 +0530

guard(rcu)() simplifies code readability and there is no need of extra
goto labels.

Thus replacing rcu_read_lock/unlock with guard(rcu)().

Link: https://lkml.kernel.org/r/20260303102600.105255-1-maninder1.s@samsung.com
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/oom_kill.c~mm-oom_killc-simpilfy-rcu-call-with-guardrcu
+++ a/mm/oom_kill.c
@@ -135,19 +135,16 @@ struct task_struct *find_lock_task_mm(st
 {
 	struct task_struct *t;
 
-	rcu_read_lock();
+	guard(rcu)();
 
 	for_each_thread(p, t) {
 		task_lock(t);
 		if (likely(t->mm))
-			goto found;
+			return t;
 		task_unlock(t);
 	}
-	t = NULL;
-found:
-	rcu_read_unlock();
 
-	return t;
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from maninder1.s@samsung.com are


