Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E49615E97
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642722; cv=none; b=YzFZNCCNoFeX6PZxd2xseV1inhYPb8LNm74IzMq+mPYleo8U+qUJujLH9nn72dT+33lcDjOYR5W9Cw1NbmHkWcX4iLH/WdyzS6ou0eeatOYNdKqFqNx5Q2Uf3caJ2axv3g0UbEEcSeyzILglXWpCxiAdxi28JV1DpKuN9qHb1CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642722; c=relaxed/simple;
	bh=CRbW/JV3uM2TChRVSLYRYsCenTBTzEHtc9kUFQCcpGs=;
	h=Date:To:From:Subject:Message-Id; b=Yv0MlLx8mxKg3rMv9jS1VZZrjWdRJDef1bm85EahLExw1xCBzzAI2W+C6olj8D8yxgSoA9FW/c/q6Yi7j+l04UO9tBfEJuGPmg61GyR/KGrWsOUgF+MMTNcZ7R+FPo/qj7yWVt0cA1QVutGJZ4SV1gmY3wjKAF5eG9e6KMk7NMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wCC3mCiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wCC3mCiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0F9C4CEF1;
	Tue, 19 Aug 2025 22:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755642721;
	bh=CRbW/JV3uM2TChRVSLYRYsCenTBTzEHtc9kUFQCcpGs=;
	h=Date:To:From:Subject:From;
	b=wCC3mCiA54mdifioN0jdlHDvn1ZkMqb7F/lRQH39Xj6c1WG/oPoOqAQpC/MzwIHME
	 bLiaDvQ7nbSlWD7xQFxmzwFA3dVaGhyREt4CAKPYI3zUZsag1FFSsFxsKWYSrank9V
	 KWdLnqrmieQ2cHVaS76D6DqfzWMBdtHtnkfurJD4=
Date: Tue, 19 Aug 2025 15:32:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch added to mm-unstable branch
Message-Id: <20250819223201.AC0F9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: prctl: return after executing test in child process
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch

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
Date: Mon, 18 Aug 2025 11:37:10 +0100

The next step after executing the test is a wait, but there is nothing to
wait for in the child, so just return.

Link: https://lkml.kernel.org/r/3dca2de4-9a6a-4efe-a86c-83f9509831fc@gmail.com
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

--- a/tools/testing/selftests/mm/prctl_thp_disable.c~selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix
+++ a/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -271,9 +271,11 @@ TEST_F(prctl_thp_disable_except_madvise,
 	pid = fork();
 	ASSERT_GE(pid, 0);
 
-	if (!pid)
+	if (!pid) {
 		prctl_thp_disable_except_madvise_test(_metadata, self->pmdsize,
 						      variant->thp_policy);
+		return;
+	}
 
 	wait(&ret);
 	if (WIFEXITED(ret))
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

docs-transhuge-document-process-level-thp-controls.patch
selftest-mm-extract-sz2ord-function-into-vm_utilh.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch

