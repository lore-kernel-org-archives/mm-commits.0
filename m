From: akpm@linux-foundation.org
Subject: + drivers-char-randomcwrite_pool-cond_resched-needed.patch added to -mm tree
Date: Mon, 03 Dec 2007 11:40:40 -0800
Message-ID: <200712031940.lB3Jee7i014728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45318 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbXLCTlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 14:41:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, safari-kernel@safari.iki.fi, tytso@mit.edu


The patch titled
     drivers/char/random.c:write_pool() cond_resched() needed
has been added to the -mm tree.  Its filename is
     drivers-char-randomcwrite_pool-cond_resched-needed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/random.c:write_pool() cond_resched() needed
From: Matt Mackall <mpm@selenic.com>

Reduce latency for large writes to /dev/[u]random

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Sami Farin <safari-kernel@safari.iki.fi>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/random.c~drivers-char-randomcwrite_pool-cond_resched-needed drivers/char/random.c
--- a/drivers/char/random.c~drivers-char-randomcwrite_pool-cond_resched-needed
+++ a/drivers/char/random.c
@@ -1041,6 +1041,7 @@ write_pool(struct entropy_store *r, cons
 		p += bytes;
 
 		add_entropy_words(r, buf, (bytes + 3) / 4);
+		cond_resched();
 	}
 
 	return 0;
_

Patches currently in -mm which might be from mpm@selenic.com are

maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
remove-unused-code-from-mm-tiny-shmemc.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
