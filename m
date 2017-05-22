From: akpm@linux-foundation.org
Subject: + slub-memcg-cure-the-brainless-abuse-of-sysfs-attributes.patch
 added to -mm tree
Date: Mon, 22 May 2017 14:29:13 -0700
Message-ID: <59235829.857lif7PfkONEiWH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933607AbdEVV3P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2017 17:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, cl@linux.com, hannes@cmpxchg.org, hch@infradead.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, peterz@infradead.org, rientjes@google.com, rostedt@goodmis.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slub/memcg: cure the brainless abuse of sysfs attributes
has been added to the -mm tree.  Its filename is
     slub-memcg-cure-the-brainless-abuse-of-sysfs-attributes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-memcg-cure-the-brainless-abuse-of-sysfs-attributes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-memcg-cure-the-brainless-abuse-of-sysfs-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: slub/memcg: cure the brainless abuse of sysfs attributes

memcg_propagate_slab_attrs() abuses the sysfs attribute file functions to
propagate settings from the root kmem_cache to a newly created kmem_cache.
It does that with:

     attr->show(root, buf);
     attr->store(new, buf, strlen(bug);

Aside of being a lazy and absurd hackery this is broken because it does
not check the return value of the show() function.

Some of the show() functions return 0 w/o touching the buffer.  That means
in such a case the store function is called with the stale content of the
previous show().  That causes nonsense like invoking kmem_cache_shrink()
on a newly created kmem_cache.  In the worst case it would cause handing
in an uninitialized buffer.

This should be rewritten proper by adding a propagate() callback to those
slub_attributes which must be propagated and avoid that insane conversion
to and from ASCII, but that's too large for a hot fix.

Check at least the return value of the show() function, so calling store()
with stale content is prevented.

Steven said:

: It can cause a deadlock with get_online_cpus() that has been uncovered
: by recent cpu hotplug and lockdep changes that Thomas and Peter have
: been doing.
: 
: [  102.567308]  Possible unsafe locking scenario:
: [  102.567308] 
: [  102.574846]        CPU0                    CPU1
: [  102.580148]        ----                    ----
: [  102.585421]   lock(cpu_hotplug.lock);
: [  102.589808]                                lock(slab_mutex);
: [  102.596166]                                lock(cpu_hotplug.lock);
: [  102.603028]   lock(slab_mutex);
: [  102.606846] 
: [  102.606846]  *** DEADLOCK ***

Link: http://lkml.kernel.org/r/alpine.DEB.2.20.1705201244540.2255@nanos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-memcg-cure-the-brainless-abuse-of-sysfs-attributes mm/slub.c
--- a/mm/slub.c~slub-memcg-cure-the-brainless-abuse-of-sysfs-attributes
+++ a/mm/slub.c
@@ -5512,6 +5512,7 @@ static void memcg_propagate_slab_attrs(s
 		char mbuf[64];
 		char *buf;
 		struct slab_attribute *attr = to_slab_attr(slab_attrs[i]);
+		ssize_t len;
 
 		if (!attr || !attr->store || !attr->show)
 			continue;
@@ -5536,8 +5537,9 @@ static void memcg_propagate_slab_attrs(s
 			buf = buffer;
 		}
 
-		attr->show(root_cache, buf);
-		attr->store(s, buf, strlen(buf));
+		len = attr->show(root_cache, buf);
+		if (len > 0)
+			attr->store(s, buf, len);
 	}
 
 	if (buffer)
_

Patches currently in -mm which might be from tglx@linutronix.de are

slub-memcg-cure-the-brainless-abuse-of-sysfs-attributes.patch

