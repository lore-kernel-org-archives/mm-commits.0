Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E73B2147E5
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 20:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779396935; cv=none; b=sp3nRoKJ4JP3hphtz9te01zREeKJq6lVc3Zwy+olayse3atP0++fknR8Qnwn3RWrp/lxv0wbcfidnBGQfg7RcDpEwCIMT7CwWuyRFbIAdI/SVg/AMjOCCH1KD4Vvnhfa9vwg2ItS1xHO41IobskGhVmlXk7DUjo7GsOJUkrSDxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779396935; c=relaxed/simple;
	bh=wX80OXn0P6hGbA4hcSGc9GgJ16F9Pgs9owFJoBIz1nI=;
	h=Date:To:From:Subject:Message-Id; b=PQ4XX8uNl+Ip4QJg7a75chk5Rxynsz51IsomSpGDC8JYQi0PufX51787rtOpOJE2WGM66cl1WNxfdNA7tImrOv7jCWEddU+b6ZL6JSO2GNKyPykx+74+TDPfjg8T7we6QuJrft6W5cfK8rvA/+mj/revRxc2Iw9KPjSYvw1DPIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmDyW87x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmDyW87x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C474A1F000E9;
	Thu, 21 May 2026 20:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779396933;
	bh=gnM//Y4yK9RBiA941tnJ28fhzCsATlRPNhVNwgTeB3w=;
	h=Date:To:From:Subject;
	b=gmDyW87xfP6G+HywzLFUghWozoFZsu8NyipzKBADq/PTVfSSSD1ZbhjwF9MLzXDEl
	 TzqUdCmqVbLmj/NO632DJSZ1QtgSVhKbEQILa0o3+lLsSUi14ooTHvqpotLmcNyQYW
	 Wz3/BtvmvWz55b4cSBvv75cyj/MK0VLrnJUdK6nY=
Date: Thu, 21 May 2026 13:55:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,harry@kernel.org,elver@google.com,david@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-util-use-kmalloc-buckets-for-kmemdup_nul.patch removed from -mm tree
Message-Id: <20260521205533.C474A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/util: use kmalloc buckets for kmemdup_nul()
has been removed from the -mm tree.  Its filename was
     mm-util-use-kmalloc-buckets-for-kmemdup_nul.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kees Cook <kees@kernel.org>
Subject: mm/util: use kmalloc buckets for kmemdup_nul()
Date: Thu, 21 May 2026 05:40:31 -0700

The use of the kmemdup_nul()-family of allocations are explicitly for
allocating NUL terminated strings, so these would be best separated from
typed allocations, as they are their own set of arbitrarily sized
allocations.  They are not as risky as userspace controlled allocations,
but these would be good to separate as well.

  # grep memdup_nul /proc/slabinfo | cut -c-25
  memdup_nul-8k          0
  memdup_nul-4k          0
  memdup_nul-2k          0
  memdup_nul-1k          0
  memdup_nul-512        28
  memdup_nul-256         0
  memdup_nul-192        60
  memdup_nul-128        60
  memdup_nul-96         60
  memdup_nul-64        180
  memdup_nul-32        960
  memdup_nul-16       1860
  memdup_nul-8        1980

Link: https://lore.kernel.org/20260521124026.work.036-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Suggested-by: Harry Yoo <harry@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/util.c~mm-util-use-kmalloc-buckets-for-kmemdup_nul
+++ a/mm/util.c
@@ -34,6 +34,9 @@
 #include "internal.h"
 #include "swap.h"
 
+static kmem_buckets *user_buckets __ro_after_init;
+static kmem_buckets *nul_buckets __ro_after_init;
+
 /**
  * kfree_const - conditionally free memory
  * @x: pointer to the memory
@@ -61,7 +64,7 @@ static __always_inline char *__kmemdup_n
 	char *buf;
 
 	/* '+1' for the NUL terminator */
-	buf = kmalloc_track_caller(len + 1, gfp);
+	buf = kmem_buckets_alloc_track_caller(nul_buckets, len + 1, gfp);
 	if (!buf)
 		return NULL;
 
@@ -195,15 +198,14 @@ char *kmemdup_nul(const char *s, size_t
 }
 EXPORT_SYMBOL(kmemdup_nul);
 
-static kmem_buckets *user_buckets __ro_after_init;
-
-static int __init init_user_buckets(void)
+static int __init init_buckets(void)
 {
 	user_buckets = kmem_buckets_create("memdup_user", 0, 0, INT_MAX, NULL);
+	nul_buckets = kmem_buckets_create("memdup_nul", 0, 0, INT_MAX, NULL);
 
 	return 0;
 }
-subsys_initcall(init_user_buckets);
+subsys_initcall(init_buckets);
 
 /**
  * memdup_user - duplicate memory region from user space
_

Patches currently in -mm which might be from kees@kernel.org are


