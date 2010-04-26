From: akpm@linux-foundation.org
Subject: [merged] flex_array-fix-the-panic-when-calling-flex_array_alloc-without-__gfp_zero.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:26:10 -0400
Message-ID: <201004261727.o3QHRidI009051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab0DZR1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaosuo@gmail.com, kaber@trash.net, rientjes@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     flex_array: fix the panic when calling flex_array_alloc() without __GFP_ZERO
has been removed from the -mm tree.  Its filename was
     flex_array-fix-the-panic-when-calling-flex_array_alloc-without-__gfp_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: fix the panic when calling flex_array_alloc() without __GFP_ZERO
From: Changli Gao <xiaosuo@gmail.com>

memset() is called with the wrong address and the kernel panics.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/flex_array.c~flex_array-fix-the-panic-when-calling-flex_array_alloc-without-__gfp_zero lib/flex_array.c
--- a/lib/flex_array.c~flex_array-fix-the-panic-when-calling-flex_array_alloc-without-__gfp_zero
+++ a/lib/flex_array.c
@@ -99,7 +99,7 @@ struct flex_array *flex_array_alloc(int 
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
-		memset(ret->parts[0], FLEX_ARRAY_FREE,
+		memset(&ret->parts[0], FLEX_ARRAY_FREE,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }
_

Patches currently in -mm which might be from xiaosuo@gmail.com are

origin.patch
linux-next.patch

