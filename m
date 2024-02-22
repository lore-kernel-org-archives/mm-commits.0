Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2698F65
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560186; cv=none; b=oRq3Bo2xItFqCxHxMzerioxAYhF1mxrfFMeHdxy8X1I7jVi8rqDNKZBMg6Ga5WEKnbyO/Bz7sDi303P0UeVqjKS1ShaQ8hz/y6iRXw+HugdQ/tMLOuRUHuAX9fX4e8V1rmqDKeGzx37myupLV93N33dN8Q3f8LgZvzlMb59I+84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560186; c=relaxed/simple;
	bh=N/gD9g5oVKWHQZxR+90hoIQZdcQkD0zFrKlsXuXoiIM=;
	h=Date:To:From:Subject:Message-Id; b=OoeJT5IoOPwD4wDJKim/dAGzoHcTgh3r+islX6lq0bO9BSW/gVhD9CjnGaGzXsssso2PwfbnIx/C0v0Q1iaCMWTKvRetz4Ee8khahgqZQphUvL6am7Fgt96tW1WZmC/9j7exeCAR0m8u1tE+ZfFnJ7iOT62iQlUeBdeB5c92yHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MVgeesJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MVgeesJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF2C433F1;
	Thu, 22 Feb 2024 00:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560186;
	bh=N/gD9g5oVKWHQZxR+90hoIQZdcQkD0zFrKlsXuXoiIM=;
	h=Date:To:From:Subject:From;
	b=MVgeesJx3jMQ0azprAtjLV5hQJY8kSzokGVan2h73l1W5UL/2TCxLiv4iXfa9YsTZ
	 gbO2J8ToajzXjh13SRKHEu7F8n1En4jI0JFN8cwZJerc9arFpwazWrNWXYBtOzBj0A
	 v+Otq2Mic1scpaT08tsEgen8O3kSLBtlpooJgMMY=
Date: Wed, 21 Feb 2024 16:03:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@kernel.org,lstoakes@gmail.com,hannes@cmpxchg.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch removed from -mm tree
Message-Id: <20240222000306.9BFF2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: add hugetlb_madv_vs_map
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: run_vmtests.sh: add hugetlb_madv_vs_map
Date: Mon, 5 Feb 2024 11:18:42 -0800

hugetlb_madv_vs_map selftest was not part of the mm test-suite since we
didn't have a fix for the problem it found.

Now that the problem is already fixed (see previous commit), let's enable
this selftest in the default test-suite.

Link: https://lkml.kernel.org/r/20240205191843.4009640-3-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -264,6 +264,7 @@ nr_hugepages_tmp=$(cat /proc/sys/vm/nr_h
 # For this test, we need one and just one huge page
 echo 1 > /proc/sys/vm/nr_hugepages
 CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
 # Restore the previous number of huge pages, since further tests rely on it
 echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 
_

Patches currently in -mm which might be from leitao@debian.org are


