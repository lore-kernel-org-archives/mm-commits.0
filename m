Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0631613CA8C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292053; cv=none; b=p31/VBT7Bx8K4RXbE8Dg96kfjm3KoSQ/Ep1klO6aZm3FRvAqaQq0ndl6WVjndS181p42EA0OWH7f646hC3wJHf+qAQB2p4CxxS3ddxZiQBDCcOuAXrB5sa4SQNr1lOZuwgl09NQkcd+knRRdaecvYfrilb1Uf10WRdnFnerTTtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292053; c=relaxed/simple;
	bh=7hYY2hn/5h2c205rFG6bAfoILF0UMYyOgBcD99ayCdI=;
	h=Date:To:From:Subject:Message-Id; b=VM1sFik/OQQE36PiDAzlwhEDPr4gUEPo3egqjjeZ5qZm6r9PUQ45PGlMlG8KjwpT9wpC5eA1tlRhbt2eJTuhabypyKJXUgTBjWFI0YEgNEczTpzaxPdcK4wmOQwlO4qe1zuYq93Vq6vcMgBsW6VYgBUw8/X+ryIkWYGgg4Eg9FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=17MGIVlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="17MGIVlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2777C32781;
	Sat,  6 Jul 2024 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292052;
	bh=7hYY2hn/5h2c205rFG6bAfoILF0UMYyOgBcD99ayCdI=;
	h=Date:To:From:Subject:From;
	b=17MGIVlrWeE1ppm6eMMjDJyqWGJr0qHDLB8kfMXNP/Ey2m6L/qjlTiiddDqMWw9uF
	 jsu9vc3V8GCrnSI43JCBOZ4Mwnlc8gofkRlq4KpvPTimJC4WViq6roXI5KHNQmZ81Q
	 Pzl2uZTPcY2yNbVBJmXJsiJjR0QBJ/Jw32GxvJZc=
Date: Sat, 06 Jul 2024 11:54:12 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-index-add-links-to-design.patch removed from -mm tree
Message-Id: <20240706185412.D2777C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/index: add links to design
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-index-add-links-to-design.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/index: add links to design
Date: Mon, 1 Jul 2024 12:27:05 -0700

DAMON subsystem documents index page provides a short intro of DAMON core
concepts.  Add links to sections of the design document to let users
easily browse to the details.

Link: https://lkml.kernel.org/r/20240701192706.51415-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    1 +
 Documentation/mm/damon/index.rst  |   11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-index-add-links-to-design
+++ a/Documentation/mm/damon/design.rst
@@ -141,6 +141,7 @@ as Idle page tracking does.
 Core Logics
 ===========
 
+.. _damon_design_monitoring:
 
 Monitoring
 ----------
--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-add-links-to-design
+++ a/Documentation/mm/damon/index.rst
@@ -6,7 +6,7 @@ DAMON: Data Access MONitor
 
 DAMON is a Linux kernel subsystem that provides a framework for data access
 monitoring and the monitoring results based system operations.  The core
-monitoring mechanisms of DAMON (refer to :doc:`design` for the detail) make it
+monitoring :ref:`mechanisms <damon_design_monitoring>` of DAMON make it
 
  - *accurate* (the monitoring output is useful enough for DRAM level memory
    management; It might not appropriate for CPU Cache levels, though),
@@ -21,10 +21,11 @@ users who have special information about
 applications for better understanding and optimizations of their workloads and
 systems.
 
-For easier development of such systems, DAMON provides a feature called DAMOS
-(DAMon-based Operation Schemes) in addition to the monitoring.  Using the
-feature, DAMON users in both kernel and user spaces can do access-aware system
-operations with no code but simple configurations.
+For easier development of such systems, DAMON provides a feature called
+:ref:`DAMOS <damon_design_damos>` (DAMon-based Operation Schemes) in addition
+to the monitoring.  Using the feature, DAMON users in both kernel and user
+spaces can do access-aware system operations with no code but simple
+configurations.
 
 .. toctree::
    :maxdepth: 2
_

Patches currently in -mm which might be from sj@kernel.org are


