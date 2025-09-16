Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FFF13C9C4
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757996338; cv=none; b=Si4u/PaLHjlgtAx0DfVWE4Xo9sU6WiwU0QshvQL5srmivor6gzG55zXtuh5jzEBYV7m73rj5sIfTtMi86cEChXi1Udx6HTGDhAYTGWxZZGaXVJ4ofoEiiKaxQ54WI5FpqNA+kCIDuHzFvNmOagNUJh4rGw9RZ5jF+gM8bnKdTAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757996338; c=relaxed/simple;
	bh=YSyRV7Nnlo9w0qS1kH1NURIv9/kjeX6bWJ3e1ooRkQI=;
	h=Date:To:From:Subject:Message-Id; b=ZQGzZwq91YrDQVTfK6b3mY5XyMiaJ0Al8XRJtIBlUGxG3369HNhRIJtZ6eyLfWW3RCQBpybMkAa71Zl0a1Ejp0OyIGhV+EtN8OQ9d3pxyKTo8vRblsOSe38ECIhcnz1jq7X+uUotf09i18S6tpdQ2J4i1wnMLP8E9OzPjYdT5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V7h6MT/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V7h6MT/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14B9C4CEEB;
	Tue, 16 Sep 2025 04:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757996337;
	bh=YSyRV7Nnlo9w0qS1kH1NURIv9/kjeX6bWJ3e1ooRkQI=;
	h=Date:To:From:Subject:From;
	b=V7h6MT/h90j1C8FfjxFJUAHo+GhsavWR3enoZjF+WievQmuMAUiz94jxHDJDhvXCT
	 Ib4FOJJSuTyFNIepOf4oWoYTKupJoa/K544ruoztSNE3LRVUZMhR8+bo3O1of0YfOU
	 +3l9teYh1RJ8RTYmA/+8Hhl95aTXSaGu3qrGhjyc=
Date: Mon, 15 Sep 2025 21:18:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-rename-damon-section.patch added to mm-new branch
Message-Id: <20250916041857.C14B9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: rename DAMON section
has been added to the -mm mm-new branch.  Its filename is
     maintainers-rename-damon-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-rename-damon-section.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS: rename DAMON section
Date: Mon, 15 Sep 2025 20:23:39 -0700

DAMON section name is 'DATA ACCESS MONITOR', which implies it is only for
data access monitoring.  But DAMON is now evolved for not only access
monitoring but also access-aware system operations (DAMOS).  Rename the
section to simply DAMON.  It might make it difficult to understand what it
does at a glance, but at least not spreading more confusion.  Readers can
further refer to the documentation to better understand what really DAMON
does.

Link: https://lkml.kernel.org/r/20250916032339.115817-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-rename-damon-section
+++ a/MAINTAINERS
@@ -6738,7 +6738,7 @@ S:	Maintained
 W:	https://docs.dasharo.com/
 F:	drivers/platform/x86/dasharo-acpi.c
 
-DATA ACCESS MONITOR
+DAMON
 M:	SeongJae Park <sj@kernel.org>
 L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch

