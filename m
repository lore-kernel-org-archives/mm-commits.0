From: akpm@linux-foundation.org
Subject: [merged] sh-move-inline-before-return-type.patch removed
 from -mm tree
Date: Thu, 13 Jul 2017 13:43:28 -0700
Message-ID: <20170713204328.AeUNUNZr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdGMUn3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, joe@perches.com, mm-commits@vger.kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: move inline before return type
has been removed from the -mm tree.  Its filename was
     sh-move-inline-before-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: sh: move inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/f81bb2a67a97b1fd8b6ea99bd350d8a0f6864fb1.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/cache-sh5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/mm/cache-sh5.c~sh-move-inline-before-return-type arch/sh/mm/cache-sh5.c
--- a/arch/sh/mm/cache-sh5.c~sh-move-inline-before-return-type
+++ a/arch/sh/mm/cache-sh5.c
@@ -234,7 +234,7 @@ static void sh64_icache_inv_current_user
 #define DUMMY_ALLOCO_AREA_SIZE ((L1_CACHE_BYTES << 10) + (1024 * 4))
 static unsigned char dummy_alloco_area[DUMMY_ALLOCO_AREA_SIZE] __cacheline_aligned = { 0, };
 
-static void inline sh64_dcache_purge_sets(int sets_to_purge_base, int n_sets)
+static inline void sh64_dcache_purge_sets(int sets_to_purge_base, int n_sets)
 {
 	/* Purge all ways in a particular block of sets, specified by the base
 	   set number and number of sets.  Can handle wrap-around, if that's
_

Patches currently in -mm which might be from joe@perches.com are


