From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 067/128] mm/swapfile.c: tmp is always smaller than
 max
Date: Mon, 01 Jun 2020 21:49:04 -0700
Message-ID: <20200602044904.fyOLUkFKg%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEtF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:49:05 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: tmp is always smaller than max

If tmp is bigger or equal to max, we would jump to new_cluster.

Return true directly.

Link: http://lkml.kernel.org/r/20200421213824.8099-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-tmp-is-always-smaller-than-max
+++ a/mm/swapfile.c
@@ -647,7 +647,7 @@ new_cluster:
 	cluster->next = tmp + 1;
 	*offset = tmp;
 	*scan_base = tmp;
-	return tmp < max;
+	return true;
 }
 
 static void __del_from_avail_list(struct swap_info_struct *p)
_
