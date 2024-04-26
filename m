Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEA87EF06
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104037; cv=none; b=XFc0Tw6nVnpaHlRTNGDyhYSSCmJc6Qp4CwgNASJb+FnAHRCQS1yaFC160s1nICgNDRRzwEXsPwhFUuplxq3JUP40w+gTKuDiwlVaj7AGmIKBwhOZg3ptwUhjoKOLCCCUjJuKdngheOP2OE5WRyNcmnrwf7YFLThdpOsmt+20qOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104037; c=relaxed/simple;
	bh=A9PgzLPGu7IIGjcqteEhyzUH5MhxCPX3f3O9/1zVOFQ=;
	h=Date:To:From:Subject:Message-Id; b=FOK+iouwZqBnk49CO3S89YKN5C1W40xIyFEorgLf68PFzAYSpWvSsuptZas33KN7rh0+gfVXpANdXKoDSWLDjL2B6VaEhAZlLrkRq8Z596r3wkFcP9yDFN8/q78CNF1W1WwFAkMPP0A0LpcRY+nNnlnTxNB3i4T7CQLA9CBmnDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0XcAbK7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0XcAbK7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EA2C113CD;
	Fri, 26 Apr 2024 04:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104037;
	bh=A9PgzLPGu7IIGjcqteEhyzUH5MhxCPX3f3O9/1zVOFQ=;
	h=Date:To:From:Subject:From;
	b=0XcAbK7GPDLiYu6MBkqL8KqHzMfAd0YNlIBUYDm/Hyi2gVTLxQyQCCynZrRZLTDM4
	 oANVBxX0BRhTh09eFH5wZKzJwnuBtAr1eWWRlHaw1i0n1H2ibQUSrZiMSYLvVwHDyE
	 fE3Qd50HsBcSDi8+niqIHHMVHaxOlWYhj5zHZFqM=
Date: Thu, 25 Apr 2024 21:00:37 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch removed from -mm tree
Message-Id: <20240426040037.A1EA2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc.c: change the array-length to MIGRATE_PCPTYPES
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/page_alloc.c: change the array-length to MIGRATE_PCPTYPES
Date: Tue, 26 Mar 2024 14:11:33 +0800

Earlier, in commit 1dd214b8f21c ("mm: page_alloc: avoid merging
non-fallbackable pageblocks with others"), migrate type MIGRATE_CMA and
MIGRATE_ISOLATE are removed from fallbacks list since they are never used.

Later on, in commit ("aa02d3c174ab mm/page_alloc: reduce fallbacks to
(MIGRATE_PCPTYPES - 1)"), the array column size is reduced to
'MIGRATE_PCPTYPES - 1'. In fact, the array row size need be reduced to
MIGRATE_PCPTYPES too since it's only covering rows of the number
MIGRATE_PCPTYPES. Even though the current code has handled cases
when the migratetype is CMA, HIGHATOMIC and MEMORY_ISOLATION, making
the row size right is still good to avoid future error and confusion.

Link: https://lkml.kernel.org/r/20240326061134.1055295-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-change-the-array-length-to-migrate_pcptypes
+++ a/mm/page_alloc.c
@@ -1542,7 +1542,7 @@ struct page *__rmqueue_smallest(struct z
  *
  * The other migratetypes do not have fallbacks.
  */
-static int fallbacks[MIGRATE_TYPES][MIGRATE_PCPTYPES - 1] = {
+static int fallbacks[MIGRATE_PCPTYPES][MIGRATE_PCPTYPES - 1] = {
 	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE   },
 	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE },
 	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE   },
_

Patches currently in -mm which might be from bhe@redhat.com are

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

