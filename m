Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC92A1D6DB8
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 22:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734646561; cv=none; b=cEaQHKXm3K/u6tYNGHN9/tUERlWrMjLxZPkdPJu0xWVV8XNKg5OGDjlV4a9krEIGy56s/4NIorZ0BZOrZOILKGwDPar7eesFqeXgYd4wsumYJpoHtV4cfh2PmPLXn/kthXIzDaosnUYTs03fw4DztcfGwlGG79PXZgB4oIFs8xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734646561; c=relaxed/simple;
	bh=luLqwaoiLcj8hKJ/bS5c87afRst0mRzuwM/L/gg+6Ps=;
	h=Date:To:From:Subject:Message-Id; b=MGdYJH+iiXXLFQO2xObn3l+6GkDOktvYC5P3xolimU3b3cwB/PGjhVI8tGg/xlkeT+lTUczQSR4NM9E+iQ5Tt9RUZAqyQtRnYSKMjCw/dC3zTFddQa1hSgCuXcpdDOv3T835+4863MZbBZg6eyV4WwHbfg/FsakTvOk4njU6Mw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yQ+GZP28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yQ+GZP28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78096C4CECE;
	Thu, 19 Dec 2024 22:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734646561;
	bh=luLqwaoiLcj8hKJ/bS5c87afRst0mRzuwM/L/gg+6Ps=;
	h=Date:To:From:Subject:From;
	b=yQ+GZP28D/IwmFrw74uE4kqAydE4W4EYLgZewDiYIbhzhUwh7hZdD8xDfqA8EmsUn
	 T/l5aZyc0bZThJeIeLaegZ3LAzwn87Lj1NozrNgazOSr4kKu0g4tBr2E9sAmPx1o1p
	 9JREebcu8hkJZcwpx58UUoRwD6F6Kkx9I04yKDGQ=
Date: Thu, 19 Dec 2024 14:16:00 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + replace-free-hugepage-folios-after-migration-fix-2.patch added to mm-unstable branch
Message-Id: <20241219221601.78096C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: define replace_free_hugepage_folios() on CONFIG_HUGETLB_PAGE=n as static inline
has been added to the -mm mm-unstable branch.  Its filename is
     replace-free-hugepage-folios-after-migration-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/replace-free-hugepage-folios-after-migration-fix-2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/hugetlb: define replace_free_hugepage_folios() on CONFIG_HUGETLB_PAGE=n as static inline
Date: Thu, 19 Dec 2024 10:37:53 -0800

Commit fba5261e0039 ("mm: replace free hugepage folios after migration")
on mm-unstable that also available at
https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge1116@126.com
breaks build when CONFIG_HUGETLB_PAGE=n as below, since
replace_free_hugepage_folios() is defined on the header as non-inline. 
Fix it.

    ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests --build_dir ../kunit.out
    [...]
    ld: io_uring/rsrc.o: in function `replace_free_hugepage_folios':
    rsrc.c:(.text+0x160): multiple definition of `replace_free_hugepage_folios'; kernel/fork.o:fork.c:(.text+0xc30): first defined here
    [...]
    make: *** [Makefile:251: __sub-make] Error 2

Link: https://lkml.kernel.org/r/20241219183753.62922-1-sj@kernel.org
Fixes: fba5261e0039 ("mm: replace free hugepage folios after migration")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~replace-free-hugepage-folios-after-migration-fix-2
+++ a/include/linux/hugetlb.h
@@ -1060,7 +1060,8 @@ static inline int isolate_or_dissolve_hu
 	return -ENOMEM;
 }
 
-int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
+static inline int replace_free_hugepage_folios(unsigned long start_pfn,
+		unsigned long end_pfn)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch

