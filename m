From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-add-missing-annotation-for-unpin_tag.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 18:59:52 -0700
Message-ID: <20200408015952.cGqCOyh_x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgDHB7x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: add missing annotation for unpin_tag()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-missing-annotation-for-unpin_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/zsmalloc: add missing annotation for unpin_tag()

Sparse reports a warning at unpin_tag()()

warning: context imbalance in unpin_tag() - unexpected unlock

The root cause is the missing annotation at unpin_tag()
Add the missing __releases(bitlock) annotation

Link: http://lkml.kernel.org/r/20200214204741.94112-14-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-missing-annotation-for-unpin_tag
+++ a/mm/zsmalloc.c
@@ -896,7 +896,7 @@ static void pin_tag(unsigned long handle
 	bit_spin_lock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
 
-static void unpin_tag(unsigned long handle)
+static void unpin_tag(unsigned long handle) __releases(bitlock)
 {
 	bit_spin_unlock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
_

Patches currently in -mm which might be from jbi.octave@gmail.com are
