From: akpm@linux-foundation.org
Subject: +
 huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix.patch added to
 -mm tree
Date: Fri, 15 Apr 2016 14:11:26 -0700
Message-ID: <571158fe.InsPauRaII9BjdAM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbcDOVL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 17:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: fix build problem on arm
has been added to the -mm tree.  Its filename is
     huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team-fix.patch

