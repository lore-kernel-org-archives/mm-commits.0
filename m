Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A114A617
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728771497; cv=none; b=vGaUorPuvbcV9RcUihAAbQuLYgKHMi3qvWm2i94mvVcd7buKptwrsArTkV+l5jSn73z6ZprF5++TJ6n7wtjGRmiQR/oCFTUzI5Pzgvv4CpPbcSdRj+Izh9nQzYsnmJKzRvTpOrT1moq1vvHyW0MO6DstTBmRAirxKfO0IYOudRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728771497; c=relaxed/simple;
	bh=WnYgeENos8SLM7s2i7mchkPcM278Gy/ojWnNPV2tkWk=;
	h=Date:To:From:Subject:Message-Id; b=Tf+2xpt+ZXbu9sKKfyhUj69VFBG30h1ESqCQdR9DmwtPVTQI+tt9mU3I+iNWbYUQK/fpOsknEnLWgYBOmmTEIyKZSWveEJJ+zg1nNtYscztGp+Ev1KGepSE1ff0hJp+lyVhyzlLRbJ8GTfTiYxhhJyI17RhvGBp9rOvFaWtBWZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bcbZHYd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bcbZHYd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4254C4CEC6;
	Sat, 12 Oct 2024 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728771497;
	bh=WnYgeENos8SLM7s2i7mchkPcM278Gy/ojWnNPV2tkWk=;
	h=Date:To:From:Subject:From;
	b=bcbZHYd7Z0JzZ47aO3RE5TakVWw6U9ny0qlVzE/bNHclwn/RlAMNQF1KBK/8WgJng
	 712FJpLDhpkfn1T3H/mROrNXGnL4KrpcC/OVVlshBSHzeBzde+2nWw3dfO+puCORf6
	 fktsfFLFMj6wOBi/O/jFntoNM8Wr5Pvgq5oDjLzM=
Date: Sat, 12 Oct 2024 15:18:17 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-damon-maintainer-profile-update-deprecated-awslabs-github-urls.patch added to mm-hotfixes-unstable branch
Message-Id: <20241012221817.A4254C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/damon/maintainer-profile: update deprecated awslabs GitHub URLs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-damon-maintainer-profile-update-deprecated-awslabs-github-urls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-damon-maintainer-profile-update-deprecated-awslabs-github-urls.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: Docs/damon/maintainer-profile: update deprecated awslabs GitHub URLs
Date: Fri, 11 Oct 2024 10:01:54 -0700

DAMON GitHub repos have moved from awslabs GitHub org to damonitor org[1].
Following the change, URLs on documents are also updated[2].  However,
commit 2e9b3d6e2e59 ("Docs/damon/maintainer-profile: add links in place"),
which was added just after the update, was using the deprecated GitHub
URLs.  Update those to use damonitor GitHub URLs instead.

[1] https://lore.kernel.org/20240813232158.83903-1-sj@kernel.org
[2] https://lore.kernel.org/20240826015741.80707-2-sj@kernel.org

Link: https://lkml.kernel.org/r/20241011170154.70651-3-sj@kernel.org
Fixes: 2e9b3d6e2e59 ("Docs/damon/maintainer-profile: add links in place")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-damon-maintainer-profile-update-deprecated-awslabs-github-urls
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -37,17 +37,17 @@ When making DAMON changes, you should do
 - Build changes related outputs including kernel and documents.
 - Ensure the builds introduce no new errors or warnings.
 - Run and ensure no new failures for DAMON `selftests
-  <https://github.com/awslabs/damon-tests/blob/master/corr/run.sh#L49>`_ and
+  <https://github.com/damonitor/damon-tests/blob/master/corr/run.sh#L49>`_ and
   `kunittests
-  <https://github.com/awslabs/damon-tests/blob/master/corr/tests/kunit.sh>`_.
+  <https://github.com/damonitor/damon-tests/blob/master/corr/tests/kunit.sh>`_.
 
 Further doing below and putting the results will be helpful.
 
 - Run `damon-tests/corr
-  <https://github.com/awslabs/damon-tests/tree/master/corr>`_ for normal
+  <https://github.com/damonitor/damon-tests/tree/master/corr>`_ for normal
   changes.
 - Run `damon-tests/perf
-  <https://github.com/awslabs/damon-tests/tree/master/perf>`_ for performance
+  <https://github.com/damonitor/damon-tests/tree/master/perf>`_ for performance
   changes.
 
 Key cycle dates
_

Patches currently in -mm which might be from sj@kernel.org are

docs-damon-maintainer-profile-add-missing-_-suffixes-for-external-web-links.patch
docs-damon-maintainer-profile-update-deprecated-awslabs-github-urls.patch

