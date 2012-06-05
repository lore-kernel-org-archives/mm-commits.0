From: akpm@linux-foundation.org
Subject: + radix-tree-fix-contiguous-iterator.patch added to -mm tree
Date: Tue, 05 Jun 2012 13:48:55 -0700
Message-ID: <20120605204855.AF74FA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57248 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2FEUs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 16:48:57 -0400
Received: by bkty5 with SMTP id y5so353542bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 13:48:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, jmdebruin@xmsnet.nl, linux@rainbow-software.org, stable@vger.kernel.org, toralf.foerster@gmx.de


The patch titled
     From: Konstantin Khlebnikov <khlebnikov@openvz.org>
has been added to the -mm tree.  Its filename is
     radix-tree-fix-contiguous-iterator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: radix-tree: fix contiguous iterator

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
Subject: From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
radix-tree-fix-contiguous-iterator.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

