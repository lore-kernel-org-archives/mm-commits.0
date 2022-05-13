Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB4AC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379577AbiEMTZf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383805AbiEMTY1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:24:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0FE2C644
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 691B8B8315D
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234D4C34100;
        Fri, 13 May 2022 19:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469751;
        bh=79dRT8tjJBd2RnUbS07w0zk/eK6Qbw+Noh197FlgZdU=;
        h=Date:To:From:Subject:From;
        b=O9LKUmlBUwUUejN0QXgcSc3IiA53ypiQxhHFNXgLw31Z4iSV33YHQYWdrwv5mfrYQ
         Is7G2oaush6EqN+klPtelRUw4t1E/TdSRqtFlz8a/PXPj1cMSUQAGIEzwwstddFfCp
         OI4UZNiassdbpCJ0dBPMqM4FVQ0E2pzCqG+x6u60=
Date:   Fri, 13 May 2022 12:22:30 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch removed from -mm tree
Message-Id: <20220513192231.234D4C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure.c: add hwpoison_filter for soft offline
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
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


