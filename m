Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E733770C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714169869; cv=none; b=gGQuIOzgBvX1XskswRVNgpmQDcHxTaCE2aHFF5PZqmZAYqyjCeSeYM9lR5TuA3ECcuNB4Qstsm2BZLLT0P9XwPOOxJk/H/+KdpqiHE+LcnU+UBc0G6rLejJZTMEsA/k4uH7eRsC3PCqTY99lJm6HadftZXaJN7SFm5rr4OImlXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714169869; c=relaxed/simple;
	bh=G0HJgz3QhE7afcoDa32fb125OFy+5fIhT+LnmXbKpDg=;
	h=Date:To:From:Subject:Message-Id; b=bgBMC4/uvZ5Bt/93LKPM/vJdUD/U7iJmP6kp74cnfCVCvCkEt8qdzLHyvsw2emh406qdlbsSX9JYOhMZCON4Kcu7SNE15sPwNYLez/yw2i2ICdSN1aTKU0Vi7GRzQnbWOa0JyMuj3rB3hjzSuRiJhFqWyFGS8feAXT+NPSjOkTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vwEyzCG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vwEyzCG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07244C113CD;
	Fri, 26 Apr 2024 22:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714169869;
	bh=G0HJgz3QhE7afcoDa32fb125OFy+5fIhT+LnmXbKpDg=;
	h=Date:To:From:Subject:From;
	b=vwEyzCG6H9LiKkorxvID1DzLMPcn3R8NGTRtgD5jAJSB75Sx4PcyDcJzWFtZ6gt84
	 jfRRRmkfjgUx9MfBZP4zp6aAhDQS5LWBCG3Uxhl9a0Y3zFTzep2Z4d81M7UdlmLPCg
	 b2SPls1zDabJ49cmYtNP7CPqYSHwMd8YbeX5Es8g=
Date: Fri, 26 Apr 2024 15:17:48 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-update-for-youg-page-type-damos-filter.patch added to mm-unstable branch
Message-Id: <20240426221749.07244C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: update for 'youg page' type DAMOS filter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-update-for-youg-page-type-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-youg-page-type-damos-filter.patch

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
Subject: Docs/ABI/damon: update for 'youg page' type DAMOS filter
Date: Fri, 26 Apr 2024 12:52:46 -0700

Update DAMON ABI document for the newly added DAMO filter type, 'young
page'.

Link: https://lkml.kernel.org/r/20240426195247.100306-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-youg-page-type-damos-filter
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -314,9 +314,9 @@ Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
 		the memory of the interest.  'anon' for anonymous pages,
-		'memcg' for specific memory cgroup, 'addr' for address range
-		(an open-ended interval), or 'target' for DAMON monitoring
-		target can be written and read.
+		'memcg' for specific memory cgroup, 'young' for young pages,
+		'addr' for address range (an open-ended interval), or 'target'
+		for DAMON monitoring target can be written and read.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/memcg_path
 Date:		Dec 2022
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch

