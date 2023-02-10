Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70584C636D4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 22:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjBJWko (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 17:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbjBJWkn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 17:40:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDFF1B55B
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 14:40:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDF3A61EB7
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 22:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA93C4339B;
        Fri, 10 Feb 2023 22:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676068842;
        bh=gp8rB71Scfo+CixmZIvmGO18lDdM1Kq6EslPt3CcHp4=;
        h=Date:To:From:Subject:From;
        b=tdvagyDYT78nUAtCh/H0MbrVigMHx1ewiJmYUZkIzRd6dakJwAbhOj3EvYB4lQJU6
         uVLQ1SVls5xWnqFjvNGEa8r/h3QHMRZs8iZ9B1ZCTJYtljHQ4/g8pquWe3xlUdDxhC
         xU06/RpuolYAp6q2wiV9IP8Y856fqgTWTFseGbIA=
Date:   Fri, 10 Feb 2023 14:40:41 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-abstract-the-function-try_to_get_old_rmap_item-v6.patch added to mm-unstable branch
Message-Id: <20230210224042.1CA93C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-abstract-the-function-try_to_get_old_rmap_item-v6
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-abstract-the-function-try_to_get_old_rmap_item-v6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-abstract-the-function-try_to_get_old_rmap_item-v6.patch

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
Subject: ksm-abstract-the-function-try_to_get_old_rmap_item-v6
Date: Fri, 10 Feb 2023 09:16:42 +0800 (CST)

modify some comments according to David's suggestions.

Link: https://lkml.kernel.org/r/202302100916423431376@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/ksm.c~ksm-abstract-the-function-try_to_get_old_rmap_item-v6
+++ a/mm/ksm.c
@@ -2218,12 +2218,16 @@ static struct ksm_rmap_item *try_to_get_
 {
 	while (*rmap_list) {
 		struct ksm_rmap_item *rmap_item = *rmap_list;
+
 		if ((rmap_item->address & PAGE_MASK) == addr)
 			return rmap_item;
 		if (rmap_item->address > addr)
 			break;
 		*rmap_list = rmap_item->rmap_list;
-		/* Running here indicates it's vma has been UNMERGEABLE */
+		/*
+		 * If we end up here, the VMA is MADV_UNMERGEABLE or its page
+		 * is ineligible or discarded, e.g. MADV_DONTNEED.
+		 */
 		remove_rmap_item_from_tree(rmap_item);
 		free_rmap_item(rmap_item);
 	}
@@ -2237,12 +2241,10 @@ static struct ksm_rmap_item *get_next_rm
 {
 	struct ksm_rmap_item *rmap_item;
 
-	/* lookup if we have a old rmap_item matching the addr*/
 	rmap_item = try_to_get_old_rmap_item(addr, rmap_list);
 	if (rmap_item)
 		return rmap_item;
 
-	/* Need to allocate a new rmap_item */
 	rmap_item = alloc_rmap_item();
 	if (rmap_item) {
 		/* It has already been zeroed */
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-abstract-the-function-try_to_get_old_rmap_item.patch
ksm-abstract-the-function-try_to_get_old_rmap_item-v6.patch
ksm-support-unsharing-zero-pages-placed-by-ksm.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-count-zero-pages-for-each-process.patch
ksm-add-zero_pages_sharing-documentation.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page-v6.patch

