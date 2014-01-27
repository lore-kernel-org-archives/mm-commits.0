From: akpm@linux-foundation.org
Subject: +
 slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch added
 to -mm tree
Date: Mon, 27 Jan 2014 15:02:40 -0800
Message-ID: <52e6e590.zV0du0nGWHx4UfWl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaA0XCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 18:02:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, penberg@kernel.org, davej@redhat.com, cl@linux.com, rientjes@google.com

Subject: + slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch added to -mm tree
To: rientjes@google.com,cl@linux.com,davej@redhat.com,penberg@kernel.org,vdavydov@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 15:02:40 -0800


The patch titled
     Subject: slab: fix wrong retval on kmem_cache_create_memcg error path
has been added to the -mm tree.  Its filename is
     slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: slab: fix wrong retval on kmem_cache_create_memcg error path

On kmem_cache_create_memcg() error path we set 'err', but leave 's' (the
new cache ptr) undefined.  The latter can be NULL if we could not allocate
the cache, or pointing to a freed area if we failed somewhere later while
trying to initialize it.  Initially we checked 'err' immediately before
exiting the function and returned NULL if it was set ignoring the value of
's':

    out_unlock:
        ...
        if (err) {
            /* report error */
            return NULL;
        }
        return s;

Recently this check was, in fact, broken by commit f717eb3abb5e ("slab: do
not panic if we fail to create memcg cache"), which turned it to:

    out_unlock:
        ...
        if (err && !memcg) {
            /* report error */
            return NULL;
        }
        return s;

As a result, if we are failing creating a cache for a memcg, we will skip
the check and return 's' that can contain crap.  Obviously, commit
f717eb3abb5e intended not to return crap on error allocating a cache for a
memcg, but only to remove the error reporting in this case, so the check
should look like this:

    out_unlock:
        ...
        if (err) {
            if (!memcg)
                return NULL;
            /* report error */
            return NULL;
        }
        return s;

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/slab_common.c~slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2 mm/slab_common.c
--- a/mm/slab_common.c~slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2
+++ a/mm/slab_common.c
@@ -233,14 +233,17 @@ out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-	/*
-	 * There is no point in flooding logs with warnings or especially
-	 * crashing the system if we fail to create a cache for a memcg. In
-	 * this case we will be accounting the memcg allocation to the root
-	 * cgroup until we succeed to create its own cache, but it isn't that
-	 * critical.
-	 */
-	if (err && !memcg) {
+	if (err) {
+		/*
+		 * There is no point in flooding logs with warnings or
+		 * especially crashing the system if we fail to create a cache
+		 * for a memcg. In this case we will be accounting the memcg
+		 * allocation to the root cgroup until we succeed to create its
+		 * own cache, but it isn't that critical.
+		 */
+		if (!memcg)
+			return NULL;
+
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch
firmware-google-drop-select-efi-to-avoid-recursive-dependency.patch

