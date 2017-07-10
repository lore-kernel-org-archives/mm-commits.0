From: akpm@linux-foundation.org
Subject: [patch 060/115] mm: disallow early_pfn_to_nid on
 configurations which do not implement it
Date: Mon, 10 Jul 2017 15:50:12 -0700
Message-ID: <20170710225012.gQ1DL1YQf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754715AbdGJWuN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, yang.shi@linaro.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm: disallow early_pfn_to_nid on configurations which do not implement it

early_pfn_to_nid will return node 0 if both HAVE_ARCH_EARLY_PFN_TO_NID and
HAVE_MEMBLOCK_NODE_MAP are disabled.  It seems we are safe now because all
architectures which support NUMA define one of them (with an exception of
alpha which however has CONFIG_NUMA marked as broken) so this works as
expected.  It can get silently and subtly broken too easily, though.  Make
sure we fail the compilation if NUMA is enabled and there is no proper
implementation for this function.  If that ever happens we know that
either the specific configuration is invalid and the fix should either
disable NUMA or enable one of the above configs.

Link: http://lkml.kernel.org/r/20170704075803.15979-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mmzone.h~mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it
+++ a/include/linux/mmzone.h
@@ -1055,6 +1055,7 @@ static inline struct zoneref *first_zone
 	!defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 {
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_NUMA));
 	return 0;
 }
 #endif
_
