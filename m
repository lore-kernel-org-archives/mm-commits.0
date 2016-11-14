From: akpm@linux-foundation.org
Subject: [merged] lib-stackdepot-export-save-fetch-stack-for-drivers.patch removed from -mm tree
Date: Mon, 14 Nov 2016 12:03:47 -0800
Message-ID: <582a18a3.yj2b7Nw8KZpmFJ2K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38056 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933969AbcKNUDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 15:03:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, aryabinin@virtuozzo.com, daniel.vetter@ffwll.ch, dvyukov@google.com, glider@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: export save/fetch stack for drivers
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-export-save-fetch-stack-for-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: lib/stackdepot: export save/fetch stack for drivers

Some drivers would like to record stacktraces in order to aide leak
tracing.  As stackdepot already provides a facility for only storing the
unique traces, thereby reducing the memory required, export that
functionality for use by drivers.

The code was originally created for KASAN and moved under lib in commit
cd11016e5f521 ("mm, kasan: stackdepot implementation.  Enable stackdepot
for SLAB") so that it could be shared with mm/.  In turn, we want to share
it now with drivers.

Link: http://lkml.kernel.org/r/20161108133209.22704-1-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/stackdepot.c~lib-stackdepot-export-save-fetch-stack-for-drivers lib/stackdepot.c
--- a/lib/stackdepot.c~lib-stackdepot-export-save-fetch-stack-for-drivers
+++ a/lib/stackdepot.c
@@ -192,6 +192,7 @@ void depot_fetch_stack(depot_stack_handl
 	trace->entries = stack->entries;
 	trace->skip = 0;
 }
+EXPORT_SYMBOL_GPL(depot_fetch_stack);
 
 /**
  * depot_save_stack - save stack in a stack depot.
@@ -283,3 +284,4 @@ exit:
 fast_exit:
 	return retval;
 }
+EXPORT_SYMBOL_GPL(depot_save_stack);
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are


