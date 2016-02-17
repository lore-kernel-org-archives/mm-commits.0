From: akpm@linux-foundation.org
Subject: + slub-fix-clean-free_debug_processing-return-paths.patch added
 to -mm tree
Date: Wed, 17 Feb 2016 12:05:02 -0800
Message-ID: <56c4d26e.9CY8zDBcSDPPCgwS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbcBQUFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 15:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, cl@linux.com, js1304@gmail.com, keescook@chromium.org, minipli@googlemail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix/clean free_debug_processing return paths
has been added to the -mm tree.  Its filename is
     slub-fix-clean-free_debug_processing-return-paths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-fix-clean-free_debug_processing-return-paths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-fix-clean-free_debug_processing-return-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
