From: akpm@linux-foundation.org
Subject: + slab-introduce-kzfree.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:22:27 -0800
Message-ID: <200902192022.n1JKMRkV020502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbZBSUXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:23:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, cl@linux-foundation.org, mpm@selenic.com, npiggin@suse.de, penberg@cs.helsinki.fi


The patch titled
     slab: introduce kzfree()
has been added to the -mm tree.  Its filename is
     slab-introduce-kzfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slab: introduce kzfree()
From: Johannes Weiner <hannes@cmpxchg.org>

kzfree() is a wrapper for kfree() that additionally zeroes the underlying
memory before releasing it to the slab allocator.

Currently there is code which memset()s the memory region of an object
before releasing it back to the slab allocator to make sure
security-sensitive data are really zeroed out after use.

These callsites can then just use kzfree() which saves some code, makes
users greppable and allows for a stupid destructor that isn't necessarily
aware of the actual object size.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    1 +
 mm/util.c            |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff -puN include/linux/slab.h~slab-introduce-kzfree include/linux/slab.h
--- a/include/linux/slab.h~slab-introduce-kzfree
+++ a/include/linux/slab.h
@@ -127,6 +127,7 @@ int kmem_ptr_validate(struct kmem_cache 
 void * __must_check __krealloc(const void *, size_t, gfp_t);
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
+void kzfree(const void *);
 size_t ksize(const void *);
 
 /*
diff -puN mm/util.c~slab-introduce-kzfree mm/util.c
--- a/mm/util.c~slab-introduce-kzfree
+++ a/mm/util.c
@@ -129,6 +129,26 @@ void *krealloc(const void *p, size_t new
 }
 EXPORT_SYMBOL(krealloc);
 
+/**
+ * kzfree - like kfree but zero memory
+ * @p: object to free memory of
+ *
+ * The memory of the object @p points to is zeroed before freed.
+ * If @p is %NULL, kzfree() does nothing.
+ */
+void kzfree(const void *p)
+{
+	size_t ks;
+	void *mem = (void *)p;
+
+	if (unlikely(ZERO_OR_NULL_PTR(mem)))
+		return;
+	ks = ksize(mem);
+	memset(mem, 0, ks);
+	kfree(mem);
+}
+EXPORT_SYMBOL(kzfree);
+
 /*
  * strndup_user - duplicate an existing string from user space
  * @s: The string to duplicate
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

slab-introduce-kzfree.patch
linux-next.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
crypto-use-kzfree.patch
s390-use-kzfree.patch
md-use-kzfree.patch
usb-use-kzfree.patch
cifs-use-kzfree.patch
ecryptfs-use-kzfree.patch

