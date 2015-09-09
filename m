From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:44:15 -0700
Message-ID: <55f08c0f.ePRiWyqjKJFsqoF8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbbIIToP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make set_recommended_min_free_kbytes() return void
has been removed from the -mm tree.  Its filename was
     mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Krause <xerofoify@gmail.com>
Subject: mm: make set_recommended_min_free_kbytes() return void

This makes set_recommended_min_free_kbytes() have a return type of void as
it cannot fail.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void
+++ a/mm/huge_memory.c
@@ -106,7 +106,7 @@ static struct khugepaged_scan khugepaged
 };
 
 
-static int set_recommended_min_free_kbytes(void)
+static void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;
@@ -141,7 +141,6 @@ static int set_recommended_min_free_kbyt
 		min_free_kbytes = recommended_min;
 	}
 	setup_per_zone_wmarks();
-	return 0;
 }
 
 static int start_stop_khugepaged(void)
_

Patches currently in -mm which might be from xerofoify@gmail.com are


