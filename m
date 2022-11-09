Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37764C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiKIBlx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKIBkE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6189667F7C
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E179B81CDE
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0721C433C1;
        Wed,  9 Nov 2022 01:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957963;
        bh=lJw9owzj38mpQtq8c6LWk5q1eI8/sBkPsW4NLL8evmk=;
        h=Date:To:From:Subject:From;
        b=spAuL8d9uYFoxdWuXfKA4OTLooTLLBW4qY+H+TVJmOwdTX7t46nlYErEpl4CE1o48
         mo4M/4edN1Siwz7mMvCD84TOPEtMZoGecLE8SUmHZ63XxOA3jtFjQ61UkHu4UyAX19
         jYCpktBuvvTkxDMzBGvl1QiS3MnFbvklFWZPGqUg=
Date:   Tue, 08 Nov 2022 17:39:23 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-make-action_result-return-int.patch removed from -mm tree
Message-Id: <20221109013923.C0721C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: make action_result() return int
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-make-action_result-return-int.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: make action_result() return int
Date: Fri, 21 Oct 2022 16:46:11 +0800

Check mf_result in action_result(), only return 0 when MF_RECOVERED,
or return -EBUSY, which will simplify code a bit.

[wangkefeng.wang@huawei.com: v2]
  Link: https://lkml.kernel.org/r/20221024035138.99119-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20221021084611.53765-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   45 ++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-make-action_result-return-int
+++ a/mm/memory-failure.c
@@ -1179,14 +1179,16 @@ static struct page_state error_states[]
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
-static void action_result(unsigned long pfn, enum mf_action_page_type type,
-			  enum mf_result result)
+static int action_result(unsigned long pfn, enum mf_action_page_type type,
+			 enum mf_result result)
 {
 	trace_memory_failure_event(pfn, type, result);
 
 	num_poisoned_pages_inc();
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
+
+	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
 static int page_action(struct page_state *ps, struct page *p,
@@ -1197,14 +1199,12 @@ static int page_action(struct page_state
 	/* page p should be unlocked after returning from ps->action().  */
 	result = ps->action(ps, p);
 
-	action_result(pfn, ps->type, result);
-
 	/* Could do more checks here if page looks ok */
 	/*
 	 * Could adjust zone counters here to correct for the missing page.
 	 */
 
-	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
+	return action_result(pfn, ps->type, result);
 }
 
 static inline bool PageHWPoisonTakenOff(struct page *page)
@@ -1853,8 +1853,7 @@ retry:
 			flags |= MF_NO_RETRY;
 			goto retry;
 		}
-		action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
-		return res;
+		return action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
 	}
 
 	head = compound_head(p);
@@ -1880,22 +1879,17 @@ retry:
 		} else {
 			res = MF_FAILED;
 		}
-		action_result(pfn, MF_MSG_FREE_HUGE, res);
-		return res == MF_RECOVERED ? 0 : -EBUSY;
+		return action_result(pfn, MF_MSG_FREE_HUGE, res);
 	}
 
 	page_flags = head->flags;
 
 	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
-		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
-		res = -EBUSY;
-		goto out;
+		unlock_page(head);
+		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 	}
 
 	return identify_page_state(pfn, p, page_flags);
-out:
-	unlock_page(head);
-	return res;
 }
 
 #else
@@ -2060,16 +2054,13 @@ try_again:
 					}
 					res = MF_FAILED;
 				}
-				action_result(pfn, MF_MSG_BUDDY, res);
-				res = res == MF_RECOVERED ? 0 : -EBUSY;
+				res = action_result(pfn, MF_MSG_BUDDY, res);
 			} else {
-				action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
-				res = -EBUSY;
+				res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 			}
 			goto unlock_mutex;
 		} else if (res < 0) {
-			action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
-			res = -EBUSY;
+			res = action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
 			goto unlock_mutex;
 		}
 	}
@@ -2090,8 +2081,7 @@ try_again:
 		 */
 		SetPageHasHWPoisoned(hpage);
 		if (try_to_split_thp_page(p) < 0) {
-			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
-			res = -EBUSY;
+			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
@@ -2124,8 +2114,7 @@ try_again:
 			retry = false;
 			goto try_again;
 		}
-		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
-		res = -EBUSY;
+		res = action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
 		goto unlock_page;
 	}
 
@@ -2165,8 +2154,7 @@ try_again:
 	 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
 	 */
 	if (!hwpoison_user_mappings(p, pfn, flags, p)) {
-		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
-		res = -EBUSY;
+		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		goto unlock_page;
 	}
 
@@ -2174,8 +2162,7 @@ try_again:
 	 * Torn down by someone else?
 	 */
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
-		action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
-		res = -EBUSY;
+		res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
 		goto unlock_page;
 	}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


