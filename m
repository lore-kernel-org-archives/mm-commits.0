From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:22 -0700
Message-ID: <5591acfa.OfPANcTTPH7iKkkI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbbF2UjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: avoid deadlock on the kmemleak object insertion error path
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: avoid deadlock on the kmemleak object insertion error path

While very unlikely (usually kmemleak or sl*b bug), the create_object()
function in mm/kmemleak.c may fail to insert a newly allocated object into
the rb tree.  When this happens, kmemleak disables itself and prints
additional information about the object already found in the rb tree. 
Such printing is done with the parent->lock acquired, however the
kmemleak_lock is already held.  This is a potential race with the scanning
thread which acquires object->lock and kmemleak_lock in a

This patch removes the locking around the 'parent' object information
printing.  Such object cannot be freed or removed from object_tree_root
and object_list since kmemleak_lock is already held.  There is a very
small risk that some of the object data is being modified on another CPU
but the only downside is inconsistent information printing.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path
+++ a/mm/kmemleak.c
@@ -53,6 +53,11 @@
  *   modifications to the memory scanning parameters including the scan_thread
  *   pointer
  *
+ * Locks and mutexes should only be acquired/nested in the following order:
+ *
+ *   scan_mutex -> object->lock -> other_object->lock (SINGLE_DEPTH_NESTING)
+ *				-> kmemleak_lock
+ *
  * The kmemleak_object structures have a use_count incremented or decremented
  * using the get_object()/put_object() functions. When the use_count becomes
  * 0, this count can no longer be incremented and put_object() schedules the
@@ -603,11 +608,13 @@ static struct kmemleak_object *create_ob
 			kmemleak_stop("Cannot insert 0x%lx into the object "
 				      "search tree (overlaps existing)\n",
 				      ptr);
+			/*
+			 * No need for parent->lock here since "parent" cannot
+			 * be freed while the kmemleak_lock is held.
+			 */
+			dump_object_info(parent);
 			kmem_cache_free(object_cache, object);
-			object = parent;
-			spin_lock(&object->lock);
-			dump_object_info(object);
-			spin_unlock(&object->lock);
+			object = NULL;
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

