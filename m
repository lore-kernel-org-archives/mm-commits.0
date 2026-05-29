Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37FA36DA1A
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027605; cv=none; b=fStm7fsnBBwlLnDsL0gfC7a8IJ+trs/kMSL1AjhluterH00aF+YPErQCzVfHzbzvFnrXYZgEcVudb61XtgXH0N9dPwZJ7z9LO1EuAQZC0NsLb2HCPT6B7ZFPByQ/BkbMw2wnZ5XMfTCp6WyzWSM5I9Hj6Bobg+WTqE+tHQbnZhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027605; c=relaxed/simple;
	bh=i8f2AXdN5JWGrWUNmPrn1zyrSburTzcxkOYfk83f93s=;
	h=Date:To:From:Subject:Message-Id; b=ihv02jv+eZiqw+7n7b5TPm62mM1lWDM4fRkbYFSq5RyjP7GCvLeVwpSonQbkdJVrerIy7kG1NJdZPXDH9MbLFVW/vb0YhN7j5NG5dKIK73keUqNoa26H/70ui8RcSl0z9j+ATFr8LiT+yo3l9KhaDgBXPEreZ7ve9uk0gn7UO3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BZNWj5V6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BZNWj5V6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A831A1F00898;
	Fri, 29 May 2026 04:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027604;
	bh=QXbyuZR07wDDQuX8RIIQtU/cfLhwK/HRg8mdYZ6yDIg=;
	h=Date:To:From:Subject;
	b=BZNWj5V6+AnWAZG7PQupDYVbSA8l4ENDNopxBQsAEfXkcoSodRCISQhu2z6Sphdwy
	 N9dupU2BL0YOeM/HXkfHCJk2328Et1nOzf370k0Ks4j7vuOoAwOCSSvBaA593uQz5d
	 ePlTHW2kO0LSXfgfwEd1/g8+/goiQJnwE75LUBJg=
Date: Thu, 28 May 2026 21:06:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jason@zx2c4.com,jannh@google.com,david@kernel.org,broonie@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-run-the-map_droppable-selftest.patch removed from -mm tree
Message-Id: <20260529040644.A831A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run the MAP_DROPPABLE selftest
has been removed from the -mm tree.  Its filename was
     selftests-mm-run-the-map_droppable-selftest.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: selftests/mm: run the MAP_DROPPABLE selftest
Date: Wed, 15 Apr 2026 20:39:39 -0700

The test was not being run by the selftest framework so it was never
noticed that it would fail with an assertion failure on configs without
support for MAP_DROPPABLE.  Update the test so that it is skipped instead
when MAP_DROPPABLE is not supported, and add it to the mmap category so
that the test is run by the framework.

Link: https://lore.kernel.org/20260416033939.49981-4-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/droppable.c    |    9 ++++++++-
 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/droppable.c~selftests-mm-run-the-map_droppable-selftest
+++ a/tools/testing/selftests/mm/droppable.c
@@ -26,7 +26,14 @@ int main(int argc, char *argv[])
 	ksft_set_plan(1);
 
 	alloc = mmap(0, alloc_size, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
-	assert(alloc != MAP_FAILED);
+	if (alloc == MAP_FAILED) {
+		if ((errno == EOPNOTSUPP) || (errno == EINVAL)) {
+			ksft_test_result_skip("MAP_DROPPABLE not supported\n");
+			exit(KSFT_SKIP);
+		}
+		ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		exit(KSFT_FAIL);
+	}
 	memset(alloc, 'A', alloc_size);
 	for (size_t i = 0; i < alloc_size; i += page_size)
 		assert(*(uint8_t *)(alloc + i));
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run-the-map_droppable-selftest
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -382,6 +382,7 @@ else
 fi
 
 CATEGORY="mmap" run_test ./map_populate
+CATEGORY="mmap" run_test ./droppable
 
 CATEGORY="mlock" run_test ./mlock-random-test
 
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are


