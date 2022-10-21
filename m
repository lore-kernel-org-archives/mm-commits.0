Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98517C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJUUFZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJUUFW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:05:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAA4D996C
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE8A1CE2BA1
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C56BC433D6;
        Fri, 21 Oct 2022 20:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382716;
        bh=kTCudQIqi3RPGoHR/65B1rjM6VKkBFbPmIaNYQle+8s=;
        h=Date:To:From:Subject:From;
        b=bwI9NR/qLV+X9cU4sIOF8hVX6fdy8VFnEGodb5l4SzIYQmHXaTkFiEz6HuuAuNUwN
         XcYZumQXN64YIlUYnEsfSxi6ESo0qUa+uhgxTWOliZomaj4n81w2ZBJ+pPN171/VcA
         /ZKlqErVjQp3SaMyJZwKM5juw+eYNx6qrjh9jTIg=
Date:   Fri, 21 Oct 2022 13:05:15 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-make-action_result-return-int.patch added to mm-unstable branch
Message-Id: <20221021200516.1C56BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: make action_result() return int
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-make-action_result-return-int.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-make-action_result-return-int.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: make action_result() return int
Date: Fri, 21 Oct 2022 16:46:11 +0800

Check mf_result in action_result(), only return 0 when MF_RECOVERED,
or return -EBUSY, which will simplify code a bit.

Link: https://lkml.kernel.org/r/20221021084611.53765-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-make-action_result-return-int
+++ a/mm/memory-failure.c
@@ -1182,14 +1182,16 @@ static struct page_state error_states[]
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
+	return result == MF_RECOVERED ? 0 : -EBUSY;
 }
 
 static int page_action(struct page_state *ps, struct page *p,
@@ -1856,8 +1858,7 @@ retry:
 			flags |= MF_NO_RETRY;
 			goto retry;
 		}
-		action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
-		return res;
+		return action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
 	}
 
 	head = compound_head(p);
@@ -1883,22 +1884,18 @@ retry:
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
+		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
+		unlock_page(head);
+		return res;
 	}
 
 	return identify_page_state(pfn, p, page_flags);
-out:
-	unlock_page(head);
-	return res;
 }
 
 #else
@@ -2063,16 +2060,13 @@ try_again:
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
@@ -2093,8 +2087,7 @@ try_again:
 		 */
 		SetPageHasHWPoisoned(hpage);
 		if (try_to_split_thp_page(p) < 0) {
-			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
-			res = -EBUSY;
+			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
@@ -2127,8 +2120,7 @@ try_again:
 			retry = false;
 			goto try_again;
 		}
-		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
-		res = -EBUSY;
+		res = action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
 		goto unlock_page;
 	}
 
@@ -2168,8 +2160,7 @@ try_again:
 	 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
 	 */
 	if (!hwpoison_user_mappings(p, pfn, flags, p)) {
-		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
-		res = -EBUSY;
+		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		goto unlock_page;
 	}
 
@@ -2177,8 +2168,7 @@ try_again:
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

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch
mm-remove-kern_addr_valid-completely.patch
nios2-remove-unused-init_mmap.patch
x86-sgx-use-vm_access_flags.patch
mm-mprotect-use-vm_access_flags.patch
mm-debug_vm_pgtable-use-vm_access_flags.patch
amdgpu-use-vm_access_flags.patch
mm-memory-failure-make-put_ref_page-more-useful.patch
mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch
mm-memory-failure-make-action_result-return-int.patch

