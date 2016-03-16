From: akpm@linux-foundation.org
Subject: [merged] slub-fix-clean-free_debug_processing-return-paths.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:55:01 -0700
Message-ID: <56e9ba15.R4Ch4w2NhS3fyZaj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934390AbcCPTzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, cl@linux.com, js1304@gmail.com, keescook@chromium.org, minipli@googlemail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix/clean free_debug_processing return paths
has been removed from the -mm tree.  Its filename was
     slub-fix-clean-free_debug_processing-return-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <labbott@fedoraproject.org>
Subject: slub: fix/clean free_debug_processing return paths

Since 19c7ff9ecd89 ("slub: Take node lock during object free checks")
check_object has been incorrectly returning success as it follows the out
label which just returns the node.  Thanks to refactoring, the out and
fail paths are now basically the same.  Combine the two into one and just
use a single label.

Credit to Mathias Krause for the original work which inspired this series

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-fix-clean-free_debug_processing-return-paths mm/slub.c
--- a/mm/slub.c~slub-fix-clean-free_debug_processing-return-paths
+++ a/mm/slub.c
@@ -1053,24 +1053,25 @@ static noinline int free_debug_processin
 	void *object = head;
 	int cnt = 0;
 	unsigned long uninitialized_var(flags);
+	int ret = 0;
 
 	spin_lock_irqsave(&n->list_lock, flags);
 	slab_lock(page);
 
 	if (!check_slab(s, page))
-		goto fail;
+		goto out;
 
 next_object:
 	cnt++;
 
 	if (!check_valid_pointer(s, page, object)) {
 		slab_err(s, page, "Invalid object pointer 0x%p", object);
-		goto fail;
+		goto out;
 	}
 
 	if (on_freelist(s, page, object)) {
 		object_err(s, page, object, "Object already free");
-		goto fail;
+		goto out;
 	}
 
 	if (!check_object(s, page, object, SLUB_RED_ACTIVE))
@@ -1087,7 +1088,7 @@ next_object:
 		} else
 			object_err(s, page, object,
 					"page slab pointer corrupt.");
-		goto fail;
+		goto out;
 	}
 
 	if (s->flags & SLAB_STORE_USER)
@@ -1101,6 +1102,8 @@ next_object:
 		object = get_freepointer(s, object);
 		goto next_object;
 	}
+	ret = 1;
+
 out:
 	if (cnt != bulk_cnt)
 		slab_err(s, page, "Bulk freelist count(%d) invalid(%d)\n",
@@ -1108,13 +1111,9 @@ out:
 
 	slab_unlock(page);
 	spin_unlock_irqrestore(&n->list_lock, flags);
-	return 1;
