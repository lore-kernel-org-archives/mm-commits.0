Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D00312B94;
	Sat, 18 Apr 2026 07:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498904; cv=none; b=ApdE1U2S6PehOcdNKVcXIQ3tu3lYkC9+GZLrS01ffwk7h0AOQA2I4FzUdAE3oqOWXeS4EDVhU5bG7ZD2Yz5EouRbLvQXtjxRygnnQDbWFYgeimLTefJYaiT5taCATzNTWHVcEtuCNDgpO3KNU8N/IPt8QzgAke3BlexhwMuQGgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498904; c=relaxed/simple;
	bh=lURGarISh0ggdKyi1RXHzR4triaLmhvlvzD+gY3gDEs=;
	h=Date:To:From:Subject:Message-Id; b=JIPnTqP+aZya+Vta2EmidUyonnVseYQOub+SIkAxx1qKdHznKBXMewJOb2eu9aBzn/v+XMJ+KYT3UkyalNoMeXaOHRrk8Iw68lWqJwxCgooRlkJLeGrK3vkA3hRL0rYqXNIJXehTKiErvUhRFS78QB6ORvV4Vs8Y4VKxU/8l3V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eyJjJ0Rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eyJjJ0Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC26C19424;
	Sat, 18 Apr 2026 07:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498903;
	bh=lURGarISh0ggdKyi1RXHzR4triaLmhvlvzD+gY3gDEs=;
	h=Date:To:From:Subject:From;
	b=eyJjJ0RzCh09VY4TjVs32+QOWzI2ojAkISvAmT8eLqp8sHBpfsXQnhEygNKVQ0cQE
	 r15zug/xQSlNqvYflFjBE7zIQrCQf4llrxSndkGaW5CczJMVv/pLlTFEp4n08hmk1D
	 qZPrdZxNv0PP4EYXkav7s5gcNTvKpL6FSkIcBZH8=
Date: Sat, 18 Apr 2026 00:54:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race.patch removed from -mm tree
Message-Id: <20260418075502.5EC26C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:30:49 -0700

Patch series "Docs/admin-guide/mm/damon: warn commit_inputs vs other
params race".

Writing 'Y' to the commit_inputs parameter of DAMON_RECLAIM and
DAMON_LRU_SORT, and writing other parameters before the commit_inputs
request is completely processed can cause race conditions.  While the
consequence can be bad, the documentation is not clearly describing that. 
Add clear warnings.

The issue was discovered [1,2] by sashiko.


This patch (of 2):

DAMON_RECLAIM handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered in [1] by sashiko.

Link: https://lore.kernel.org/20260329153052.46657-2-sj@kernel.org
Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org [1]
Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [3]
Fixes: 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -71,6 +71,10 @@ of parametrs except ``enabled`` again.
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
 min_age
 -------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-time-quota-setting-zero-esz.patch
mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

