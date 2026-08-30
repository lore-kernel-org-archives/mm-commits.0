Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7327603A
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 00:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788050564; cv=none; b=SZ2jj3TVw2shMz09EwrG6PNe0K9n7JtVlFyK6A/gRCl3OQKVbHn31yPDLPZ+FGrPWMQDQZ4fhyiAGX9Ur2Oo0iqwkuxqbR8d6n314ZIkzilA/JQVRe+x47cG69ZqWFKAJQ9qop/deDdMfSgCtKydj6EA6ZM6XgL9Qt1ixSvcphc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788050564; c=relaxed/simple;
	bh=qCEo+4jziabFYxTzFBjv6TDIGK4FFFxcFPLJVrTP0jw=;
	h=Date:To:From:Subject:Message-Id; b=KFXhyH/wiLEPJ3WmAMuYlacb7+d/2VcX06ZEHa9bRwcNnIseGoNvpXtAoY40p6EQO0PNsFkTl/uUqLU0Mkmog6Sm7B9Zf29lpUIxG8j5Jq+zX/5zuACQq7syRD+GjK/mMFnSLa9deRnxzo6ImzXSPtMtfdBsJVCGPqUaisKy5Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2WDIeTKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2WDIeTKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35D61F000E9;
	Sun, 30 Aug 2026 00:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788050563;
	bh=m7cPmuqvCQ1EbosG5ZOAM9EMHTfBZ1XqMnLtWjYgTXM=;
	h=Date:To:From:Subject;
	b=2WDIeTKF7u1j4+YPsT3JnGzcvD1sTlU3IEG/+KRaVnriSpgbP63Xuo6fevLfcIYTu
	 QDAgYk0JSUyvpRjTJ+NH04AtICZ0DwYV0tqBxOaTVJncN2xsR+zPVlgDoLnOjXIzyJ
	 wtK9cBrqdhJEzbsMR/eSOec9kFX0hgtrKncl/7vM=
Date: Sat, 29 Aug 2026 17:42:42 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counter-reject-empty-string-in-page_counter_memparse.patch added to mm-new branch
Message-Id: <20260830004242.F35D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_counter: reject empty string in page_counter_memparse()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_counter-reject-empty-string-in-page_counter_memparse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_counter-reject-empty-string-in-page_counter_memparse.patch

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
Subject: mm: page_counter: reject empty string in page_counter_memparse()
Date: Mon, 17 Aug 2026 12:26:52 +0800

memparse() consumes no characters on an empty input and leaves the end
pointer at the terminating NUL.  The only validation in
page_counter_memparse() checks for trailing characters, so an empty input
slips through and the limit becomes 0.

All limit write callbacks of the memory controller strstrip() the input
before calling this helper, so a script that writes an unset variable hits
this path:

  LIMIT=
  echo "$LIMIT" > $CG/memory.max
  echo $?
  0
  cat $CG/memory.max
  0

Nothing reports the mistake: the limit is now 0 and the OOM killer goes
after every task in the cgroup.  The same happens for memory.min,
memory.low, memory.high, memory.swap.high, memory.swap.max and
memory.zswap.max, where 0 silently removes the protection or disables swap
and zswap.

Reject the input when no characters were consumed, which is the one case
the trailing-character check cannot catch.

Link: https://lore.kernel.org/20260817042652.74136-1-cui.tao@linux.dev
Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_counter.c~mm-page_counter-reject-empty-string-in-page_counter_memparse
+++ a/mm/page_counter.c
@@ -281,7 +281,7 @@ int page_counter_memparse(const char *bu
 	}
 
 	bytes = memparse(buf, &end);
-	if (*end != '\0')
+	if (*end != '\0' || end == buf)
 		return -EINVAL;
 
 	*nr_pages = min(bytes / PAGE_SIZE, (u64)PAGE_COUNTER_MAX);
_

Patches currently in -mm which might be from cuitao@kylinos.cn are

docs-cgroup-document-empty-write-behavior-of-memory-limit-knobs.patch
mm-page_counter-reject-empty-string-in-page_counter_memparse.patch

