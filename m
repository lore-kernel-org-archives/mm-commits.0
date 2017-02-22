From: akpm@linux-foundation.org
Subject: [patch 109/142] mm/sparse: use page_private() to get
 page->private value
Date: Wed, 22 Feb 2017 15:45:10 -0800
Message-ID: <58ae2286.NXb7kWHovL5Atc/P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934341AbdBVXpR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:45:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yasu.isimatu@gmail.com, dave.hansen@linux.intel.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@techsingularity.net, mingo@redhat.com, qiuxishi@huawei.com, tglx@linutronix.de, vbabka@suse.cz

From: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Subject: mm/sparse: use page_private() to get page->private value

free_map_bootmem() uses page->private directly to set removing_section_nr
argument.  But to get page->private value, page_private() has been
prepared.

So free_map_bootmem() should use page_private() instead of
page->private.

Link: http://lkml.kernel.org/r/1d34eaa5-a506-8b7a-6471-490c345deef8@gmail.com
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-sparse-use-page_private-to-get-page-private-value mm/sparse.c
--- a/mm/sparse.c~mm-sparse-use-page_private-to-get-page-private-value
+++ a/mm/sparse.c
@@ -667,7 +667,7 @@ static void free_map_bootmem(struct page
 		BUG_ON(magic == NODE_INFO);
 
 		maps_section_nr = pfn_to_section_nr(page_to_pfn(page));
-		removing_section_nr = page->private;
+		removing_section_nr = page_private(page);
 
 		/*
 		 * When this function is called, the removing section is
_
