From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 114/155] mm/page_alloc: increase default
 min_free_kbytes bound
Date: Wed, 01 Apr 2020 21:09:44 -0700
Message-ID: <20200402040944.GNLbwZ9bh%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEJp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:45 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, jsavitz@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joel Savitz <jsavitz@redhat.com>
Subject: mm/page_alloc: increase default min_free_kbytes bound

Currently, the vm.min_free_kbytes sysctl value is capped at a hardcoded
64M in init_per_zone_wmark_min (unless it is overridden by khugepaged
initialization).

This value has not been modified since 2005, and enterprise-grade systems
now frequently have hundreds of GB of RAM and multiple 10, 40, or even 100
GB NICs.  We have seen page allocation failures on heavily loaded systems
related to NIC drivers.  These issues were resolved by an increase to
vm.min_free_kbytes.

This patch increases the hardcoded value by a factor of 4 as a temporary
solution.

Further work to make the calculation of vm.min_free_kbytes more consistent
throughout the kernel would be desirable.

As an example of the inconsistency of the current method, this value is
recalculated by init_per_zone_wmark_min() in the case of memory hotplug
which will override the value set by set_recommended_min_free_kbytes()
called during khugepaged initialization even if khugepaged remains
enabled, however an on/off toggle of khugepaged will then recalculate and
set the value via set_recommended_min_free_kbytes().

Link: http://lkml.kernel.org/r/20200220150103.5183-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-increase-default-min_free_kbytes-bound
+++ a/mm/page_alloc.c
@@ -7868,8 +7868,8 @@ int __meminit init_per_zone_wmark_min(vo
 		min_free_kbytes = new_min_free_kbytes;
 		if (min_free_kbytes < 128)
 			min_free_kbytes = 128;
-		if (min_free_kbytes > 65536)
-			min_free_kbytes = 65536;
+		if (min_free_kbytes > 262144)
+			min_free_kbytes = 262144;
 	} else {
 		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
 				new_min_free_kbytes, user_min_free_kbytes);
_
