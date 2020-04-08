From: akpm@linux-foundation.org
Subject: [merged] mm-slub-add-missing-annotation-for-get_map.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:59:42 -0700
Message-ID: <20200408015942.ajZb5GzrK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: add missing annotation for get_map()
has been removed from the -mm tree.  Its filename was
     mm-slub-add-missing-annotation-for-get_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/slub: add missing annotation for get_map()

Sparse reports a warning at get_map()()

 warning: context imbalance in get_map() - wrong count at exit

The root cause is the missing annotation at get_map()
Add the missing __acquires(&object_map_lock) annotation

Link: http://lkml.kernel.org/r/20200214204741.94112-9-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~mm-slub-add-missing-annotation-for-get_map
+++ a/mm/slub.c
@@ -449,6 +449,7 @@ static DEFINE_SPINLOCK(object_map_lock);
  * not vanish from under us.
  */
 static unsigned long *get_map(struct kmem_cache *s, struct page *page)
+	__acquires(&object_map_lock)
 {
 	void *p;
 	void *addr = page_address(page);
_

Patches currently in -mm which might be from jbi.octave@gmail.com are
