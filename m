From: akpm@linux-foundation.org
Subject: - drivers-char-randomcwrite_pool-cond_resched-needed.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:31 -0800
Message-ID: <200802070023.m170NCo6006503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935134AbYBGApx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, safari-kernel@safari.iki.fi, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     drivers/char/random.c:write_pool() cond_resched() needed
has been removed from the -mm tree.  Its filename was
     drivers-char-randomcwrite_pool-cond_resched-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1039,6 +1039,7 @@ write_pool(struct entropy_store *r, cons
 		p += bytes;
 
 		add_entropy_words(r, buf, (bytes + 3) / 4);
+		cond_resched();
 	}
 
 	return 0;
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch
