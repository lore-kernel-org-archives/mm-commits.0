Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C182C3911AF
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 20:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791144123; cv=none; b=JYjY4gp7AwZ15y/lWfzW9wVW3QAIfHyP03EKLH4SucAvf492Pxs5Q+fo19/V/1hzN54VcUrtJWDXEu+/t47gplSA061qy1BNWPjV4am/l0mXVw688btvy3r9sZY0dQTwiV9gZ8dB4CJ3hYMLfKmkz5LxxAANK12tL8IDNnX+TI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791144123; c=relaxed/simple;
	bh=hEYluV4XTxjy64ZNSpygj2v1KNCcrkHE6hrfBFoPY50=;
	h=Date:To:From:Subject:Message-Id; b=Mf75Ey2Un3HkmTEpWmTWQkO5C4IfnxlkA93ls3B7Nk/BHsao2bauGAaIuiu/zW070MdWgiIqUqB0BtYwpkdNRDkg2ZqP97AqI0qMI9syFOYDiLdZg8vSKYdlMAPUJ+gif0tXkOWyJ6mbE7WBE3QebWoL+7zroR9hYUzR5l8OGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qrRY44gx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qrRY44gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13441F000FF;
	Sun,  4 Oct 2026 20:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791144120;
	bh=FScariYrYIeKEBAyBDten1xJ3vskjweUqWCYKqj7wSc=;
	h=Date:To:From:Subject;
	b=qrRY44gx8UNNwWV40EV8svGe/o7L3oAEgTYouBPfEFBPUcgOewHkvCNaPTr9yihBa
	 tWZ8rdt5RnFbCdjM+2SK5nj++/eDpqGEygjBxfDnym6FuO1bvK88J8I9FxmNyStYdw
	 Y1Y72pTJYVc03J/mu8VijAiIPrqGcovY07NNB3TU=
Date: Sun, 04 Oct 2026 13:02:00 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,corbet@lwn.net,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch added to mm-new branch
Message-Id: <20261004200200.D13441F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: hugetlbpage.rst: fix typo in per-node attribute description
has been added to the -mm mm-new branch.  Its filename is
     docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: docs: hugetlbpage.rst: fix typo in per-node attribute description
Date: Sun,  4 Oct 2026 00:11:25 +0800

The per-node hugepages section writes the free_hugepages and
surplus_hugepages file names with stray trailing quotes.  Quote the real
names as inline literals instead.

Link: https://lore.kernel.org/20261003161125.40485-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
---

 Documentation/admin-guide/mm/hugetlbpage.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -373,9 +373,9 @@ contains the following attribute files::
 	free_hugepages
 	surplus_hugepages
 
-The free\_' and surplus\_' attribute files are read-only.  They return the number
-of free and surplus [overcommitted] huge pages, respectively, on the parent
-node.
+The ``free_hugepages`` and ``surplus_hugepages`` attribute files are read-only.
+They return the number of free and surplus [overcommitted] huge pages,
+respectively, on the parent node.
 
 The ``nr_hugepages`` attribute returns the total number of huge pages on the
 specified node.  When this attribute is written, the number of persistent huge
_

Patches currently in -mm which might be from lienze@kylinos.cn are

mm-damon-core-introduce-damon_set_target_pid.patch
samples-damon-mtier-add-comment-for-struct-region_range.patch
docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch

