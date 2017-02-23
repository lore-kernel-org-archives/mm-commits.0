From: akpm@linux-foundation.org
Subject: [merged]
 mm-sparse-use-page_private-to-get-page-private-value.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:16:10 -0800
Message-ID: <58af511a.xiC364bolZNOLiMV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40476 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVQL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yasu.isimatu@gmail.com, dave.hansen@linux.intel.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@techsingularity.net, mingo@redhat.com, qiuxishi@huawei.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: use page_private() to get page->private value
has been removed from the -mm tree.  Its filename was
     mm-sparse-use-page_private-to-get-page-private-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yasu.isimatu@gmail.com are


