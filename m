Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2146C38B7C0
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898354; cv=none; b=jersyoB2KgeSugBqKe/KPn6Sey5gm9jjPAOaeZnpuJXgcE1GRqkodklLK9dAnWDNI+vB/pXC4P3V88aNNuQp14DHGFLcfvOZuOtZHEOYscRvQkYQH9vPNC7m1xuJE0dYCVdn1/ncWQgija1GSMSiSdSStpWYg7ZZCXZjmu07oJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898354; c=relaxed/simple;
	bh=s4Dx4n34l3lBNFH403JJC6ukgieCaHRiKRxhh8+stA4=;
	h=Date:To:From:Subject:Message-Id; b=AGoA5ev/KfziTLTPbc5shlbgVjScU9Y31RjbOSbng7rMzjoKbhOZcAzPuRxy+sNL9PS3y6sDCbrr8C/pXCYiIQwfeZgRkxj+ApCvVCV7suv9rFGBD3w4CvrEZymBUB3qiaBs6Q3C4iGBOsW/6gXeIWa3MeOFDEFDoN/fALS4sE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=thrLcIur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="thrLcIur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE128C116D0;
	Sat, 31 Jan 2026 22:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898354;
	bh=s4Dx4n34l3lBNFH403JJC6ukgieCaHRiKRxhh8+stA4=;
	h=Date:To:From:Subject:From;
	b=thrLcIurIAYHN2yY9M5aFDRbs8dKCjzBJv5szKJo6ePZpHcQypy0TH3RvK42+g+KU
	 u41Er3lWVi+FNgD4pg5MlZULHeL4Y8YC0RAsW8UEQcGzG/gEimvCt1yZmC8zTJM1kH
	 UxPOhJHk49VS3TBRBm9zo9U0gDL3TrN6wHBVnSC4=
Date: Sat, 31 Jan 2026 14:25:53 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch removed from -mm tree
Message-Id: <20260131222553.EE128C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: remove damon-tests/perf suggestion
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: remove damon-tests/perf suggestion
Date: Sun, 18 Jan 2026 10:02:59 -0800

The DAMON performance tests [1] use PARSEC 3.0 as its major test
workloads.  But the official web site for PARSEC 3.0 has gone, so there is
no easy way to get the benchmark.  Mainly due to the fact, DAMON
performance tests are difficult to run, and effectively broken.  Do not
request running it for now.  Instead, suggest running any benchmarks or
real world workloads that make sense for performance changes.

[1] https://github.com/damonitor/damon-tests/tree/master/perf

Link: https://lkml.kernel.org/r/20260118180305.70023-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -48,8 +48,7 @@ Further doing below and putting the resu
 - Run `damon-tests/corr
   <https://github.com/damonitor/damon-tests/tree/master/corr>`_ for normal
   changes.
-- Run `damon-tests/perf
-  <https://github.com/damonitor/damon-tests/tree/master/perf>`_ for performance
+- Measure impacts on benchmarks or real world workloads for performance
   changes.
 
 Key cycle dates
_

Patches currently in -mm which might be from sj@kernel.org are


