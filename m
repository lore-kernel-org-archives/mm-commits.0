From: akpm@linux-foundation.org
Subject: +
 slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path.patch added to
 -mm tree
Date: Fri, 24 Jan 2014 13:21:03 -0800
Message-ID: <52e2d93f./e5KUCaMrHfO4DDj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaAXVVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 16:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, penberg@kernel.org, cl@linux.com, davej@redhat.com

Subject: + slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path.patch added to -mm tree
To: davej@redhat.com,cl@linux.com,penberg@kernel.org,vdavydov@parallels.com
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 13:21:03 -0800


The patch titled
     Subject: slab: fix wrong retval on kmem_cache_create_memcg error path
has been added to the -mm tree.  Its filename is
     slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
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
            ...
            return NULL;
        }
        return s;

Recently this check was, in fact, broken by commit f717eb3abb5e ("slab: do
not panic if we fail to create memcg cache"), which turned it to:

    out_unlock:
        ...
        if (err && !memcg) {
            ...
            return NULL;
        }
        return s;

As a result, if we are failing creating a cache for a memcg, we will skip
the check and return 's' that can contain crap.  Let's fix it by assuring
that on error path there are always two conditions satisfied at the same
time, err != 0 and s == NULL, by explicitly zeroing 's' after freeing it
on error path.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab_common.c~slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path mm/slab_common.c
--- a/mm/slab_common.c~slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path
+++ a/mm/slab_common.c
@@ -249,7 +249,6 @@ out_unlock:
 				name, err);
 			dump_stack();
 		}
-		return NULL;
 	}
 	return s;
 
@@ -257,6 +256,7 @@ out_free_cache:
 	memcg_free_cache_params(s);
 	kfree(s->name);
 	kmem_cache_free(kmem_cache, s);
+	s = NULL;
 	goto out_unlock;
 }
 
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path.patch

