Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B6BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 21:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353652AbiBKVa2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:30:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353650AbiBKVa2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 16:30:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F1CC57
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 13:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5629160B76
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 21:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DD2C340E9;
        Fri, 11 Feb 2022 21:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644615024;
        bh=GUAxj5fL8Yaw/RyXgSs+9qSD+159LzDFKll5EZAy0LQ=;
        h=Date:To:From:Subject:From;
        b=rk/koMb31emLL6szqumo1MD/33m1Jm0+UuzP0vlRUZfNbve6tjvmhL7W2M9miC/jr
         eFlz0liHbYQ86sA80UIY4wEMxkfKVhZnkpn4Zm+VJOBNShSlY17ie0TVBDmjKAIeDN
         KiNdNkJARunF/QdkT9VrQcxoMVxscM2KUPrJyNFw=
Date:   Fri, 11 Feb 2022 13:30:24 -0800
To:     mm-commits@vger.kernel.org, hughd@google.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch added to -mm tree
Message-Id: <20220211213024.A9DD2C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: fix kernel-doc formatting issues
has been added to the -mm tree.  Its filename is
     mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm/munlock: fix kernel-doc formatting issues

Some functions had kernel-doc that used a hash instead of a colon to
separate the parameter name from the one line description.

Replacing them to remove warnings found by running scripts/kernel-doc,
which is caused by using 'make W=1'.

mm/mlock.c:218: warning: Function parameter or member 'page' not
described in 'mlock_page'
mm/mlock.c:240: warning: Function parameter or member 'page' not
described in 'mlock_new_page'
mm/mlock.c:260: warning: Function parameter or member 'page' not
described in 'munlock_page'

Link: https://lkml.kernel.org/r/20220210004849.69017-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mlock.c~mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix
+++ a/mm/mlock.c
@@ -212,7 +212,7 @@ bool need_mlock_page_drain(int cpu)
 
 /**
  * mlock_page - mlock a page already on (or temporarily off) LRU
- * @page - page to be mlocked, either a normal page or a THP head.
+ * @page: page to be mlocked, either a normal page or a THP head.
  */
 void mlock_page(struct page *page)
 {
@@ -234,7 +234,7 @@ void mlock_page(struct page *page)
 
 /**
  * mlock_new_page - mlock a newly allocated page not yet on LRU
- * @page - page to be mlocked, either a normal page or a THP head.
+ * @page: page to be mlocked, either a normal page or a THP head.
  */
 void mlock_new_page(struct page *page)
 {
@@ -254,7 +254,7 @@ void mlock_new_page(struct page *page)
 
 /**
  * munlock_page - munlock a page
- * @page - page to be munlocked, either a normal page or a THP head.
+ * @page: page to be munlocked, either a normal page or a THP head.
  */
 void munlock_page(struct page *page)
 {
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch
proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch

