From: akpm@linux-foundation.org
Subject: +
 mmksm-fix-endless-looping-in-allocating-memory-when-ksm-enable.patch added
 to -mm tree
Date: Mon, 19 Sep 2016 15:56:08 -0700
Message-ID: <57e06d08.evanQdy7Li/zBfXB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54177 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbcISW4J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 18:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, hughd@google.com, mhocko@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,ksm: fix endless looping in allocating memory when ksm enable
has been added to the -mm tree.  Its filename is
     mmksm-fix-endless-looping-in-allocating-memory-when-ksm-enable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmksm-fix-endless-looping-in-allocating-memory-when-ksm-enable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmksm-fix-endless-looping-in-allocating-memory-when-ksm-enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm,ksm: fix endless looping in allocating memory when ksm enable

I hit the following issue when run a OOM case of the LTP and ksm enable.

Call trace:
[<ffffffc000086a88>] __switch_to+0x74/0x8c
[<ffffffc000a1bae0>] __schedule+0x23c/0x7bc
[<ffffffc000a1c09c>] schedule+0x3c/0x94
[<ffffffc000a1eb84>] rwsem_down_write_failed+0x214/0x350
[<ffffffc000a1e32c>] down_write+0x64/0x80
[<ffffffc00021f794>] __ksm_exit+0x90/0x19c
[<ffffffc0000be650>] mmput+0x118/0x11c
[<ffffffc0000c3ec4>] do_exit+0x2dc/0xa74
[<ffffffc0000c46f8>] do_group_exit+0x4c/0xe4
[<ffffffc0000d0f34>] get_signal+0x444/0x5e0
[<ffffffc000089fcc>] do_signal+0x1d8/0x450
[<ffffffc00008a35c>] do_notify_resume+0x70/0x78

it will lead to a hung task because the exiting task cannot get the mmap
sem for write.  but the root cause is that the ksmd holds it for read
while allocateing memory which just takes ages to complete.  and ksmd will
loop in the following path.

 scan_get_next_rmap_item
          down_read
                get_next_rmap_item
                        alloc_rmap_item   #ksmd will loop permanently.

we fix it by changing the GFP to allow the allocation sometimes fail, and
we're not at all interested in hearing abot that.

Link: http://lkml.kernel.org/r/1474165570-44398-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Suggested-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/ksm.c~mmksm-fix-endless-looping-in-allocating-memory-when-ksm-enable mm/ksm.c
--- a/mm/ksm.c~mmksm-fix-endless-looping-in-allocating-memory-when-ksm-enable
+++ a/mm/ksm.c
@@ -283,7 +283,8 @@ static inline struct rmap_item *alloc_rm
 {
 	struct rmap_item *rmap_item;
 
-	rmap_item = kmem_cache_zalloc(rmap_item_cache, GFP_KERNEL);
+	rmap_item = kmem_cache_zalloc(rmap_item_cache, GFP_KERNEL |
+						__GFP_NORETRY | __GFP_NOWARN);
 	if (rmap_item)
 		ksm_rmap_items++;
 	return rmap_item;
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mmksm-fix-endless-looping-in-allocating-memory-when-ksm-enable.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

