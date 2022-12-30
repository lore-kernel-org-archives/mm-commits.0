Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9199C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 22:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiL3WBz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiL3WBp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 17:01:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BB717E2C
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 14:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68629B81D93
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 22:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20981C433EF;
        Fri, 30 Dec 2022 22:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437696;
        bh=ajOs26CsGXoQ5yNyZlWbVs9DxPclZ3+EVmed4LJ+LF4=;
        h=Date:To:From:Subject:From;
        b=FhwBsdOR9zXcVqO5ropT/2uOvRpjOvZ1mBATR9B7CxIE4oltZXMr5orlFZ0jkJfNZ
         MAUOibhr0b7d3U0mFCgUYP1gIG9/QmnmzSpsYKPiNZAGlwYbM66LmDTglwqT8WcO3n
         21ou14lMoa3+ovHg1Y3XCFzxlxujHPs1rYMj9/qc=
Date:   Fri, 30 Dec 2022 14:01:35 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-abstract-the-function-try_to_get_old_rmap_item.patch added to mm-unstable branch
Message-Id: <20221230220136.20981C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: abstract the function try_to_get_old_rmap_item
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-abstract-the-function-try_to_get_old_rmap_item.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-abstract-the-function-try_to_get_old_rmap_item.patch

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: abstract the function try_to_get_old_rmap_item
Date: Fri, 30 Dec 2022 09:12:44 +0800 (CST)

Patch series "ksm: support tracking KSM-placed zero-pages", v5.

The core idea of this patch set is to enable users to perceive the number
of any pages merged by KSM, regardless of whether use_zero_page switch has
been turned on, so that users can know how much free memory increase is
really due to their madvise(MERGEABLE) actions.  But the problem is, when
enabling use_zero_pages, all empty pages will be merged with kernel zero
pages instead of with each other as use_zero_pages is disabled, and then
these zero-pages are no longer monitored by KSM.

The motivations for me to do this contains three points:

1) MADV_UNMERGEABLE and other ways to trigger unsharing will *not*
   unshare the shared zeropage as placed by KSM (which is against the 
   MADV_UNMERGEABLE documentation at least); see the link:
   https://lore.kernel.org/lkml/4a3daba6-18f9-d252-697c-197f65578c44@redhat.com/

2) We cannot know how many pages are zero pages placed by KSM when
   enabling use_zero_pages, which hides the critical information about
   how much actual memory are really saved by KSM. Knowing how many
   ksm-placed zero pages are helpful for user to use the policy of madvise
   (MERGEABLE) better because they can see the actual profit brought by KSM.

3) The zero pages placed-by KSM are different from those initial empty page
   (filled with zeros) which are never touched by applications. The former
   is active-merged by KSM while the later have never consume actual memory.

use_zero_pages is useful, not only because of cache colouring as described
in doc, but also because use_zero_pages can accelerate merging empty pages
when there are plenty of empty pages (full of zeros) as the time of
page-by-page comparisons (unstable_tree_search_insert) is saved.  So we
hope to implement the support for ksm zero page tracking without affecting
the feature of use_zero_pages.

Zero pages may be the most common merged pages in actual environment(not
only VM but also including other application like containers).  Enabling
use_zero_pages in the environment with plenty of empty pages(full of
zeros) will be very useful.  Users and app developer can also benefit from
knowing the proportion of zero pages in all merged pages to optimize
applications.

With the patch series, we can both unshare zero-pages(KSM-placed)
accurately and count ksm zero pages with enabling use_zero_pages.


This patch (of 6):

A new function try_to_get_old_rmap_item is abstracted from
get_next_rmap_item.  This function will be reused by the subsequent
patches about counting ksm_zero_pages.

The patch improves the readability and reusability of KSM code.

Link: https://lkml.kernel.org/r/202212300911327101708@zte.com.cn
Link: https://lkml.kernel.org/r/202212300912449061763@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/ksm.c~ksm-abstract-the-function-try_to_get_old_rmap_item
+++ a/mm/ksm.c
@@ -2214,23 +2214,36 @@ static void cmp_and_merge_page(struct pa
 	}
 }
 
-static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *mm_slot,
-					    struct ksm_rmap_item **rmap_list,
-					    unsigned long addr)
+static struct ksm_rmap_item *try_to_get_old_rmap_item(unsigned long addr,
+					 struct ksm_rmap_item **rmap_list)
 {
-	struct ksm_rmap_item *rmap_item;
-
 	while (*rmap_list) {
-		rmap_item = *rmap_list;
+		struct ksm_rmap_item *rmap_item = *rmap_list;
 		if ((rmap_item->address & PAGE_MASK) == addr)
 			return rmap_item;
 		if (rmap_item->address > addr)
 			break;
 		*rmap_list = rmap_item->rmap_list;
+		/* Running here indicates it's vma has been UNMERGEABLE */
 		remove_rmap_item_from_tree(rmap_item);
 		free_rmap_item(rmap_item);
 	}
 
+	return NULL;
+}
+
+static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *mm_slot,
+					    struct ksm_rmap_item **rmap_list,
+					    unsigned long addr)
+{
+	struct ksm_rmap_item *rmap_item;
+
+	/* lookup if we have a old rmap_item matching the addr*/
+	rmap_item = try_to_get_old_rmap_item(addr, rmap_list);
+	if (rmap_item)
+		return rmap_item;
+
+	/* Need to allocate a new rmap_item */
 	rmap_item = alloc_rmap_item();
 	if (rmap_item) {
 		/* It has already been zeroed */
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-abstract-the-function-try_to_get_old_rmap_item.patch
ksm-support-unsharing-zero-pages-placed-by-ksm.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-count-zero-pages-for-each-process.patch
ksm-add-zero_pages_sharing-documentation.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch

