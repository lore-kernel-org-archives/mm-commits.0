From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix.patch removed
 from -mm tree
Date: Thu, 21 Apr 2016 13:45:45 -0700
Message-ID: <57193bf9.5Fp2VEScVrdijqrD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbcDUUpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: fix build problem on arm
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: huge tmpfs: fix build problem on arm

allocated_huge will never be non-NULL if CONFIG_TRANSPARENT_HUGEPAGE is not.

Fixes: ab61a0a665d8 ("huge tmpfs: try to allocate huge pages, split into a team")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix
+++ a/mm/shmem.c
@@ -1663,7 +1663,7 @@ unlock:
 		unlock_page(page);
 		put_page(page);
 	}
-	if (alloced_huge) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && alloced_huge) {
 		shmem_disband_hugeteam(alloced_huge);
 		alloced_huge = NULL;
 	}
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are


