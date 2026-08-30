Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A676138D
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788052337; cv=none; b=Q9FQ5tTj8Jxp8CtqfGZ7x6PiTFx/PKxx6U8Do4aeKvUpVLIKKOJFDMxif02CPUKOgeN3cI+lTpRq0Yf6heAp449EBUUMmCpeLhFK/RUf0RVQqqOY+IScQWusyX+xJ4FDOigH2BcAOimMWsK1MprarL2omJcMSi11ivDlLFY6BLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788052337; c=relaxed/simple;
	bh=ATdc3r1PqvZCyAxBlqLJokDWwkGGxrBnNka8pfvofgU=;
	h=Date:To:From:Subject:Message-Id; b=B6HTyZ+E6jnyNWbtMO0Zbs2R+SrL+vbypdZK3KK3em6poSFUh1mpaDtDbPv+GJfg9XZs9Ojf4YHqQdnV5dRfU+l5PG+gAMHTE5sbUEhO/FukhMhpJE7JlFlNAfWSU2S7Y7tOI8jkbvVaTmDYNiCVxJRNoP3FA4TY0ovfHnWG7M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXgnVnTx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXgnVnTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B1A1F000E9;
	Sun, 30 Aug 2026 01:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788052336;
	bh=1f02Xtq5MVRkAncd4MqjGl+DxFzUL3Rv1UvDHU5a+Ms=;
	h=Date:To:From:Subject;
	b=XXgnVnTxNls4Z3XiofQadjxBpy7O0NbtIeIck0ydz2tygMiw+ysIKXBSrlaimZqxa
	 KNjlzWW0kbAaYdE5QUreczWfIyLLYrI/g2FmznqSnC/+83MWed/q5sDboSpf4+6uCf
	 yz56D72sz0Rt64VCJFN8xEDeTvyJb9RnKl4Oibgk=
Date: Sat, 29 Aug 2026 18:12:15 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-page_counter-reject-empty-string-in-page_counter_memparse.patch removed from -mm tree
Message-Id: <20260830011216.42B1A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_counter: reject empty string in page_counter_memparse()
has been removed from the -mm tree.  Its filename was
     mm-page_counter-reject-empty-string-in-page_counter_memparse.patch

This patch was dropped because an alternative patch was or shall be merged

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

