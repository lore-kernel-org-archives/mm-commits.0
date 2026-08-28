Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163C7360ECF
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 02:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787885256; cv=none; b=P2MwPqj+hlM+hupExTsqyhsAR/NFC+2EKMeFU0PhphUfGxyNG8nMtXeKmTnYt3yrJN7oaxLpXtqjWao3rKr880zCNq+uGQ7d8E+uvdtqjODEsVLAL8nF0l+mYzrsJplmVqp8R3LjdNKNJeTGYarAkG0vh9Z3N86krMCzNKW6UD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787885256; c=relaxed/simple;
	bh=tOgLu3HgxPimWsBIgI4CfEJJnJOyh1uAQUc5961sb94=;
	h=Date:To:From:Subject:Message-Id; b=DMD9S+mSGJe7mBXMA3wBN4efFSL5YFGWKF7TzIW7WHP2ti2ecBey+vohlwOTvQvEh/pkd5Dwb8cXKxHVW/NHyyo7djIXzE8qwQbpiyC3IirA1crO4PQvMs6xS+IqR2gqcsJoUK5MvFVRGTQIpkSrInsYpIdg9wxLyZse590y1lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=psPeO4Sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="psPeO4Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889931F000E9;
	Fri, 28 Aug 2026 02:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787885252;
	bh=3RVaQIGvX3O4ycwpYQfkrmWa9mmAtepb3zf/WCsyD8w=;
	h=Date:To:From:Subject;
	b=psPeO4Sz8k50d4YTVnqOFknlvOKXplzqEOJ0CTffXun7Hs1dlp18JKOKCSjCRYnpd
	 EgxuC+Kg3WNzYYRzX3H3fJd/CWKjxjSYOfmbREulDq633+F+0gAeSSaQ2VmDMoNUUC
	 Rs1Y+dDmWBFc/WG0FT9pM5/BJD5h8q2By9AocMNI=
Date: Thu, 27 Aug 2026 19:47:32 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,hannes@cmpxchg.org,cuitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs.patch added to mm-new branch
Message-Id: <20260828024732.889931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: cgroup: document empty-write behavior of memory limit knobs
has been added to the -mm mm-new branch.  Its filename is
     docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1315,6 +1315,10 @@ All memory amounts are in bytes.  If a v
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

docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs.patch

