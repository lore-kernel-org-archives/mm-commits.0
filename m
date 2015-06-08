From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch added to -mm tree
Date: Mon, 08 Jun 2015 14:50:59 -0700
Message-ID: <55760e43.9lYQuARJcHIdA6Z0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbbFHVvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2015 17:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: avoid deadlock on the kmemleak object insertion error path
has been added to the -mm tree.  Its filename is
     mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch
mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block.patch
mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch
mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch
linux-next.patch

