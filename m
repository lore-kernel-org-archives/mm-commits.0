Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE9930D3E9
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334278; cv=none; b=qO+AwdHxiETCXb2mvTNtyHoWo2YR935nVhzcCiVNHYW/XGXh1GhCY3jnPSRyu6+SzRLhNyXj6Nzi0hzZ7y1ChpbCQot+3kwHrv/cILoX39w6kwEZp16ppTZGLa7lg0X2wkNqe6luzOhSik3PRgXAUjKJYfcLE9rJ6Eb/2uykpKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334278; c=relaxed/simple;
	bh=neXkjjasKX458pKtpbNLXaAM7CrXw9HlWEiRVaGd+vc=;
	h=Date:To:From:Subject:Message-Id; b=Rh/8JcdASFlwm3p0P4Rj/Q8zLc0xnPFuW0YjO3hpzUWfpFeLfhPI680zqK0/1bHjoARm6V9gsTGDMI/Li5NA0/PEM1ThSx3aboCuOwYiXocWXZM3n2IM7oJVBPbkiV/x9UYja3JKGUjCVkzVOlEF65hvGdX5Eyj6lRYOEl3mcvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mKITFRg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mKITFRg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56EA1F0089C;
	Wed,  7 Oct 2026 00:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334277;
	bh=NVZo9g0lC8Q0q/F8gfIDYa1VLcwWXmpX6WUXpzGY6BA=;
	h=Date:To:From:Subject;
	b=mKITFRg8XR7D2l6iQ1KyhYvtqzXJdGnz5hfIqYQoSsO/2Imirx7HPag78RSt9GO9F
	 vDrRERMS1WGL8maMKiyCDtL/3GA5EM83WOYbo5VaAkS4Bz8ArotRVmyAle85lMW9J+
	 B+38156QnCVg5JOYv0U1HQVA5oMWUYwhXdJjmGzY=
Date: Tue, 06 Oct 2026 17:51:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch removed from -mm tree
Message-Id: <20261007005117.A56EA1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm/damon/design: fix typo of max_nr_snapshots
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: docs/mm/damon/design: fix typo of max_nr_snapshots
Date: Mon, 31 Aug 2026 08:02:26 -0700

Fix a typo (nr_snapshots -> max_nr_snapshots) and corrects a grammar
error.

Link: https://lore.kernel.org/20260831150227.83416-4-sj@kernel.org
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
 include/linux/damon.h             |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-typo-of-max_nr_snapshots
+++ a/Documentation/mm/damon/design.rst
@@ -871,8 +871,8 @@ action is ``pageout`` while all pages of
 the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
-non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+non-zero and ``nr_snapshots`` equals or is greater than ``max_nr_snapshots``,
+the scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
--- a/include/linux/damon.h~docs-mm-damon-design-fix-typo-of-max_nr_snapshots
+++ a/include/linux/damon.h
@@ -549,7 +549,7 @@ struct damos_migrate_dests {
  *
  * After applying the &action to each region, &stat is updated.
  *
- * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots be same to or
+ * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots equals or is
  * greater than it, the scheme is deactivated.
  */
 struct damos {
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch
docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch
mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch

