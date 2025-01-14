Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143691C548C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837210; cv=none; b=ruX5T3KnWm9UYSdRyy44eZuiwJG2L4Rz6Bw4nKEWRA9MwBAf8WEfXxb6AITYJdDMP2DgL6uew236UnMH9RobYY9V4sJP96+6qaMlq7Ca5oQyaO25WBMwpqWYbKlI/1J2kOyPQgj9N8X/rpT7enfA8V2u137rndAI225les8Jjr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837210; c=relaxed/simple;
	bh=4STxty8/khxB4OXjPi/8wAtJhGa9Dt/oLT7BopM6fhM=;
	h=Date:To:From:Subject:Message-Id; b=NtQUHaHAy4o+7klDJ2b2/oyjXzgditT6nK0X5pFuVnN0zRhgayvojp80jr4Hf93j8CsiwhruXlL/jDKZANbWkTkLZIzTpzSBe+FsswOnEoyCpFKBiNcK1zc2KMqOZFxrNWXqUyYZLJmJtqj/POU4bGe60/BqDPb3OH/KSMj+S10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a6J6lh28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a6J6lh28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF268C4CEDD;
	Tue, 14 Jan 2025 06:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837210;
	bh=4STxty8/khxB4OXjPi/8wAtJhGa9Dt/oLT7BopM6fhM=;
	h=Date:To:From:Subject:From;
	b=a6J6lh28LZzCk9/EremWJoSOkQCbZb8rQV8ZBsUdsINEJjfIu2resrWVpUvi4Fx7o
	 nJF7CF2X3n+wa0HDdjHwVqS9NMRGloXTHqLbD4ZHnbMDjV90fGl6R7dc1rFi9yx4Vq
	 qJtI4SqA/SE0LDyY3mRtI2hCF+gAAh4VPBl0DoVQ=
Date: Mon, 13 Jan 2025 22:46:49 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-damos-filter-allow-sysfs-file.patch removed from -mm tree
Message-Id: <20250114064649.DF268C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document DAMOS filter allow sysfs file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-damos-filter-allow-sysfs-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document DAMOS filter allow sysfs file
Date: Thu, 9 Jan 2025 09:51:24 -0800

Update DAMON ABI document for added DAMOS filter 'allow' file.

Link: https://lkml.kernel.org/r/20250109175126.57878-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-damos-filter-allow-sysfs-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -355,10 +355,15 @@ Description:	If 'target' is written to t
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/matching
 Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
-Description:	Writing 'Y' or 'N' to this file sets whether to filter out
-		pages that do or do not match to the 'type' and 'memcg_path',
-		respectively.  Filter out means the action of the scheme will
-		not be applied to.
+Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
+		the memory of the 'type', or all except the 'type'.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/allow
+Date:		Jan 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
+		applying the scheme's action to the memory that satisfies the
+		'type' and the 'matching' of the directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_tried
 Date:		Mar 2022
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

