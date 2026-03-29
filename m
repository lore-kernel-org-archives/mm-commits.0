Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D55210F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744830; cv=none; b=sDpA+6Lqo0hYP0clYSzxp206yRk1R/qrpqyTOmhqaBy9YHiVJl2r2r0pN+ce7i0OsNsQ/qtkuMSP5n/RDpWpXEe96nkyeaYjIkNTcvTYZvbNqk9cblyeW84RMIuHwNJtTE0yg+N5jgjkWCt+Ane/buGCdp/Z1TD4FsWaUYsT9E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744830; c=relaxed/simple;
	bh=cdnOXndySCu1eoqm7hNEW324RRA6sCijRd1IpKOKwr8=;
	h=Date:To:From:Subject:Message-Id; b=KMXPF/z6l5/w+h6s0NhfAaieTQ3vqTIIcfbcMhHMbpoJFEO/YDB6yrDhOy31tnS+Pi41Pie8qVnuThkGTNaV0pUurTuaBbgcQh6TLJdkJIhT08rXbpf40yMcox1lQpp26VogiL/nI7OVRF/Jk9SOpP5MknJm/tljGF16QIXXonY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QYkndO2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QYkndO2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEF0C4CEF7;
	Sun, 29 Mar 2026 00:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744830;
	bh=cdnOXndySCu1eoqm7hNEW324RRA6sCijRd1IpKOKwr8=;
	h=Date:To:From:Subject:From;
	b=QYkndO2KkYlCWL5Utyx6T4sHjNJ0yIfppj61AFB30Y29KiK+qLhM7UMFD3FL1NwPR
	 pPl8oY9/QApoLaqThb672GWbcvnvCXTbOpRBfSTrvti1V0/IWQc6QTpAncYPMiBtPV
	 HzCkRG3/oW5Yaj/KPojWvxuf/qFEbEHd/8nPaN7M=
Date: Sat, 28 Mar 2026 17:40:29 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch removed from -mm tree
Message-Id: <20260329004030.5AEF0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document the power-of-two limitation for addr_unit
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document the power-of-two limitation for addr_unit
Date: Sat, 7 Mar 2026 11:42:21 -0800

The min_region_sz is set as max(DAMON_MIN_REGION_SZ / addr_unit, 1). 
DAMON_MIN_REGION_SZ is the same to PAGE_SIZE, and addr_unit is what the
user can arbitrarily set.  Commit c80f46ac228b ("mm/damon/core: disallow
non-power of two min_region_sz") made min_region_sz to always be a power
of two.  Hence, addr_unit should be a power of two when it is smaller than
PAGE_SIZE.  While 'addr_unit' is a user-exposed parameter, the rule is not
documented.  This can confuse users.  Specifically, if the user sets
addr_unit as a value that is smaller than PAGE_SIZE and not a power of
two, the setup will explicitly fail.

Document the rule on the design document.  Usage documents reference the
design document for detail, so updating only the design document should
suffice.

Link: https://lkml.kernel.org/r/20260307194222.202075-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit
+++ a/Documentation/mm/damon/design.rst
@@ -150,6 +150,8 @@ address on the given address space.  Sup
 up to each operations set implementation.  ``paddr`` is the only operations set
 implementation that supports the parameter.
 
+If the value is smaller than ``PAGE_SIZE``, only a power of two should be used.
+
 .. _damon_core_logic:
 
 Core Logics
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

