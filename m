From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 054/155] mm/swap.c: not necessary to export
 __pagevec_lru_add()
Date: Wed, 01 Apr 2020 21:06:10 -0700
Message-ID: <20200402040610._WtnFXXEt%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEGN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:13 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, torvalds@linux-foundation.org

From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/swap.c: not necessary to export __pagevec_lru_add()

__pagevec_lru_add() is only used in mm directory now.

Remove the export symbol.

Link: http://lkml.kernel.org/r/20200126011436.22979-1-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swap.c~mm-swapc-not-necessary-to-export-__pagevec_lru_add
+++ a/mm/swap.c
@@ -986,7 +986,6 @@ void __pagevec_lru_add(struct pagevec *p
 {
 	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, NULL);
 }
-EXPORT_SYMBOL(__pagevec_lru_add);
 
 /**
  * pagevec_lookup_entries - gang pagecache lookup
_
