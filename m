Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E206139CFC
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292049; cv=none; b=Z209IxoL7vzoL99e4qtcwTZkrV5kEvAHRH1OrxPg5u54p+4NaD0FloOr6s4p7SQ2sJPJNMVKJP5qvO+OViIL0dcoRa0bsmpwJ64U97kqNlXDMIpzTf96PmLg5yz7DyGXiUIKUEyFiqw+vnAtXgUnFY5jxPsYz41azYc0x5ku+3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292049; c=relaxed/simple;
	bh=Iqljm371jRNBrUHjmf/42dSsm8NZAI+6H9S0I1Idc1Q=;
	h=Date:To:From:Subject:Message-Id; b=qq/6e6/g7y7zMNTb4VJlpDHGEC9klQql3nqJ/DBlTa5DlVtrr9KgOumTNujJMpH7t11PQx2D5zyCVXzy6m9tT0Yz9Doh1X6HzOWCGvF97SehI2RkVXQSOYYFvlsCJNgOGTqNe3ewrOFENspnZADxbY51QHsiXkBbNpAfU8X4fYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gsnooml2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gsnooml2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F62C4AF0A;
	Sat,  6 Jul 2024 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292048;
	bh=Iqljm371jRNBrUHjmf/42dSsm8NZAI+6H9S0I1Idc1Q=;
	h=Date:To:From:Subject:From;
	b=Gsnooml2MZTxeE5bZ+wA3EnOFHMZtC8IJau70HmAlpi7FaNhFKUK4PVrIEovT/Pcq
	 Wj00AGYz7B6frGDCdciTvm2G6EwG0Z+wGhDB4AIJmlqtgK+kq/cteodLx3GW7XfNhu
	 fuD8+DoPunt4xsqb19bRGS0spvA7wWh+XXJeI+TI=
Date: Sat, 06 Jul 2024 11:54:08 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch removed from -mm tree
Message-Id: <20240706185408.D7F62C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: add links from overall architecture to sections of details
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add links from overall architecture to sections of details
Date: Mon, 1 Jul 2024 12:27:01 -0700

DAMON design document briefly explains the overall layers architecture
first, and then provides detailed explanations of each layer with
dedicated sections.  Letting readers go directly to the detailed sections
for specific layers could help easy browsing of the not-very-short
document.  Add links from the overall summary to the sections of details.

Link: https://lkml.kernel.org/r/20240701192706.51415-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details
+++ a/Documentation/mm/damon/design.rst
@@ -22,13 +22,15 @@ Overall Architecture
 
 DAMON subsystem is configured with three layers including
 
-- Operations Set: Implements fundamental operations for DAMON that depends on
-  the given monitoring target address-space and available set of
-  software/hardware primitives,
-- Core: Implements core logics including monitoring overhead/accuracy control
-  and access-aware system operations on top of the operations set layer, and
-- Modules: Implements kernel modules for various purposes that provides
-  interfaces for the user space, on top of the core layer.
+- :ref:`Operations Set <damon_operations_set>`: Implements fundamental
+  operations for DAMON that depends on the given monitoring target
+  address-space and available set of software/hardware primitives,
+- :ref:`Core <damon_core_logic>`: Implements core logics including monitoring
+  overhead/accuracy control and access-aware system operations on top of the
+  operations set layer, and
+- :ref:`Modules <damon_modules>`: Implements kernel modules for various
+  purposes that provides interfaces for the user space, on top of the core
+  layer.
 
 
 .. _damon_design_configurable_operations_set:
@@ -140,6 +142,8 @@ conflict with the reclaim logic using ``
 as Idle page tracking does.
 
 
+.. _damon_core_logic:
+
 Core Logics
 ===========
 
@@ -512,6 +516,8 @@ interface, namely ``include/linux/damon.
 :doc:`document </mm/damon/api>` for details of the interface.
 
 
+.. _damon_modules:
+
 Modules
 =======
 
_

Patches currently in -mm which might be from sj@kernel.org are


