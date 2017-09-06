From: akpm@linux-foundation.org
Subject: [patch 099/119] mm/vmstat: fix divide error at
 __fragmentation_index
Date: Wed, 06 Sep 2017 16:24:06 -0700
Message-ID: <20170906232406.Khovo4TQL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51098 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbdIFXYI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jiang.biao2@zte.com.cn, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, wen.yang99@zte.com.cn

From: Wen Yang <wen.yang99@zte.com.cn>
Subject: mm/vmstat: fix divide error at __fragmentation_index

When order is -1 or too big, *1UL << order* will be 0, which will cause
divide error.  Although it seems that all callers of
__fragmentation_index() will only do so with a valid order, the patch can
make it more robust.

Should prevent reoccurrences of
https://bugzilla.kernel.org/show_bug.cgi?id=196555

Link: http://lkml.kernel.org/r/1501751520-2598-1-git-send-email-wen.yang99@zte.com.cn
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmstat.c~mm-vmstat-fix-divide-error-at-__fragmentation_index mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-fix-divide-error-at-__fragmentation_index
+++ a/mm/vmstat.c
@@ -870,6 +870,9 @@ static int __fragmentation_index(unsigne
 {
 	unsigned long requested = 1UL << order;
 
+	if (WARN_ON_ONCE(order >= MAX_ORDER))
+		return 0;
+
 	if (!info->free_blocks_total)
 		return 0;
 
_
