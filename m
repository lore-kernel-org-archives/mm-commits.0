From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-add-missing-annotation-for-pin_tag.patch removed from -mm tree
Date: Tue, 07 Apr 2020 18:59:50 -0700
Message-ID: <20200408015950.49Iu-pHEB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: add missing annotation for pin_tag()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-missing-annotation-for-pin_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/zsmalloc: add missing annotation for pin_tag()

Sparse reports a warning at pin_tag()()

warning: context imbalance in pin_tag() - wrong count at exit

The root cause is the missing annotation at pin_tag()
Add the missing __acquires(bitlock) annotation

Link: http://lkml.kernel.org/r/20200214204741.94112-13-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-missing-annotation-for-pin_tag
+++ a/mm/zsmalloc.c
@@ -891,7 +891,7 @@ static inline int trypin_tag(unsigned lo
 	return bit_spin_trylock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
 
-static void pin_tag(unsigned long handle)
+static void pin_tag(unsigned long handle) __acquires(bitlock)
 {
 	bit_spin_lock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
_

Patches currently in -mm which might be from jbi.octave@gmail.com are
