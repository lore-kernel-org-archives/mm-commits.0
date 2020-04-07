From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 080/166] mm/slub: add missing annotation for
 get_map()
Date: Mon, 06 Apr 2020 20:08:15 -0700
Message-ID: <20200407030815.CUbQRG4HZ%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:17 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
