Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B466A8172D
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 05:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785421; cv=none; b=PD1irR5I9UWsNadhkBYVJnfLNPII3Y6ykIJ7DhcWRjUfyU4MXMlAKDtBjh6hcz/O8n7BtyRLVdF2d+pdqxV1Rc5ps1A1f/CTmiyqyjqcHx2mLQtf0NrTEeDjsjcgWA9AkN78gd/QuMQcwkH/a3ZHpSSy+ABHii+35qPl0W84xcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785421; c=relaxed/simple;
	bh=bm1TMj20wZEvWQ6fYUqvxm47Hx+muA45O9TErpjqicI=;
	h=Date:To:From:Subject:Message-Id; b=DzGThfVPzR02hMNzPkRnu6wQgp+EUDgIS/a8bf/NIUGbU+kLbyClqlgZ7EjodX8aay+F100N/xmU0v/jFVRmV3xQu1K9lWzb1f+3iVJa+N++/j5LzVrlX48ahAwKhsw3IUXkv8rMbmS54bFuaVlTv0T2oAT7USnSMvoRCscTIF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VfAFOKB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VfAFOKB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EE0C4AF0E;
	Fri, 16 Aug 2024 05:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785421;
	bh=bm1TMj20wZEvWQ6fYUqvxm47Hx+muA45O9TErpjqicI=;
	h=Date:To:From:Subject:From;
	b=VfAFOKB+MJDLNYiD+JLPsjAD84Agsa/4AocE7aVNZTKq1YTYEBJNPmij0cZi4F3CD
	 iJob7iSBzcXhd5462TZyhJ8lgUVaSKVVNikgvVv52oEHQgZ45G3BN6K3++yVWaQ8hn
	 QalzbFtDW5d06+ZbiDYx3Aoeq+HGlAttsBNCAf3E=
Date: Thu, 15 Aug 2024 22:17:00 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-compaction_test-fix-off-by-one-in-check_compaction.patch removed from -mm tree
Message-Id: <20240816051701.89EE0C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: compaction_test: fix off by one in check_compaction()
has been removed from the -mm tree.  Its filename was
     selftests-mm-compaction_test-fix-off-by-one-in-check_compaction.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: selftests/mm: compaction_test: fix off by one in check_compaction()
Date: Fri, 9 Aug 2024 15:32:30 +0300

The "initial_nr_hugepages" variable is unsigned long so it takes up to 20
characters to print, plus 1 more character for the NUL terminator. 
Unfortunately, this buffer is not quite large enough for the terminator to
fit.  Also use snprintf() for a belt and suspenders approach.

Link: https://lkml.kernel.org/r/87470c06-b45a-4e83-92ff-aac2e7b9c6ba@stanley.mountain
Fixes: fb9293b6b015 ("selftests/mm: compaction_test: fix bogus test success and reduce probability of OOM-killer invocation")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-compaction_test-fix-off-by-one-in-check_compaction
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -89,9 +89,10 @@ int check_compaction(unsigned long mem_f
 	int fd, ret = -1;
 	int compaction_index = 0;
 	char nr_hugepages[20] = {0};
-	char init_nr_hugepages[20] = {0};
+	char init_nr_hugepages[24] = {0};
 
-	sprintf(init_nr_hugepages, "%lu", initial_nr_hugepages);
+	snprintf(init_nr_hugepages, sizeof(init_nr_hugepages),
+		 "%lu", initial_nr_hugepages);
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


