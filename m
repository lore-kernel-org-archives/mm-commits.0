Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81DB38A9AE
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898346; cv=none; b=pSKJv0W5p3vPYMAYV0sAAzTk+lDOR6Y2hJgBNyF0jGJVyvjXDW5RKDqDoexSgnSnokcY8hk3gCeeDdL2h0QFlbRFFHnwCNKgp5sCqfrA3z23JwbGY3KuZO/dwq/xl35H1Zw9OQerH6h44wQ9nVHz6t50TebqtqoTmXM58YqfAj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898346; c=relaxed/simple;
	bh=FnqsAwiiIAR4YjS/WklYS1hgEWiMoPzfLd0yut51e0U=;
	h=Date:To:From:Subject:Message-Id; b=GhULOH9ODb+MeAarfyxpeJA6rMwqC0sgf2Vfj0aa62L2jv/k8qPNcYILe8SAK3oj3Lkx7+og48vIfDoaMp1XMj7mzgO6hbFteE9xa0GwlDpdpeehfPEvFapg+rwR6fQFMr2iv1O6KtVmeuhF+UdnkFsyaDDLERFqPBIrMTheyLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pDFQ8tQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pDFQ8tQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A16EC19421;
	Sat, 31 Jan 2026 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898345;
	bh=FnqsAwiiIAR4YjS/WklYS1hgEWiMoPzfLd0yut51e0U=;
	h=Date:To:From:Subject:From;
	b=pDFQ8tQV7LrvG1C10JOXIRmEdMVf/r4gPVEHdM6M49uxOKQl/DDTbN+7h5Nzb9j/b
	 QDp68wRZi0GaEM4IXk6hSu9rDd8FjWg0dQ7RJFIaZwt/bSL3bnEDocfOOnA8tw1Tf7
	 i5eljOXArSVdqHv3zyLhDRVTtLOcpMbeIvipzK/c=
Date: Sat, 31 Jan 2026 14:25:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-index-simplify-the-intro.patch removed from -mm tree
Message-Id: <20260131222545.8A16EC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/index: simplify the intro
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-index-simplify-the-intro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/index: simplify the intro
Date: Sun, 18 Jan 2026 10:02:52 -0800

Patch series "Docs/mm/damon: update intro, modules, maintainer profile,
and misc".

Update DAMON documentations for wordsmithing, clarifications, and
miscellaneous outdated things with eight patches.  Patch 1 simplifies the
brief introduction of DAMON.  Patch 2 updates DAMON user-space tool
packaged distros information on design doc to include not only Fedora, but
refer to repology.  Three following patches update design and usage
documents for clarifying DAMON sample modules purposes (patch 3), and
outdated information about usages of DAMON modules (patches 4 and 5). 
Final three patches update usage and maintainer-profile for sysfs
refresh_ms feature behavior (patch 6), synchronize DAMON MAINTAINERS
section name (patch 7), and broken damon-tests performance tests (patch
8).


This patch (of 8):

The intro is a bit verbose and redundant.  Simplify it by replacing
details with more links to the design docs, and refining the design points
list.

Link: https://lkml.kernel.org/r/20260118180305.70023-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260118180305.70023-2-sj@kernel.org
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

 Documentation/mm/damon/index.rst |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-simplify-the-intro
+++ a/Documentation/mm/damon/index.rst
@@ -4,28 +4,15 @@
 DAMON: Data Access MONitoring and Access-aware System Operations
 ================================================================
 
-DAMON is a Linux kernel subsystem that provides a framework for data access
-monitoring and the monitoring results based system operations.  The core
-monitoring :ref:`mechanisms <damon_design_monitoring>` of DAMON make it
+DAMON is a Linux kernel subsystem for efficient :ref:`data access monitoring
+<damon_design_monitoring>` and :ref:`access-aware system operations
+<damon_design_damos>`.  It is designed for being
 
- - *accurate* (the monitoring output is useful enough for DRAM level memory
-   management; It might not appropriate for CPU Cache levels, though),
- - *light-weight* (the monitoring overhead is low enough to be applied online),
-   and
- - *scalable* (the upper-bound of the overhead is in constant range regardless
-   of the size of target workloads).
-
-Using this framework, therefore, the kernel can operate system in an
-access-aware fashion.  Because the features are also exposed to the :doc:`user
-space </admin-guide/mm/damon/index>`, users who have special information about
-their workloads can write personalized applications for better understanding
-and optimizations of their workloads and systems.
-
-For easier development of such systems, DAMON provides a feature called
-:ref:`DAMOS <damon_design_damos>` (DAMon-based Operation Schemes) in addition
-to the monitoring.  Using the feature, DAMON users in both kernel and :doc:`user
-spaces </admin-guide/mm/damon/index>` can do access-aware system operations
-with no code but simple configurations.
+ - *accurate* (for DRAM level memory management),
+ - *light-weight* (for production online usages),
+ - *scalable* (in terms of memory size),
+ - *tunable* (for flexible usages), and
+ - *autoamted* (for production operation without manual tunings).
 
 .. toctree::
    :maxdepth: 2
_

Patches currently in -mm which might be from sj@kernel.org are


