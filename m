Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3F727281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490019; cv=none; b=JzNVsB3qCLmQOmZXXqv4tljQcmhKvH+S485JD0VE5HBPE+pbizyMSFug7U6mnyvkFo4pQtNSa6L3h8h/vGdbRiUeNSkmjG5AMHDr46+nhLgiCwzDNONEqwHzdXT/X1i2DKmyTtc/ba+23zi33NS1rkVbirWjI1YWULNKzRJPaZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490019; c=relaxed/simple;
	bh=xHy9bdF86V4l4kQStjSYsm+YXd8NSOTmNq+Xmzn3COY=;
	h=Date:To:From:Subject:Message-Id; b=BnFunzg/fmbVN+TiswzSDI7WnLKjlHD8pRHqpha/x2ZOacXt0oGx+z7zfKG2DgkKCxmTdZn8m6sv6kI5ZY6DEWrD02lhJfQpKyokfQWcKUZ0Xflw9x5k+3HOjhDzmkj1ZsjX7RvEJsiR/PBQZNsQXseaYjasg2rMbTAfavPFO/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b4FI3BTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b4FI3BTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBB9C4CEE7;
	Sun, 21 Sep 2025 21:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490019;
	bh=xHy9bdF86V4l4kQStjSYsm+YXd8NSOTmNq+Xmzn3COY=;
	h=Date:To:From:Subject:From;
	b=b4FI3BTZlyuXnlTmjUSV0AZox0vMrex5UO+0LwJLAhb8qhYQXY3W92HBpc+P8dE6y
	 l+i+P+wG8YM6e/+HdXhi66tE1+bsGlxG5sCuWM0pGg0iFs4EXx1Y/mAWkDqYOy1ucI
	 MFZM8RlPjn4biT6+LyndNF9QrSkFlftHQC36BT+w=
Date: Sun, 21 Sep 2025 14:26:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-rename-damon-section.patch removed from -mm tree
Message-Id: <20250921212659.9FBB9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: rename DAMON section
has been removed from the -mm tree.  Its filename was
     maintainers-rename-damon-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

