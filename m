Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA32BD531
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642781; cv=none; b=H2+vrkS/XEfvvA3fIQbpHrHBxtmQT87md1gQ6B7G33P5bqvfg10fGCR5jYBmv4lD11UW4Pdm7flH8ykEdB4sFW+H6VkQp+28JjAlHtG4oKyx1R1SDgSDn8NwzmrXpUDJoRz3XiYzMlCLskD7kM7urGRREpURudKlubFX8MvOHqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642781; c=relaxed/simple;
	bh=VxUlLGxrnJZ0wWV24IbeoBb7WKjn8vh30pWbJawWImA=;
	h=Date:To:From:Subject:Message-Id; b=rA9OFrZOZ5Guwrbh8PUbonEl0rxhrGuKVH5pUBIhnsUHqvv2VRzsUoE2OeMGn/4vrBjX2CxFKmQ/gtltUf68Rcm4OcofxlUrtW0qL9qerioMxii4w6LNVrKol6zXaKpOzIz1WbXg8+Z9v531Raz8DrBg7AvVjOzn18rZEudyiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ydQCWO2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ydQCWO2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA05C4CEF1;
	Tue, 19 Aug 2025 22:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755642780;
	bh=VxUlLGxrnJZ0wWV24IbeoBb7WKjn8vh30pWbJawWImA=;
	h=Date:To:From:Subject:From;
	b=ydQCWO2xc03jO2bh8/U50XGeBvp/ljNjrZ7kk2ndROT1vxjSQnoy06w1RU9AWqa4/
	 J5grhmw9qZxGAvaqIvCLFeumtWUD8E81iv22nLv60y6v7oMW7MNNuVmdG4tMGsEGfj
	 Uft5Tyu9xujUCj7LWUnUwrAeMz1OPEgkQGROsVUE=
Date: Tue, 19 Aug 2025 15:32:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-prctl-introduce-tests-for-disabling-thps-completely-fix.patch added to mm-unstable branch
Message-Id: <20250819223300.6BA05C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: prctl: return after executing test in child process
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-prctl-introduce-tests-for-disabling-thps-completely-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-prctl-introduce-tests-for-disabling-thps-completely-fix.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: selftests: prctl: return after executing test in child process
Date: Mon, 18 Aug 2025 11:27:04 +0100

The next step after executing the test is a wait, but there is nothing to
wait for in the child, so just return.

Link: https://lkml.kernel.org/r/2d0ea708-ecba-4021-b6ca-e93f1413d60a@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/prctl_thp_disable.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/prctl_thp_disable.c~selftests-prctl-introduce-tests-for-disabling-thps-completely-fix
+++ a/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -161,8 +161,10 @@ TEST_F(prctl_thp_disable_completely, for
 	pid = fork();
 	ASSERT_GE(pid, 0);
 
-	if (!pid)
+	if (!pid) {
 		prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
+		return;
+	}
 
 	wait(&ret);
 	if (WIFEXITED(ret))
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

docs-transhuge-document-process-level-thp-controls.patch
selftest-mm-extract-sz2ord-function-into-vm_utilh.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely-fix.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch

