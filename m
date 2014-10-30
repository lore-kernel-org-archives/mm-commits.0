From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab_common-dont-check-for-duplicate-cache-names.patch removed from -mm
 tree
Date: Thu, 30 Oct 2014 13:27:58 -0700
Message-ID: <54529f4e.n4bUsm3BHvnvRzSP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185AbaJ3U15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpatocka@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: don't check for duplicate cache names
has been removed from the -mm tree.  Its filename was
     mm-slab_common-dont-check-for-duplicate-cache-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mm/slab_common: don't check for duplicate cache names

The SLUB cache merges caches with the same size and alignment and there
was long standing bug with this behavior:
* create the cache named "foo"
* create the cache named "bar" (which is merged with "foo")
* delete the cache named "foo" (but it stays allocated because "bar" uses
  it)
* create the cache named "foo" again - it fails because the name "foo" is
  already used

That bug was fixed in commit 694617474e33b860 ("slab_common: fix the check
for duplicate slab names") by not warning on duplicate cache names when
the SLUB subsystem is used.

Recently, cache merging was implemented the with SLAB subsystem too, in
12220dea07f1a ("mm/slab: support slab merge")).  Therefore we need stop
checking for duplicate names even for the SLAB subsystem.  This patch
fixes the bug by removing the check.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN mm/slab_common.c~mm-slab_common-dont-check-for-duplicate-cache-names mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-dont-check-for-duplicate-cache-names
+++ a/mm/slab_common.c
@@ -93,16 +93,6 @@ static int kmem_cache_sanity_check(const
 			       s->object_size);
 			continue;
 		}
