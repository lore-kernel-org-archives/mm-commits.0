From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 084/166] mm/zsmalloc: add missing annotation for
 pin_tag()
Date: Mon, 06 Apr 2020 20:08:27 -0700
Message-ID: <20200407030827.mri3fLcph%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDI3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:29 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
