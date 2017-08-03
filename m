From: akpm@linux-foundation.org
Subject: + mm-vmstat-fix-divide-error-at-__fragmentation_index.patch added to -mm tree
Date: Thu, 03 Aug 2017 15:56:39 -0700
Message-ID: <5983aa27.7RIVc/FGptWBwL9O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdHCW4k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 18:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wen.yang99@zte.com.cn, jiang.biao2@zte.com.cn, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: fix divide error at __fragmentation_index
has been added to the -mm tree.  Its filename is
     mm-vmstat-fix-divide-error-at-__fragmentation_index.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-fix-divide-error-at-__fragmentation_index.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-fix-divide-error-at-__fragmentation_index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from wen.yang99@zte.com.cn are

mm-vmstat-fix-divide-error-at-__fragmentation_index.patch

