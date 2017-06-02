From: akpm@linux-foundation.org
Subject: [patch 02/15] include/linux/gfp.h: fix  ___GFP_NOLOCKDEP value
Date: Fri, 02 Jun 2017 14:46:13 -0700
Message-ID: <5931dca5.IGZY8PCoHSpe6Mjy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVqP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, igor.stoppa@nokia.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: include/linux/gfp.h: fix  ___GFP_NOLOCKDEP value

Igor Stoppa has noticed that __GFP_NOLOCKDEP can use a lower bit. At the
time 7e7844226f10 ("lockdep: allow to disable reclaim lockup detection")
was written we still had __GFP_OTHER_NODE but I have removed it in
41b6167e8f74 ("mm: get rid of __GFP_OTHER_NODE") and forgot to lower the
bit value. The current value is outside of __GFP_BITS_SHIFT so it cannot
be used actually.

Fixes: 7e7844226f10 ("lockdep: allow to disable reclaim lockup detection")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Igor Stoppa <igor.stoppa@nokia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~include-linux-gfph-fix-___gfp_nolockdep-value include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-fix-___gfp_nolockdep-value
+++ a/include/linux/gfp.h
@@ -41,7 +41,7 @@ struct vm_area_struct;
 #define ___GFP_WRITE		0x800000u
 #define ___GFP_KSWAPD_RECLAIM	0x1000000u
 #ifdef CONFIG_LOCKDEP
-#define ___GFP_NOLOCKDEP	0x4000000u
+#define ___GFP_NOLOCKDEP	0x2000000u
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
_
