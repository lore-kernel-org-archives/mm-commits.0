From: akpm@linux-foundation.org
Subject: [patch 88/96] sh: move inline before return type
Date: Wed, 12 Jul 2017 14:37:28 -0700
Message-ID: <20170712213728.UXP_4kc7G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVhj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dalias@libc.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, ysato@users.sourceforge.jp

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
