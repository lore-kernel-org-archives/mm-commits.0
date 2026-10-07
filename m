Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F39547058
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334141; cv=none; b=EzdBYU9E0b9XsTidrKq/BfhGRlWItipJgnebyX8Rg2hJ71+HyVhagZndpYxkbREJo4syEsw6IHB5+hDd3YLs5v9uJ5EYR9N/NYvndcaQLuT3jpjLAALlmGh5qmlqgt3BOeloiYoOak0qmvFeqWsJes806NecP623Swt7KfZyD4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334141; c=relaxed/simple;
	bh=IX4XmnqKHawUHflhwPxz6ctwLhz72YqRjfFZbvJNloE=;
	h=Date:To:From:Subject:Message-Id; b=G7rel3QlZMqITJE/slVDf6ASpjNSKTfiMpNbsOvM+liAw3pI5/4Gd1UC91fm93Rrm91OZp7FvRnFyMLXMn6Jvjek3dhmX22vsOWUMT2UY1DSTltbBfKBcRBNAw3NseWXlabVYdvBJkpAcWL6Qb9sb4U/t2a0tDEapwwRMMpnqYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gl4zBlGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gl4zBlGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5961F0089C;
	Wed,  7 Oct 2026 00:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334139;
	bh=BMqXHJu8zW9HT+9eJLghGCRPnUAYlq9+FYpOh2SwJ0s=;
	h=Date:To:From:Subject;
	b=gl4zBlGdFWGOto+I67iFxSMyl6Xj/+H3Rjxx4a23baDNH4yernaH5SwtXfdlpd8Tt
	 Sm1cllz2g+V1Uh2fpbuUk9W2tAM4xPeJhP8m01KCQgV9TbpL/Ixmas8T3skdtLkCvM
	 P8x7DVVUoV8kZtJYd6nJOUrMhHvhFuw6YsnpnBSc=
Date: Tue, 06 Oct 2026 17:48:59 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,hannes@cmpxchg.org,cuitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs.patch removed from -mm tree
Message-Id: <20261007004859.CF5961F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: cgroup: document empty-write behavior of memory limit knobs
has been removed from the -mm tree.  Its filename was
     docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tao Cui <cuitao@kylinos.cn>
Subject: docs: cgroup: document empty-write behavior of memory limit knobs
Date: Wed, 26 Aug 2026 10:17:53 +0800

A maintenance script on a cluster wrote an unset variable into memory.max
of a workload cgroup; the variable expanded to an empty string, the write
succeeded, and the workload in the cgroup was OOM-killed.  Nothing pointed
back at the write, so it took quite some time to trace the OOM kills to
that script.

The memory controller documentation does not say what an empty write does;
the cpuset controller documents its empty-value semantics.  The actual
behavior is that the empty string is accepted as 0.  Reproduced on a k8s
cluster (v1.29, cgroup v2, two-container pod, 384M limit):

  # LIMIT=
  # echo "$LIMIT" > $CG/memory.max
  # echo $?
  0

  m6demo   0/2     OOMKilled   0

  Memory cgroup out of memory: Killed process 339529 (sleep) ... anon-rss:32kB

State it where the interface files are introduced, alongside the existing
notes on units and page rounding.

Link: https://lore.kernel.org/all/aoVUlFdZYLFn_gvJ@tiehlicka/
Link: https://lore.kernel.org/20260826021753.197871-1-cui.tao@linux.dev
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1321,6 +1321,10 @@ All memory amounts are in bytes.  If a v
 PAGE_SIZE is written, the value may be rounded up to the closest
 PAGE_SIZE multiple when read back.
 
+For the limit files described below, an empty or all-whitespace
+write is accepted and sets the limit to 0.  To disable a limit,
+write "max"; to set it to zero explicitly, write "0".
+
   memory.current
 	A read-only single value file which exists on non-root
 	cgroups.
_

Patches currently in -mm which might be from cuitao@kylinos.cn are


