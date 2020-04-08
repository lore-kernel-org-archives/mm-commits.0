From: akpm@linux-foundation.org
Subject: [merged] mm-slub-add-missing-annotation-for-put_map.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:59:44 -0700
Message-ID: <20200408015944.unGcMjLv0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: add missing annotation for put_map()
has been removed from the -mm tree.  Its filename was
     mm-slub-add-missing-annotation-for-put_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/slub: add missing annotation for put_map()

Sparse reports a warning at put_map()()

 warning: context imbalance in put_map() - unexpected unlock

The root cause is the missing annotation at put_map()
Add the missing __releases(&object_map_lock) annotation

Link: http://lkml.kernel.org/r/20200214204741.94112-10-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-add-missing-annotation-for-put_map
+++ a/mm/slub.c
@@ -466,7 +466,7 @@ static unsigned long *get_map(struct kme
 	return object_map;
 }
 
-static void put_map(unsigned long *map)
+static void put_map(unsigned long *map) __releases(&object_map_lock)
 {
 	VM_BUG_ON(map != object_map);
 	lockdep_assert_held(&object_map_lock);
_

Patches currently in -mm which might be from jbi.octave@gmail.com are
