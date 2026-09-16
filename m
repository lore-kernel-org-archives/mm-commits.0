Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BAE38DC7C
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 01:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789522041; cv=none; b=uGDjiP+kGQ3XjHlqtXUAUjxmTdGY0Z6PB7qhT1RObu0EX8tgN23VvRL7IQRo1+JjojXdPD54EgT3RP8EWZcqbu1lESBt2zJXP2h1t06T6naL3gu7jzULg7HptF0q524oi0xY960QqZls+xa/Z/dP/umSmUwBwEroINFiRBmjE4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789522041; c=relaxed/simple;
	bh=SS/WIrfRzrevc45tRHpEPy2l794Cs8zfmcGNLuA/0OA=;
	h=Date:To:From:Subject:Message-Id; b=gvMGzpxSNt5Sw4TcxE73/1YPzEeSdC/VdlC6EDw9eqbnFqwgVLCkd2g7kZSNcx4U7upIurpBZeYllfDoz3OA7pyG5VUqKP+C2KiQklPVUEEcFDpn+994n2bViqTx59Q7/MsK9r9ngl7DayOG7litnUMHJckX7P/0qWqq+N2ZMzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQcGZXN/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQcGZXN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E96E1F000FF;
	Wed, 16 Sep 2026 01:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789522039;
	bh=ved0vIoeTkI2sYAx8WN25NKnXzYETPfThHEI51FeeR0=;
	h=Date:To:From:Subject;
	b=nQcGZXN/scYpOcttxDE9xZV2NGNodP99MRmqfvNZx0QIJHD9vkXZOVcBsmLlxYzBC
	 6XAlPkkKh4VZZpOuQztIRVnzLuOBpQPf/etZspzzaCNyKk48uM2Bj1NYgNQz5/ObPM
	 PT4370eLiIm+L4FBtRrEdVyM6Zqd0b36hG+dRjcs=
Date: Tue, 15 Sep 2026 18:27:19 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,zhenghui.hao@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-misspelled-parameter-names-in-comment.patch added to mm-new branch
Message-Id: <20260916012719.9E96E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix misspelled parameter names in comment
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-misspelled-parameter-names-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-misspelled-parameter-names-in-comment.patch

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
From: Zhenghui Hao <zhenghui.hao@qq.com>
Subject: mm/hugetlb: fix misspelled parameter names in comment
Date: Tue, 15 Sep 2026 16:20:29 +0800

The comment above hugepages_setup() refers to "hugepagsz" and
"default_hugepagsz", but the parameters parsed by this code are
"hugepagesz" and "default_hugepagesz".  Fix the spelling and also drop the
redundant spaces so the comment reads normally.

No functional change.

Link: https://lore.kernel.org/tencent_034C6FC23D4817C40657E5F17F64E260A009@qq.com
Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-misspelled-parameter-names-in-comment
+++ a/mm/hugetlb.c
@@ -4330,9 +4330,9 @@ static __init void hugetlb_parse_params(
 
 /*
  * hugepages command line processing
- * hugepages normally follows a valid hugepagsz or default_hugepagsz
- * specification.  If not, ignore the hugepages value.  hugepages can also
- * be the first huge page command line  option in which case it implicitly
+ * hugepages normally follows a valid hugepagesz or default_hugepagesz
+ * specification. If not, ignore the hugepages value. hugepages can also
+ * be the first huge page command line option in which case it implicitly
  * specifies the number of huge pages for the default size.
  */
 static int __init hugepages_setup(char *s)
_

Patches currently in -mm which might be from zhenghui.hao@qq.com are

mm-hugetlb-fix-misspelled-parameter-names-in-comment.patch

