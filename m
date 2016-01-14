From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zonelist-enumerate-zonelists-array-index-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:21:25 -0800
Message-ID: <56981f65.94hKOAenheUmvGDz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbcANWV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:21:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com, mhocko@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zonelist-enumerate-zonelists-array-index-fix
has been removed from the -mm tree.  Its filename was
     mm-zonelist-enumerate-zonelists-array-index-fix.patch

This patch was dropped because it was folded into mm-zonelist-enumerate-zonelists-array-index.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zonelist-enumerate-zonelists-array-index-fix

Fix CONFIG_NUMA=n build

include/linux/gfp.h: In function 'gfp_zonelist':
include/linux/gfp.h:388: error: 'ZONELIST_NOFALLBACK' undeclared (first use in this function)

Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-zonelist-enumerate-zonelists-array-index-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-zonelist-enumerate-zonelists-array-index-fix
+++ a/include/linux/gfp.h
@@ -384,9 +384,10 @@ static inline enum zone_type gfp_zone(gf
 
 static inline int gfp_zonelist(gfp_t flags)
 {
-	if (IS_ENABLED(CONFIG_NUMA) && unlikely(flags & __GFP_THISNODE))
+#ifdef CONFIG_NUMA
+	if (unlikely(flags & __GFP_THISNODE))
 		return ZONELIST_NOFALLBACK;
