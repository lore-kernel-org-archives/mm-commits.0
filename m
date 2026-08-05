Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11CB485CD2
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948554; cv=none; b=CcaMJhntt4YKjhqmqEm4tm9fUp+dhvIgDx+2cOcdFvz07+VEIVM/vB2/Cw6cQW4Mb++xTyn1AS7GsZM30F4eg9WIDAvg9Cq8ne5VfbWxqnNWZHqlSo9YgVW8Wxhlr6Qwz8RtLvrOBqPkROn508f0oekCMpUKC1fmOaKlUg12hys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948554; c=relaxed/simple;
	bh=mJjWMd2SGE8XVU+xxPBfbANxyrHrHLF6+bq5eZuKqrc=;
	h=Date:To:From:Subject:Message-Id; b=nq5KfvqvMHXmprQBRqfuuKW26PhbDtcpiozGtOhNaxUFCW8gLcN9zFjgWSg2VbtFkyzatjuo1to70HCqck02hvXY6gtJluIiuvOOqX9dhfR/rt67kAiKv/Ic/jUe/ZcvKpuTc21Dht5T+/EpDMOEZ6AsuzNBb49BO5o9XS6G6u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xd+u4bRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xd+u4bRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655551F000E9;
	Wed,  5 Aug 2026 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785948552;
	bh=r6C/Z4cCgIkWjG8lX3EYrH9Hp6kF8Ho8P5DF53yb4fQ=;
	h=Date:To:From:Subject;
	b=Xd+u4bRwKz7/5zSsh1Ux/QwxahR/fdzZvaroGZL79tFYV4JhUl+0F2SLgczqgSrE/
	 95kylHKB0ztuu9S88gsAGjjtBqKR/5g8ywUFG5NSlswd2ygZYBb8UrKBMF96Z9QaSO
	 NTNxoM+6uOmXbCH6V7kkUmT4BXKR6i0wZr7Jrg2A=
Date: Wed, 05 Aug 2026 09:49:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,akpm@linux-foundation.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder.patch added to mm-new branch
Message-Id: <20260805164912.655551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: debug_page_alloc: fix type mismatch for debug_guardpage_minorder
has been added to the -mm mm-new branch.  Its filename is
     mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm: debug_page_alloc: fix type mismatch for debug_guardpage_minorder
Date: Wed, 5 Aug 2026 17:31:07 +0800

The debug_guardpage_minorder local variable is declared as unsigned int,
but debug_guardpage_minorder_setup() uses unsigned long and kstrtoul() to
parse the value.

Use kstrtouint() with unsigned int local variable to match the actual type
of _debug_guardpage_minorder.  Also fix the format specifier from %lu to
%u accordingly.

Link: https://lore.kernel.org/20260805093108.2352900-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/debug_page_alloc.c~mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder
+++ a/mm/debug_page_alloc.c
@@ -20,14 +20,14 @@ early_param("debug_pagealloc", early_deb
 
 static int __init debug_guardpage_minorder_setup(char *buf)
 {
-	unsigned long res;
+	unsigned int res;
 
-	if (kstrtoul(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
+	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
 		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
 		return 0;
 	}
 	_debug_guardpage_minorder = res;
-	pr_info("Setting debug_guardpage_minorder to %lu\n", res);
+	pr_info("Setting debug_guardpage_minorder to %u\n", res);
 	return 0;
 }
 early_param("debug_guardpage_minorder", debug_guardpage_minorder_setup);
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder.patch

