Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0643A2BE034
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757802062; cv=none; b=W6I06961ntrxRl9L/9oL7H4+ozzS3fhfP44ShAswGPzys8JcbXjX4+C2bQ8C9ysx+qKTRb1NHa9aTqkW5G1CaOLwC6GcMoMaqkJXXOCnvsUk/Z/8ECkOnogjBgo1G4HZQBVpyC3OblUSk5YV/xKg7IcQcUU+/8mXxo+UxKmwvqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757802062; c=relaxed/simple;
	bh=mo8p7RLUYUasLJ0MLgD8HyMafGO3PYTC8UrxVEQMZKQ=;
	h=Date:To:From:Subject:Message-Id; b=ufogkWn+tiUGLZMNp1YuBJk2uFT1UIq92cfmlGM5COSonWv4pR7DzQOn2i8H7vQ1NJxOA6FTdlP6zYkZWg/L9G5rPMrv79ZUAPKtEZ66H7WOQpZEXgF6pP0Lzws0bN9s7dcXk1rq7ZJq2PRTuzPHZLmLyHx6eNqkrPodouuyEik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCm5rTFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCm5rTFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F32C4CEEB;
	Sat, 13 Sep 2025 22:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757802061;
	bh=mo8p7RLUYUasLJ0MLgD8HyMafGO3PYTC8UrxVEQMZKQ=;
	h=Date:To:From:Subject:From;
	b=XCm5rTFVFOUV8E97wUOfEnixpX49GDi/ZvyVl9wOYjtw8fB/oFr/mE6O1YfyxYBNb
	 9Q4Sm6AMPUeRNP/1yXWZDpWP2gmBrjfXM1G1Igwe/y8QSl21iza+wdHrDufUc+h5Se
	 HlH768/4AM1u6jONAEFIbrSHAhk9XtyQ1IdvjCrE=
Date: Sat, 13 Sep 2025 15:21:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch removed from -mm tree
Message-Id: <20250913222101.C3F32C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: prctl: return after executing test in child process
has been removed from the -mm tree.  Its filename was
     selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch

This patch was dropped because it was folded into selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch

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
@@ -274,9 +274,11 @@ TEST_F(prctl_thp_disable_except_madvise,
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
mm-huge_memory-remove-enforce_sysfs-from-__thp_vma_allowable_orders.patch

