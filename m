From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 081/166] mm/slub: add missing annotation for
 put_map()
Date: Mon, 06 Apr 2020 20:08:18 -0700
Message-ID: <20200407030818.1tudKUU19%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:19 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
