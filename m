Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDF2199947
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027836; cv=none; b=maE+e+nigiWX6oWENrEPY4YEmppfuuSiTGpSC48MNE4lHbphS1gM6I8rpeAbzrUb4aSPJdshb1PqOjDHVpG9Y1ArTlnv8+6wTMRFSGA7sagD2hULbiSEQSXWluIanYanZookG1A0hQe2wvVZ29jtLUaSu6Z47FQXecl0uDa9Ewk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027836; c=relaxed/simple;
	bh=zk8wrOZAE4N3MYujWAGM+aSrb3s5XFmQGG3R9HymzUw=;
	h=Date:To:From:Subject:Message-Id; b=c8ElUHEhE+qZEeIy/AGIfc8VKhBuA3CDz2iRfz63w4oVEFGcOUhVlpCyi1OpgPt7lamZY0Puc9wkApFsqflPPJF6t/mbCu/W5ylBBsLVonMXdMSE8FRf0djjaby2qAM9U6GEeoGjrTJRcUhPXnGRAfGMMHAI7vQTmw8xsrTNrYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kc54RJHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kc54RJHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD97EC4CEED;
	Wed,  9 Jul 2025 02:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752027834;
	bh=zk8wrOZAE4N3MYujWAGM+aSrb3s5XFmQGG3R9HymzUw=;
	h=Date:To:From:Subject:From;
	b=Kc54RJHU5/mwE7LwccKu8WdEQHrBt02wZXE0saHUB76eli9MWzW7buRXy3EtZvJ5h
	 4Mla2GNtdYR45cLXdEOMzGXdLjFG92P7lP0SqHvqL2IhGvvPsHG8WHoshS0Ru8g6t1
	 5M59ZVHSpwgQuJ/3u4NVZipO68mlxUyHyfYMUtO0=
Date: Tue, 08 Jul 2025 19:23:54 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch added to mm-new branch
Message-Id: <20250709022354.BD97EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document vaddr support for migrate_{hot,cold}
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: Docs/mm/damon/design: document vaddr support for migrate_{hot,cold}
Date: Tue, 8 Jul 2025 19:59:40 -0500

Document that the migrate_{hot,cold} schemes can be used by the vaddr
operations set.

Link: https://lkml.kernel.org/r/20250709005952.17776-11-bijan311@gmail.com
Co-developed-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold
+++ a/Documentation/mm/damon/design.rst
@@ -452,9 +452,9 @@ that supports each action are as below.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``migrate_hot``: Migrate the regions prioritizing warmer regions.
-   Supported by ``paddr`` operations set.
+   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``migrate_cold``: Migrate the regions prioritizing colder regions.
-   Supported by ``paddr`` operations set.
+   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``stat``: Do nothing but count the statistics.
    Supported by all operations sets.
 
_

Patches currently in -mm which might be from bijantabatab@micron.com are

mm-damon-core-commit-damos-target_nid.patch
mm-damon-core-commit-damos-migrate_dests.patch
mm-damon-move-migration-helpers-from-paddr-to-ops-common.patch
mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold.patch
docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch
mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch
mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch
mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch

