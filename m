Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39231A285
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120556; cv=none; b=A3XLwaiw1E9ieDJDj3TAMFDMkd7QhOG7Yki5gwHvyDupRkd/fUokgPmMDCe0ejZDhfCJxbL32E6BYfxMFqD/bc29AgceVRVM1N5fMSGDX3a3XJzKr6XpPg8adUf3COfmakccg7Q/Oj4Tc18XqOLXg8W20gAFtujTiIp+V+GYKVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120556; c=relaxed/simple;
	bh=N6UE1SxmfV7XkXhdqVj0vLiba9/TLzwiUoEirLXlWus=;
	h=Date:To:From:Subject:Message-Id; b=IvwRoBYfv4VAHdCWccXDw9kMuGQqZw2wzsYmnYYBImFLjM+bWPH9Y3nDL6rlY8ph9RgaZoRBU98MQ6MNlRcofQzuYQh3ZR97EUOMzVY8aBAvaLYragBooI9M1dgP+fR98i2BguRe5+fXU1cO1HOhHrRLNo+uCM2pcTgwvb8zINc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fW3G0q6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fW3G0q6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41A5C4CEE3;
	Thu, 10 Jul 2025 04:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120555;
	bh=N6UE1SxmfV7XkXhdqVj0vLiba9/TLzwiUoEirLXlWus=;
	h=Date:To:From:Subject:From;
	b=fW3G0q6gqkFtJmktNr22lx+2qQrASpz2D/hb+ykBHuFhxE/zTyaHGi0xFP4excBLY
	 jJGsoMUHUiKUjk1eDoiMpgUZ514TnYP17BBtPZi/Su8GAeWQ/mTxqMg7UXhj8NOz3X
	 wTVOV7Xvzrr8rzeqyHmH/lauXYE6GXIQ+bQ4wgyc=
Date: Wed, 09 Jul 2025 21:09:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,tomas@vondra.me,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,bertranddrouvot.pg@gmail.com,apopple@nvidia.com,myon@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-do_pages_stat-in-32-bit-mode.patch removed from -mm tree
Message-Id: <20250710040915.B41A5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: fix do_pages_stat in compat mode
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-do_pages_stat-in-32-bit-mode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Berg <myon@debian.org>
Subject: mm/migrate: fix do_pages_stat in compat mode
Date: Tue, 24 Jun 2025 16:44:27 +0200

For arrays with more than 16 entries, the old code would incorrectly
advance the pages pointer by 16 words instead of 16 compat_uptr_t.  Fix by
doing the pointer arithmetic inside get_compat_pages_array where pages32
is already a correctly-typed pointer.

Discovered while working on PostgreSQL 18's new NUMA introspection code.

Link: https://lkml.kernel.org/r/aGREU0XTB48w9CwN@msg.df7cb.de
Fixes: 5b1b561ba73c ("mm: simplify compat_sys_move_pages")
Signed-off-by: Christoph Berg <myon@debian.org>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reported-by: Bertrand Drouvot <bertranddrouvot.pg@gmail.com>
Reported-by: Tomas Vondra <tomas@vondra.me>
Closes: https://www.postgresql.org/message-id/flat/6342f601-77de-4ee0-8c2a-3deb50ceac5b%40vondra.me#86402e3d80c031788f5f55b42c459471
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-do_pages_stat-in-32-bit-mode
+++ a/mm/migrate.c
@@ -2399,6 +2399,7 @@ set_status:
 
 static int get_compat_pages_array(const void __user *chunk_pages[],
 				  const void __user * __user *pages,
+				  unsigned long chunk_offset,
 				  unsigned long chunk_nr)
 {
 	compat_uptr_t __user *pages32 = (compat_uptr_t __user *)pages;
@@ -2406,7 +2407,7 @@ static int get_compat_pages_array(const
 	int i;
 
 	for (i = 0; i < chunk_nr; i++) {
-		if (get_user(p, pages32 + i))
+		if (get_user(p, pages32 + chunk_offset + i))
 			return -EFAULT;
 		chunk_pages[i] = compat_ptr(p);
 	}
@@ -2425,27 +2426,28 @@ static int do_pages_stat(struct mm_struc
 #define DO_PAGES_STAT_CHUNK_NR 16UL
 	const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];
 	int chunk_status[DO_PAGES_STAT_CHUNK_NR];
+	unsigned long chunk_offset = 0;
 
 	while (nr_pages) {
 		unsigned long chunk_nr = min(nr_pages, DO_PAGES_STAT_CHUNK_NR);
 
 		if (in_compat_syscall()) {
 			if (get_compat_pages_array(chunk_pages, pages,
-						   chunk_nr))
+						   chunk_offset, chunk_nr))
 				break;
 		} else {
-			if (copy_from_user(chunk_pages, pages,
+			if (copy_from_user(chunk_pages, pages + chunk_offset,
 				      chunk_nr * sizeof(*chunk_pages)))
 				break;
 		}
 
 		do_pages_stat_array(mm, chunk_nr, chunk_pages, chunk_status);
 
-		if (copy_to_user(status, chunk_status, chunk_nr * sizeof(*status)))
+		if (copy_to_user(status + chunk_offset, chunk_status,
+				 chunk_nr * sizeof(*status)))
 			break;
 
-		pages += chunk_nr;
-		status += chunk_nr;
+		chunk_offset += chunk_nr;
 		nr_pages -= chunk_nr;
 	}
 	return nr_pages ? -EFAULT : 0;
_

Patches currently in -mm which might be from myon@debian.org are


