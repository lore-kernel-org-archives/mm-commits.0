Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B85CC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 23:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiEIXXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 19:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiEIXXD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 19:23:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BF1201F1F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 16:19:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 322FD61227
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 23:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8908EC385C2;
        Mon,  9 May 2022 23:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652138346;
        bh=Eu1ZC2xKaL9PiH/WMTTufN/P0MmZqgJwGeBenJmZG/s=;
        h=Date:To:From:Subject:From;
        b=U8jClW6J4JHMhxGRmhOAMklgtzpD8WXpI41pxjjTv9ta7uss/7N9JZvs0mkPwJqhg
         NFGi85TIDF7ESs3Eo9qubzNGnHyhmV/uIJhhctXpIdf4DFAzwPy+KQuYscuZDgpyGJ
         T7wTHUKl/jNvzA3JBYK42J32ciAbH5y88UTjcT8I=
Date:   Mon, 09 May 2022 16:19:05 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch added to mm-unstable branch
Message-Id: <20220509231906.8908EC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: add hwpoison_filter for soft offline
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch

This patch should soon appear in the mm-unstable branch at
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
From: zhenwei pi <pizhenwei@bytedance.com>
Subject: mm/memory-failure.c: add hwpoison_filter for soft offline

hwpoison_filter is missing in the soft offline path, this leads an issue:
after enabling the corrupt filter, the user process still has a chance to
inject hwpoison fault by madvise(addr, len, MADV_SOFT_OFFLINE) at PFN
which is expected to reject.

Also do a minor change in comment of memory_failure().

Link: https://lkml.kernel.org/r/20220509105641.491313-4-pizhenwei@bytedance.com
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-add-hwpoison_filter-for-soft-offline
+++ a/mm/memory-failure.c
@@ -1751,7 +1751,7 @@ static DEFINE_MUTEX(mf_mutex);
  * enabled and no spinlocks hold.
  *
  * Return: 0 for successfully handled the memory error,
- *         -EOPNOTSUPP for memory_filter() filtered the error event,
+ *         -EOPNOTSUPP for hwpoison_filter() filtered the error event,
  *         < 0(except -EOPNOTSUPP) on failure.
  */
 int memory_failure(unsigned long pfn, int flags)
@@ -2295,7 +2295,9 @@ static void put_ref_page(struct page *pa
  * @pfn: pfn to soft-offline
  * @flags: flags. Same as memory_failure().
  *
- * Returns 0 on success, otherwise negated errno.
+ * Returns 0 on success
+ *         -EOPNOTSUPP for hwpoison_filter() filtered the error event
+ *         < 0 otherwise negated errno.
  *
  * Soft offline a page, by migration or invalidation,
  * without killing anything. This is for the case when
@@ -2346,6 +2348,16 @@ retry:
 	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
 	put_online_mems();
 
+	if (hwpoison_filter(page)) {
+		if (ret > 0)
+			put_page(page);
+		else
+			put_ref_page(ref_page);
+
+		mutex_unlock(&mf_mutex);
+		return -EOPNOTSUPP;
+	}
+
 	if (ret > 0) {
 		ret = soft_offline_in_use_page(page);
 	} else if (ret == 0) {
_

Patches currently in -mm which might be from pizhenwei@bytedance.com are

mm-memory-failurec-move-clear_hwpoisoned_pages.patch
mm-memory-failurec-simplify-num_poisoned_pages_dec.patch
mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch
mm-hwpoison-disable-hwpoison-filter-during-removing.patch
mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch

