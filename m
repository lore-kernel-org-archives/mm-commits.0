From: akpm@linux-foundation.org
Subject: [merged] slub-disable-tracing-and-failslab-for-merged-slabs.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:42 -0700
Message-ID: <543c1782.sW5hlwZox+x0yrH8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, chaowang@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: disable tracing and failslab for merged slabs
has been removed from the -mm tree.  Its filename was
     slub-disable-tracing-and-failslab-for-merged-slabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: disable tracing and failslab for merged slabs

Tracing of mergeable slabs as well as uses of failslab are confusing since
the objects of multiple slab caches will be affected.  Moreover this
creates a situation where a mergeable slab will become unmergeable.

If tracing or failslab testing is desired then it may be best to switch
merging off for starters.

Signed-off-by: Christoph Lameter <cl@linux.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/slub.c~slub-disable-tracing-and-failslab-for-merged-slabs mm/slub.c
--- a/mm/slub.c~slub-disable-tracing-and-failslab-for-merged-slabs
+++ a/mm/slub.c
@@ -4604,6 +4604,14 @@ static ssize_t trace_show(struct kmem_ca
 static ssize_t trace_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
+	/*
+	 * Tracing a merged cache is going to give confusing results
+	 * as well as cause other issues like converting a mergeable
+	 * cache into an umergeable one.
+	 */
+	if (s->refcount > 1)
+		return -EINVAL;
+
 	s->flags &= ~SLAB_TRACE;
 	if (buf[0] == '1') {
 		s->flags &= ~__CMPXCHG_DOUBLE;
@@ -4721,6 +4729,9 @@ static ssize_t failslab_show(struct kmem
 static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
+	if (s->refcount > 1)
+		return -EINVAL;
+
 	s->flags &= ~SLAB_FAILSLAB;
 	if (buf[0] == '1')
 		s->flags |= SLAB_FAILSLAB;
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
linux-next.patch

