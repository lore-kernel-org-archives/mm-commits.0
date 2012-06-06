From: akpm@linux-foundation.org
Subject: [merged] radix-tree-fix-contiguous-iterator.patch removed from -mm tree
Date: Wed, 06 Jun 2012 12:31:32 -0700
Message-ID: <20120606193132.6C195A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45147 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab2FFTbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 15:31:34 -0400
Received: by eeit10 with SMTP id t10so425862eei.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 12:31:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, jmdebruin@xmsnet.nl, linux@rainbow-software.org, stable@vger.kernel.org, toralf.foerster@gmx.de, mm-commits@vger.kernel.org


The patch titled
     From: Konstantin Khlebnikov <khlebnikov@openvz.org>
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-contiguous-iterator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: fix contiguous iterator
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Fix a bug in the macro radix_tree_for_each_contig().

If radix_tree_next_slot() sees NULL in next slot it returns NULL, but
following radix_tree_next_chunk() switches iterating into next chunk.  As
result iterating becomes non-contiguous and breaks vfs "splice" and all
its users.

More details at https://lkml.org/lkml/2012/6/5/64

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Hans de Bruin <jmdebruin@xmsnet.nl>
Reported-by: Ondrej Zary <linux@rainbow-software.org>
Reported-by: Toralf Foerster <toralf.foerster@gmx.de>
Cc: <stable@vger.kernel.org>	[3.4.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    5 ++++-
 lib/radix-tree.c           |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/radix-tree.h~radix-tree-fix-contiguous-iterator include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-fix-contiguous-iterator
+++ a/include/linux/radix-tree.h
@@ -368,8 +368,11 @@ radix_tree_next_slot(void **slot, struct
 			iter->index++;
 			if (likely(*slot))
 				return slot;
-			if (flags & RADIX_TREE_ITER_CONTIG)
+			if (flags & RADIX_TREE_ITER_CONTIG) {
+				/* forbid switching to the next chunk */
+				iter->next_index = 0;
 				break;
+			}
 		}
 	}
 	return NULL;
diff -puN lib/radix-tree.c~radix-tree-fix-contiguous-iterator lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-contiguous-iterator
+++ a/lib/radix-tree.c
@@ -686,6 +686,9 @@ void **radix_tree_next_chunk(struct radi
 	 * during iterating; it can be zero only at the beginning.
 	 * And we cannot overflow iter->next_index in a single step,
 	 * because RADIX_TREE_MAP_SHIFT < BITS_PER_LONG.
+	 *
+	 * This condition also used by radix_tree_next_slot() to stop
+	 * contiguous iterating, and forbid swithing to the next chunk.
 	 */
 	index = iter->next_index;
 	if (!index && iter->index)
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

