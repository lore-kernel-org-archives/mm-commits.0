Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE2813CA8C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292054; cv=none; b=VaTpX6NQC9OK1bMnSNWv5tlsxCu/AU+zdLOosoYxiZcQ+nPmP+Oq5rYj/rhy47/qxnGMFpCrzYvra6/hk/ybxNCRsuh7hTTgyckxxxbpUjH1JrPqnKTvDq/u0u1csOk8l0DBFqonnZIR9VWYS7wB25G982YZ3OUQyt71gmtvH0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292054; c=relaxed/simple;
	bh=Er/NUJfh68wObhMu2lvNSg3rOrsI30SlV9iMWTeqUJk=;
	h=Date:To:From:Subject:Message-Id; b=shI3virVRmdOy2E0Oy/JdJt0tl4/cFjcxBCq9jSvEdBC0XwejWX4xIVkQPlq1FonSeDjrs9p99UA6aqhQVrppAoMgXGyEo9JWsLC2DcgQ8Vfx090VTjo+Px7vFEOTxYwnFYpSIY0jqpNOvwKmKMUl1ch3gGCjhnseX/upYfHBcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SqrbeclU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SqrbeclU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A19C2BD10;
	Sat,  6 Jul 2024 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292053;
	bh=Er/NUJfh68wObhMu2lvNSg3rOrsI30SlV9iMWTeqUJk=;
	h=Date:To:From:Subject:From;
	b=SqrbeclUdyqBRKr8UhZYz5huVq9xAC3QlFIKHuujwzi97D0Hz0XPhITa7+EU+W77S
	 MM27FfD5z9/hvWAYqEyI3BX2fHExgz0/upOgSTW7nKfBW1ndXTBoeHZ6drGD/a9moZ
	 X9E79Kn6awLkdS/dbhbCqc3ujaaW1CWlgwodqVH0=
Date: Sat, 06 Jul 2024 11:54:13 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-index-add-links-to-admin-guide-doc.patch removed from -mm tree
Message-Id: <20240706185413.C8A19C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/index: add links to admin-guide doc
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-index-add-links-to-admin-guide-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/index: add links to admin-guide doc
Date: Mon, 1 Jul 2024 12:27:06 -0700

Readers of DAMON subsystem documents index would want to further learn how
they can use DAMON from the user-space.  Add the link to the admin guide.

Link: https://lkml.kernel.org/r/20240701192706.51415-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/index.rst |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-add-links-to-admin-guide-doc
+++ a/Documentation/mm/damon/index.rst
@@ -16,16 +16,16 @@ monitoring :ref:`mechanisms <damon_desig
    of the size of target workloads).
 
 Using this framework, therefore, the kernel can operate system in an
-access-aware fashion.  Because the features are also exposed to the user space,
-users who have special information about their workloads can write personalized
-applications for better understanding and optimizations of their workloads and
-systems.
+access-aware fashion.  Because the features are also exposed to the :doc:`user
+space </admin-guide/mm/damon/index>`, users who have special information about
+their workloads can write personalized applications for better understanding
+and optimizations of their workloads and systems.
 
 For easier development of such systems, DAMON provides a feature called
 :ref:`DAMOS <damon_design_damos>` (DAMon-based Operation Schemes) in addition
-to the monitoring.  Using the feature, DAMON users in both kernel and user
-spaces can do access-aware system operations with no code but simple
-configurations.
+to the monitoring.  Using the feature, DAMON users in both kernel and :doc:`user
+spaces </admin-guide/mm/damon/index>` can do access-aware system operations
+with no code but simple configurations.
 
 .. toctree::
    :maxdepth: 2
@@ -34,3 +34,6 @@ configurations.
    design
    api
    maintainer-profile
+
+To utilize and control DAMON from the user-space, please refer to the
+administration :doc:`guide </admin-guide/mm/damon/index>`.
_

Patches currently in -mm which might be from sj@kernel.org are


