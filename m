Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585213B9DAD
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294507; cv=none; b=J6t1wYxE4FKIBSJpwI0lXVjAp9SvVHFThOffv3nVQtoD4XOvypwfku84bmbW4UUO1Nn4r2JVXLrbrCFXCLpgDR7mHnaj/x79b9f5ZXwmBLwGCHT6uYYmCgrgF2m+i1KBUJaM1RxgOjX8wcC6BofiO3I4ickTG7aoFSJJ5+TVqNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294507; c=relaxed/simple;
	bh=v+QlGJDaIzwuqi5zhlRFs8ZWiMhRVzsgSjVNC1Vp810=;
	h=Date:To:From:Subject:Message-Id; b=CTseVy78z4zmdm8056q1sizPfCiR2s/x3aY0+X7TGwY3rwFJZogu6QhTxbJb75Hmuuoq3H33tUUb1+q3Wy8g4sLqWboGValdVOZjhEPZ/UV27qzvihcthbeeHHiCjDUNjzcvdbVr/DOflagO6ZpxU33kL8G8FZYXMXb/60Jf0Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2SjcsOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2SjcsOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEFBC19425;
	Mon, 27 Apr 2026 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294507;
	bh=v+QlGJDaIzwuqi5zhlRFs8ZWiMhRVzsgSjVNC1Vp810=;
	h=Date:To:From:Subject:From;
	b=E2SjcsOH+cJAKL7ZTeZb4+tKRFoO43Vd4T9de8+8RgrZf6DwvLORqNX8V4QbFy1MW
	 PFDAPnPs0jRqKlnSZJnze3QHRaIxOCOpyNIJyxHK24p5QSupmucTGG5HU6rz29rOlh
	 Ae7gWF3sFtyBDVD5JVGFVs/8XZ0CRCZYhXoVqcZU=
Date: Mon, 27 Apr 2026 05:55:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-fix-regex-pattern-in-core-mm-category.patch removed from -mm tree
Message-Id: <20260427125507.1AEFBC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: fix regex pattern in CORE MM category
has been removed from the -mm tree.  Its filename was
     maintainers-fix-regex-pattern-in-core-mm-category.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: MAINTAINERS: fix regex pattern in CORE MM category
Date: Wed, 22 Apr 2026 13:37:26 +0100

The pattern "include/linux/page[-_]*" matches every file that starts with
"page", because it's a regex and not a glob (so it has the meaning of
include/linux/page + match [-_] 0+ times).

Fix it up into a more regex-correct expression.  Doing so reduces CC's
drastically in patches that touch pagemap.h (which is maintained as part
of PAGE CACHE).

As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
ALLOCATOR.

Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/
Link: https://lore.kernel.org/20260422123726.517220-1-pfalcato@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-fix-regex-pattern-in-core-mm-category
+++ a/MAINTAINERS
@@ -16805,7 +16805,7 @@ F:	mm/sparse.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
-N:	include/linux/page[-_]*
+N:	include\/linux\/page[-_][a-zA-Z]*
 
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -16962,6 +16962,7 @@ S:	Maintained
 F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
+F:	include/linux/pageblock-flags.h
 F:	mm/compaction.c
 F:	mm/debug_page_alloc.c
 F:	mm/debug_page_ref.c
_

Patches currently in -mm which might be from pfalcato@suse.de are


