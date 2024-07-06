Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F77113CA8C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292051; cv=none; b=KQ4lPpgWbH/KgTI1llIcdtIcxZzOBIBDviZQyd7O1XZlTbi4OAVq1UgH9YpnSLocmrcmm8b68JB2ci+xPkHpx+WTVs4Ha9/A3OWOSEYgRv1sRa8exuTJVog4d8SuRyS7VuHPgCpVwI1teOefUDPtNFmxZd6G3AWLn1CEgxGHRC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292051; c=relaxed/simple;
	bh=fr2acl65B4+QnGup+6ukLMIVJWtqaDRQNItIhVhlzUk=;
	h=Date:To:From:Subject:Message-Id; b=iWfw3+81E6ql94sD+KZK26RcAN4SRAkipob9JMXi7wJSZbG1OSSNpOlLcj+kvpU85PQ+9AKcGCZBX8FxEi9nc2ct1B2FmanKsiqCpI8KVjmUy2PPgzeMWBF7M351/HxXs9LAaWV5F3SMdYpJuvl/sa122AUUi7aOEJ/Eef5yDuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QIUdrVW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QIUdrVW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6309C2BD10;
	Sat,  6 Jul 2024 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292049;
	bh=fr2acl65B4+QnGup+6ukLMIVJWtqaDRQNItIhVhlzUk=;
	h=Date:To:From:Subject:From;
	b=QIUdrVW8B+XnVFI4gXGHncWMYI6+suHzVx+tHYlU01Lkdaef9IlU5dTOumbfYw7C6
	 4TuMCmnCgYodkgkwl9CF9pTI3QqbJQgUl/LQOlumvQFYgez4JPL/0M250olA+EfukZ
	 zXLdCTmY7AqrQxULYAj4o6C/wMXECfPsnwAT1rrc=
Date: Sat, 06 Jul 2024 11:54:09 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch removed from -mm tree
Message-Id: <20240706185409.D6309C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: move 'Configurable Operations Set' section into 'Operations Set Layer' section
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: move 'Configurable Operations Set' section into 'Operations Set Layer' section
Date: Mon, 1 Jul 2024 12:27:02 -0700

'Configurable Operations Set' section is for providing a description of
the pluggability of the operations set layer.  Just after that,
'Operations Set Layer' section, which is dedicated for the entire things
of the layer, follows.  The layout is odd, and some descriptions are
duplicated.  Move 'Configurable Operations Set' section into 'Operations
Set Layer' and re-write some of the detailed descriptions.

Link: https://lkml.kernel.org/r/20240701192706.51415-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   47 +++++++++++++---------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section
+++ a/Documentation/mm/damon/design.rst
@@ -33,30 +33,6 @@ DAMON subsystem is configured with three
   layer.
 
 
-.. _damon_design_configurable_operations_set:
-
-Configurable Operations Set
----------------------------
-
-For data access monitoring and additional low level work, DAMON needs a set of
-implementations for specific operations that are dependent on and optimized for
-the given target address space.  On the other hand, the accuracy and overhead
-tradeoff mechanism, which is the core logic of DAMON, is in the pure logic
-space.  DAMON separates the two parts in different layers, namely DAMON
-Operations Set and DAMON Core Logics Layers, respectively.  It further defines
-the interface between the layers to allow various operations sets to be
-configured with the core logic.
-
-Due to this design, users can extend DAMON for any address space by configuring
-the core logic to use the appropriate operations set.  If any appropriate set
-is unavailable, users can implement one on their own.
-
-For example, physical memory, virtual memory, swap space, those for specific
-processes, NUMA nodes, files, and backing memory devices would be supportable.
-Also, if some architectures or devices supporting special optimized access
-check primitives, those will be easily configurable.
-
-
 Programmable Modules
 --------------------
 
@@ -72,11 +48,32 @@ used by the user space end users.
 Operations Set Layer
 ====================
 
-The monitoring operations are defined in two parts:
+.. _damon_design_configurable_operations_set:
+
+For data access monitoring and additional low level work, DAMON needs a set of
+implementations for specific operations that are dependent on and optimized for
+the given target address space.  For example, below two operations for access
+monitoring are address-space dependent.
 
 1. Identification of the monitoring target address range for the address space.
 2. Access check of specific address range in the target space.
 
+DAMON consolidates these implementations in a layer called DAMON Operations
+Set, and defines the interface between it and the upper layer.  The upper layer
+is dedicated for DAMON's core logics including the mechanism for control of the
+monitoring accruracy and the overhead.
+
+Hence, DAMON can easily be extended for any address space and/or available
+hardware features by configuring the core logic to use the appropriate
+operations set.  If there is no available operations set for a given purpose, a
+new operations set can be implemented following the interface between the
+layers.
+
+For example, physical memory, virtual memory, swap space, those for specific
+processes, NUMA nodes, files, and backing memory devices would be supportable.
+Also, if some architectures or devices support special optimized access check
+features, those will be easily configurable.
+
 DAMON currently provides below three operation sets.  Below two subsections
 describe how those work.
 
_

Patches currently in -mm which might be from sj@kernel.org are


