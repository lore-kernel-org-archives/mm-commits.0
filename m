Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA9F224C9
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714169864; cv=none; b=lvfb74ygPmLd6IvtNomP0R1GIoMLq57e09oLzasBN/HvRXHi35yO8saM83Bqs46mMEpFMvtNXEeBoCk++o3jYqYMCDCV8xnns1WUx4ym7VFwoE5YrmczekXx6NMBh8qoLtTEYEpYdHmI/8JOT7lPMqaYSF4dodj0zY0BCZ+yA48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714169864; c=relaxed/simple;
	bh=p/YUokrFBUWozwrZ8fjGOmK6jmDSDLXSbPQb1s11sTs=;
	h=Date:To:From:Subject:Message-Id; b=NOAo4nmePm9OhvavM1bAFg7w+JKzouZrnyI+z8PDVJat/mUQ+rAdI2IO5cMhaDa2ifIVbmV8lOV07UebZ8nLSbuVxueXIDGUD3WazEIm3I2vSXt7c+MwfWlEAHej1ydmp8ngI6T+mV03nG35PXj3B56dIA0D0dcvrsF/KGW9CQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m+P7mTII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m+P7mTII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C427EC113CD;
	Fri, 26 Apr 2024 22:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714169863;
	bh=p/YUokrFBUWozwrZ8fjGOmK6jmDSDLXSbPQb1s11sTs=;
	h=Date:To:From:Subject:From;
	b=m+P7mTIIjoPr8ZeczAqGuzgmXzEgHmoq506l85eIRdP34seX8vHtc76Lpu/oquzHD
	 ooW6A8qKRzdPeey2zxLYBiGHrYXOqZrtA25i6ErcFeH/JqOUUVAHGugAJvoZiSd7ZK
	 WMRxz126o/h7rfqT7NKLNp0AVzycND662g4xczuQ=
Date: Fri, 26 Apr 2024 15:17:43 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-implement-damos-filter-type-young.patch added to mm-unstable branch
Message-Id: <20240426221743.C427EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: implement DAMOS filter type YOUNG
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-implement-damos-filter-type-young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-implement-damos-filter-type-young.patch

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
Subject: mm/damon/paddr: implement DAMOS filter type YOUNG
Date: Fri, 26 Apr 2024 12:52:43 -0700

DAMOS filter of type YOUNG is defined, but not yet implemented by any
DAMON operations set.  Add the implementation on 'paddr', the DAMON
operations set for the physical address space.

Link: https://lkml.kernel.org/r/20240426195247.100306-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-implement-damos-filter-type-young
+++ a/mm/damon/paddr.c
@@ -214,6 +214,11 @@ static bool __damos_pa_filter_out(struct
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMOS_FILTER_TYPE_YOUNG:
+		matched = damon_folio_young(folio);
+		if (matched)
+			damon_folio_mkold(folio);
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch

