Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3615FC10F1B
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 22:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiL3WB5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbiL3WBq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 17:01:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651CA1D0CF
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 14:01:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A83BB81D94
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 22:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3C1C433EF;
        Fri, 30 Dec 2022 22:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437702;
        bh=RxgW1DXnwstfbp0WNB0sV+i6f49syJZjW0q+NF3gD9s=;
        h=Date:To:From:Subject:From;
        b=uIKHZwXGn9Fk9SKDVVRbHV/a0JEOoY3MhNcshR9vPZFYciWPTGJY2to4acEuWogEa
         sQ5/23x/sPSnJy7J8PZBzLQDdRLOVewl8UdyjEpimiXoIpUBheSDummjfvc8SdBQwE
         RyWUiEUz9aWy1eO1ZixNrZIgv0gDrxxH2X85kMYU=
Date:   Fri, 30 Dec 2022 14:01:42 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-add-zero_pages_sharing-documentation.patch added to mm-unstable branch
Message-Id: <20221230220142.BC3C1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: add zero_pages_sharing documentation
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-add-zero_pages_sharing-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-add-zero_pages_sharing-documentation.patch

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
Subject: ksm: add zero_pages_sharing documentation
Date: Fri, 30 Dec 2022 09:17:28 +0800 (CST)

When enabling use_zero_pages, pages_sharing cannot represent how much
memory saved indeed.  zero_pages_sharing + pages_sharing does.  add the
description of zero_pages_sharing.

Link: https://lkml.kernel.org/r/202212300917284911971@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Jiang Xuexin <jiang.xuexin@zte.com.cn>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/mm/ksm.rst~ksm-add-zero_pages_sharing-documentation
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -173,6 +173,13 @@ stable_node_chains
         the number of KSM pages that hit the ``max_page_sharing`` limit
 stable_node_dups
         number of duplicated KSM pages
+zero_pages_sharing
+        how many empty pages are sharing kernel zero page(s) instead of
+        with each other as it would happen normally. Only effective when
+        enabling ``use_zero_pages`` knob.
+
+When enabling ``use_zero_pages``, the sum of ``pages_sharing`` +
+``zero_pages_sharing`` represents how much really saved by KSM.
 
 A high ratio of ``pages_sharing`` to ``pages_shared`` indicates good
 sharing, but a high ratio of ``pages_unshared`` to ``pages_sharing``
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-abstract-the-function-try_to_get_old_rmap_item.patch
ksm-support-unsharing-zero-pages-placed-by-ksm.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-count-zero-pages-for-each-process.patch
ksm-add-zero_pages_sharing-documentation.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch

