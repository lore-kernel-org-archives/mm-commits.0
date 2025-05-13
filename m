Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8A31EDA04
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119231; cv=none; b=UM+ofieyVpZxuYjwz9owDyHrWKHzH/AM4RNXULQDUHizuGqI7zYiXd5rtFFVJVd32wvKdCmBXJF6kIH28m+NO9DirYvy/sfgPMBgjDOOq8bv1xgjcR7sb/t+pcj7M4haYEEVx9bHrGWiIZdA0FUGrogrZftvCvsxkRimJ33htPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119231; c=relaxed/simple;
	bh=2ZIYdqjrUD7+Nig2ujVQS8S1zHkE6UaxRdaXEpO5cqc=;
	h=Date:To:From:Subject:Message-Id; b=uN4U9bwXRinw22bjutQyZQ1voJv0k8u8gsvFO5q+NOwDyrlSYSVIpJmwt5SslKFFT69CZOJB/RcpwjOPe2jdBiE9fm7SObgJe4GI7drUBc929YtmNlOPmhMB9h8U+ZB8RMWOBGWsEv41sCeIGiG/sFMD0f/TnCw/k63W2y9+6AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vM/LZTsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vM/LZTsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740BAC4CEE4;
	Tue, 13 May 2025 06:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119231;
	bh=2ZIYdqjrUD7+Nig2ujVQS8S1zHkE6UaxRdaXEpO5cqc=;
	h=Date:To:From:Subject:From;
	b=vM/LZTspy0kWo0rywVP4OwQsM2m3SUfHO/TBlg/NcGcVmYR+TFc0uUyjbqjnle5rW
	 O6OKHWTblJUoYTRyzaUk/Lyd12QYTecH9JggOJf/3gDz9vyD6l5QYLPLos/og/Bejf
	 XIkpRRcJYATRp/5uW6s9Zse86UfEG8+3IkPYWyas=
Date: Mon, 12 May 2025 23:53:50 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,gthelen@google.com,brauner@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-introduce-non-blocking-limit-setting-option-v3.patch removed from -mm tree
Message-Id: <20250513065351.740BAC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-introduce-non-blocking-limit-setting-option-v3
has been removed from the -mm tree.  Its filename was
     memcg-introduce-non-blocking-limit-setting-option-v3.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-introduce-non-blocking-limit-setting-option-v3
Date: Tue, 6 May 2025 16:28:33 -0700

add more explanation in doc and commit message on O_NONBLOCK side-effects
(Johannes)

Link: https://lkml.kernel.org/r/20250506232833.3109790-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   34 ++++++++++++++--------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-introduce-non-blocking-limit-setting-option-v3
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1299,12 +1299,17 @@ PAGE_SIZE multiple when read back.
 	monitors the limited cgroup to alleviate heavy reclaim
 	pressure.
 
-        If memory.high is opened with O_NONBLOCK then the synchronous
-        reclaim is bypassed. This is useful for admin processes that
-        need to dynamically adjust the job's memory limits without
-        expending their own CPU resources on memory reclamation. The
-        job will trigger the reclaim and/or get throttled on its
-        next charge request.
+	If memory.high is opened with O_NONBLOCK then the synchronous
+	reclaim is bypassed. This is useful for admin processes that
+	need to dynamically adjust the job's memory limits without
+	expending their own CPU resources on memory reclamation. The
+	job will trigger the reclaim and/or get throttled on its
+	next charge request.
+
+	Please note that with O_NONBLOCK, there is a chance that the
+	target memory cgroup may take indefinite amount of time to
+	reduce usage below the limit due to delayed charge request or
+	busy-hitting its memory to slow down reclaim.
 
   memory.max
 	A read-write single value file which exists on non-root
@@ -1323,12 +1328,17 @@ PAGE_SIZE multiple when read back.
 	Caller could retry them differently, return into userspace
 	as -ENOMEM or silently ignore in cases like disk readahead.
 
-        If memory.max is opened with O_NONBLOCK, then the synchronous
-        reclaim and oom-kill are bypassed. This is useful for admin
-        processes that need to dynamically adjust the job's memory limits
-        without expending their own CPU resources on memory reclamation.
-        The job will trigger the reclaim and/or oom-kill on its next
-        charge request.
+	If memory.max is opened with O_NONBLOCK, then the synchronous
+	reclaim and oom-kill are bypassed. This is useful for admin
+	processes that need to dynamically adjust the job's memory limits
+	without expending their own CPU resources on memory reclamation.
+	The job will trigger the reclaim and/or oom-kill on its next
+	charge request.
+
+	Please note that with O_NONBLOCK, there is a chance that the
+	target memory cgroup may take indefinite amount of time to
+	reduce usage below the limit due to delayed charge request or
+	busy-hitting its memory to slow down reclaim.
 
   memory.reclaim
 	A write-only nested-keyed file which exists for all cgroups.
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


