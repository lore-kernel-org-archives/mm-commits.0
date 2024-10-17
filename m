Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C591C32EB
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150134; cv=none; b=DLcD/gqmrbS/RHO5q/uZACZl1ltEtPLfbEkaKXpR+oMW8PGDVXLLqI6YiusFWvI0mpyedp39s24SuEbrWw1abAjB5y/qhG3u6JhQI0PYl49/thiUTyuw/omnOOf+QbGq/GU1SOP4i/QBFsqcIQH9cGe/gfzW4293/MyTdKN4E3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150134; c=relaxed/simple;
	bh=KILVFrp3by8YC/Y25R8iAwccP8EAWXYjpP+oh2WqKUI=;
	h=Date:To:From:Subject:Message-Id; b=X3PHWhbVZKRE6j9YswJ0SfZ6rBjsNn/orGDGvx1K7zovRUcGMTFXTTQaxpS+5pwhEP9ZXh+q3GVWj9TGClKotKR54wtBSYypku6vkA5P0p6hz3P/ATImsPo4viqx+2ivIbtlT1wayyKavNTVnT1iSd8q2BZDpqWw6xGFxg7qkNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DVied2pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DVied2pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAD0C4CEC3;
	Thu, 17 Oct 2024 07:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150134;
	bh=KILVFrp3by8YC/Y25R8iAwccP8EAWXYjpP+oh2WqKUI=;
	h=Date:To:From:Subject:From;
	b=DVied2pUN+Mnf7p09JvMgqpod2Isbkrg2oEfDrJ/risZduVlJ6yozkjY0OVXiTSaI
	 DkZlnnvKzBy8glbg6gJ0bLAWKDweQzgrcPKJiAP+dkyhx7VUIHwbS0RdbGwJQQjzQU
	 2m29hWHi1cwsppsfhnvsS/q3U75gWBUtoEpwIO5U=
Date: Thu, 17 Oct 2024 00:28:53 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-damon-maintainer-profile-update-deprecated-awslabs-github-urls.patch removed from -mm tree
Message-Id: <20241017072854.2DAD0C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/damon/maintainer-profile: update deprecated awslabs GitHub URLs
has been removed from the -mm tree.  Its filename was
     docs-damon-maintainer-profile-update-deprecated-awslabs-github-urls.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


