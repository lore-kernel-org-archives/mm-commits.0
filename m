Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E741BF27
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 04:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708920302; cv=none; b=ghCdiKa1NEf3oMUNHZ0CdfBR3/d2ji22qOXu9HGGcM7jIrz8ZpIODMJHR5Q2DS2zPf7ZDRsx9BQMD/aU0bOFastS2skhTbj9xHBlxTZCXp7Xl928Y6aDB1yGKiwa8/oeGWCfvH+3/mGiSBYBIIhKSJGtJoAF92BmP7IXHNr5s98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708920302; c=relaxed/simple;
	bh=C6IWjitJktsQBUkKOuZawzv1XmALoUQYG3zNIRMMhb4=;
	h=Date:To:From:Subject:Message-Id; b=MZnWD/bwFDayyUxqY/Z1+PSJpDAlOAZrumXjHlDTJS79jXn9ve0J/YW6Ncd+SzdxSURSL+qqV2xQluBFumCljw93NuulOQ479IwoVddq13EhzSt4UBzsS4emPD5L4pUfWKcZG9WXhBC/kLvDU1A0fqK07ZTBgwWDgXNmBLxlMPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UA9eOR83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UA9eOR83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0512C433C7;
	Mon, 26 Feb 2024 04:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708920301;
	bh=C6IWjitJktsQBUkKOuZawzv1XmALoUQYG3zNIRMMhb4=;
	h=Date:To:From:Subject:From;
	b=UA9eOR83vvQ2HZTcfwxFe160MeJhpx0ybaFk5aoZgJYa7wWEqTXhz0vV6MvCdpeys
	 k58ZMu4WyB2duP5pnvCBo86gbAjz9u8QuxgjuPjitEuEe4rQFUROBbUn9k9nIH/Ou+
	 DGFu1C8DIbmSBaIDug9qxDmAU9FKQB28drYKEVXA=
Date: Sun, 25 Feb 2024 20:05:00 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,hannes@cmpxchg.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout.patch added to mm-unstable branch
Message-Id: <20240226040501.B0512C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: remove the details for pageout as paddr doesn't use MADV_PAGEOUT
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: Docs/mm/damon/design: remove the details for pageout as paddr doesn't use MADV_PAGEOUT
Date: Sun, 25 Feb 2024 11:47:51 +1300

The doc needs fix.  As only in the case of virtual address, we are calling
madvise() with MADV_PAGEOUT.  But in the case of physical address, we are
calling reclaim_pages() directly.  MADV_PAGEOUT on virtual address is much
more aggresive to reclaim memory compared to reclaim_pages() on paddr
region.  This patch removes the details so that the description can apply
to both cases.  And we don't need to couple with the implementation
details.

Link: https://lkml.kernel.org/r/20240224224751.4673-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout
+++ a/Documentation/mm/damon/design.rst
@@ -315,7 +315,7 @@ that supports each action are as below.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
  - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
+ - ``pageout``: Reclaim the region.
    Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout.patch

