Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F20F4D124
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JFZuYKb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A3DC433C9;
	Wed, 20 Dec 2023 22:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112567;
	bh=bHHdOhrNK1fYNFcs3ma4DuEGlAKM0O3Hqe5KHG62zws=;
	h=Date:To:From:Subject:From;
	b=JFZuYKb10V43rBbIVbhNaJxpkub0LEewHhPDFYpt9zd6SKjWo6M6HbecXfjW9F2pq
	 PQPb2yYo3WY+hh0xwdOOBi+zukN9h45ufyXGsRIC9jnlbBxrRExjDb7Dx21XivSPCE
	 RjMpFcH09++IaajHfUupDVc4fKKwhsMWH9MIKGg0=
Date: Wed, 20 Dec 2023 14:49:27 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch removed from -mm tree
Message-Id: <20231220224927.90A3DC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update context directory section label
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update context directory section label
Date: Wed, 13 Dec 2023 19:03:36 +0000

The label for context DAMON sysfs directory section is having name
sysfs_contexts.  The name would be better to be used for the contexts
directory.  Rename it to represent a single context.

Link: https://lkml.kernel.org/r/20231213190338.54146-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-context-directory-section-label
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -164,7 +164,7 @@ number (``N``) to the file creates the n
 details).  At the moment, only one context per kdamond is supported, so only
 ``0`` or ``1`` can be written to the file.
 
-.. _sysfs_contexts:
+.. _sysfs_context:
 
 contexts/<N>/
 -------------
@@ -288,7 +288,7 @@ The ``action`` file is for setting and g
 from the file and their meaning are as below.
 
 Note that support of each action depends on the running DAMON operations set
-:ref:`implementation <sysfs_contexts>`.
+:ref:`implementation <sysfs_context>`.
 
  - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
@@ -428,7 +428,7 @@ pages of all memory cgroups except ``/ha
     echo N > 1/matching
 
 Note that ``anon`` and ``memcg`` filters are currently supported only when
-``paddr`` :ref:`implementation <sysfs_contexts>` is being used.
+``paddr`` :ref:`implementation <sysfs_context>` is being used.
 
 Also, memory regions that are filtered out by ``addr`` or ``target`` filters
 are not counted as the scheme has tried to those, while regions that filtered
_

Patches currently in -mm which might be from sj@kernel.org are


