From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 085/166] mm/zsmalloc: add missing annotation for
 unpin_tag()
Date: Mon, 06 Apr 2020 20:08:30 -0700
Message-ID: <20200407030830.0JgKhSCO7%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:32 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
