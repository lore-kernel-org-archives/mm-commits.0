Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD738316190
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334276; cv=none; b=RH9S7kvvp1ABBjWoA4yUxMdkBtPPr9tyvqi6brj5o1WPdjcv66Pxqm7+/m9BKUR4sG/vCH3/UzuHHJ7encOUbZ4xF4myLa3/RUT1uxAWmFRyjvf5UY/VBkhBCcbNJr40+oBGd9f5NuK/ehKDVqZK2VUGJv+eBrNr07lcbpVAEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334276; c=relaxed/simple;
	bh=k4dMx2z24j6PhxtNwnC7BTfHKOs2LduzaJ8LaDc5neU=;
	h=Date:To:From:Subject:Message-Id; b=DD3xO96asmpPknRvJyw6aLgXjoJjXG9vBElY9KrFKnoPwqfIxFZokMsM2XAvwdhxY8isHvo7TAB/pMuFId2fTNYcWKCH3tr8K3Iw4RYq3rzi9DJfJodbe5huzbRQ325AtT3OyQmdb8FgvV0bWkJdlBjlJDhbs1Bv50NTrYRLCuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j01VW6Md; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j01VW6Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837881F0089D;
	Wed,  7 Oct 2026 00:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334275;
	bh=rkT0vcz+cTWsn5Au58Mz3raptneS6CipE+uaphoWSRo=;
	h=Date:To:From:Subject;
	b=j01VW6Md/3M5iN8xS24NH0Q/6ofhd8hCewgKEsR7wve7YgYVf1KPt95xBhOOAsVRL
	 BZVH9AhwbbsZ6lQPLvg3heEwgKeOssdCbjEAyszU6cOJqMEl/lco1mwEvGAzJi819J
	 0jml2Jc3sCSzfTXDqBCwsjnj+jHZ/EpbB6JDz0qo=
Date: Tue, 06 Oct 2026 17:51:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch removed from -mm tree
Message-Id: <20261007005115.837881F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm/damon/design: accurate semantics of nr_snapshots
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: docs/mm/damon/design: accurate semantics of nr_snapshots
Date: Mon, 31 Aug 2026 08:02:24 -0700

Patch series "docs/mm/damon/design: add explanation of nr_snapshots", v3.

Add an explanation of nr_snapshots to avoid misunderstandings.


This patch (of 3):

Change "tried to be applied" -> "completely tried to be applied" to
maintain consistency between the documentation and the code.

Link: https://lore.kernel.org/20260831150227.83416-1-sj@kernel.org
Link: https://lore.kernel.org/20260831150227.83416-2-sj@kernel.org
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 include/linux/damon.h             |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-accurate-semantics-of-nr_snapshots
+++ a/Documentation/mm/damon/design.rst
@@ -846,8 +846,8 @@ scheme's execution.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
-- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
-  be applied.
+- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is
+  completely tried to be applied.
 - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
--- a/include/linux/damon.h~docs-mm-damon-design-accurate-semantics-of-nr_snapshots
+++ a/include/linux/damon.h
@@ -357,7 +357,8 @@ struct damos_watermarks {
  *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
- *		Total number of DAMON snapshots that the scheme has tried.
+ *		Total number of DAMON snapshots that the scheme is completely
+ *		tried to be applied.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
  * determined the region as eligible to apply the action.  The access pattern
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch
docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch
mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch

