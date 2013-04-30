From: akpm@linux-foundation.org
Subject: [merged] lguest-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:47 -0700
Message-ID: <20130430190247.74D4C31C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49416 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:48 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so87569ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lguest: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     lguest-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: lguest: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/page_tables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/lguest/page_tables.c~lguest-rename-random32-to-prandom_u32 drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c~lguest-rename-random32-to-prandom_u32
+++ a/drivers/lguest/page_tables.c
@@ -710,7 +710,7 @@ static unsigned int new_pgdir(struct lg_
 	 * We pick one entry at random to throw out.  Choosing the Least
 	 * Recently Used might be better, but this is easy.
 	 */
-	next = random32() % ARRAY_SIZE(cpu->lg->pgdirs);
+	next = prandom_u32() % ARRAY_SIZE(cpu->lg->pgdirs);
 	/* If it's never been allocated at all before, try now. */
 	if (!cpu->lg->pgdirs[next].pgdir) {
 		cpu->lg->pgdirs[next].pgdir =
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

