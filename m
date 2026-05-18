Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2063424501D;
	Mon, 18 May 2026 21:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138198; cv=none; b=YMeSgrGmdIxRiMY6/kDF+q8VrT8FA1zn4NiZ/UV/3mms9At2umTu1eVIKjVt5ROgU2StPDFvuLF94wK2lre/CHd4bsog8bpxourPVR+hfoUSmQM1WjMCptt/n3qM1szQpdqxOjH2a0kaGwQvtr+GSQqrFn7+7fLoylmyuedTrw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138198; c=relaxed/simple;
	bh=PjuubbTaQzw08p3fg1uTW+rQArJ6gXPx1T6N99trMAI=;
	h=Date:To:From:Subject:Message-Id; b=H285FoUjzqFS05I/mKB/kM6fCu5/H5aU3eiAe1PnEgkkb1dZGg5PQthAfAAX/iOhPWVh0NkSNCbZrVIWI0034R2DCD7blhdnbU31k/IZiOFpNca/BhSIwEbG7X/kilssEmQGiKySqJQMTT1BH4GHLBgKyYOyiPimT+OjiZ3Ej+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p+THQJqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p+THQJqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9822FC2BCB7;
	Mon, 18 May 2026 21:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138197;
	bh=PjuubbTaQzw08p3fg1uTW+rQArJ6gXPx1T6N99trMAI=;
	h=Date:To:From:Subject:From;
	b=p+THQJqen7Hd+Am0C77qyAMza4aUjmTUhwGKIp7SR/64NJXFQmajjF/Dta1nMfzIj
	 v5XBLBK5T7ON9X8ZH8mUd7YGKB6RzRPWs/9U+rNfQn0b9zDBx3C83AHgWAkY0ISwLD
	 jL/6YXnq2mx1i2w9NqELS/ko7LdunmmPlxp5hXIc=
Date: Mon, 18 May 2026 14:03:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-slabinfo-fix-trace-disable-logic-inversion.patch added to mm-new branch
Message-Id: <20260518210317.9822FC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/slabinfo: fix trace disable logic inversion
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-slabinfo-fix-trace-disable-logic-inversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-slabinfo-fix-trace-disable-logic-inversion.patch

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
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: tools/mm/slabinfo: fix trace disable logic inversion
Date: Mon, 18 May 2026 14:21:57 +0800

Patch series "Cleanup and fix tools/mm/slabinfo utility", v2.

This series fixes one bug and cleans up two code quality issues in
tools/mm/slabinfo:

1. Fix trace disable logic inversion: when the user intends to disable
   tracing (!tracing) and it is currently enabled (s->trace),
   set_obj() was called with 1 instead of 0, which is opposite to
   the intended behavior. All other options (sanity_checks, red_zone,
   poison, store_user) in the same function use 0 for the disable
   case.

2. Remove dead assignment in get_obj_and_str(): `x = NULL` sets the
   local parameter variable instead of `*x`, which is a no-op since
   `*x` was already set to NULL on the line above.

3. Remove redundant slab->partial assignment in read_slab_dir():
   slab->partial is assigned by get_obj("partial") and then
   immediately overwritten by get_obj_and_str("partial", &t).


This patch (of 3):

The disable trace path in slab_debug() had a logic error where it would
set trace=1 instead of trace=0.  This made trace functionality permanently
enabled once turned on for any slab cache.

Link: https://lore.kernel.org/20260518062159.80664-1-wangxuewen@kylinos.cn
Link: https://lore.kernel.org/20260518062159.80664-2-wangxuewen@kylinos.cn
Fixes: a87615b8f9e2 ("SLUB: slabinfo upgrade")
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-fix-trace-disable-logic-inversion
+++ a/tools/mm/slabinfo.c
@@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *
 			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
 	}
 	if (!tracing && s->trace)
-		set_obj(s, "trace", 1);
+		set_obj(s, "trace", 0);
 }
 
 static void totals(void)
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch
tools-mm-slabinfo-fix-trace-disable-logic-inversion.patch
tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch
tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch

