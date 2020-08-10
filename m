Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8240C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD7A3206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026963;
	bh=SgG8iTXmLmlRzYFShV2XiYbvdNH6aDmLRMzYvxrI2b0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PseDP7SamtJ4iUoGHIKS/ExV54aSfaQU7YvkAnxwruzOaSl1tWWtzjI3+nhTwXgaF
	 0IUFz3HlmLTsKuKb7hIo9DftfcSah38t9H6Yr677LkuYMHfxZZjOgBY7Hi5n4GRlsh
	 Z/dAxhC8zSuuTnrXeNnq/F8RtKWX4xS479DHgYXA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHJCgD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83DA4206C3;
        Mon, 10 Aug 2020 02:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026962;
        bh=SgG8iTXmLmlRzYFShV2XiYbvdNH6aDmLRMzYvxrI2b0=;
        h=Date:From:To:Subject:From;
        b=BAH1BdY0/n6rR9B+9flbB7oVkfmoLWCWFhyh8o95WVrX7H4ejPs6s6VSErDqmQWfy
         wDFQG4cx0dAr7J87itnQYR7pWjPwpqpKNAUzIAHuclYGPd/rwMsIl6beUeFcow8rT3
         q5vJ5u1EfbVZ1/8PrreyKxWiAJFWJBf++XRnaaFE=
Date:   Sun, 09 Aug 2020 19:36:02 -0700
From:   akpm@linux-foundation.org
To:     gavin.dg@linux.alibaba.com, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        yang.shi@linux.alibaba.com
Subject:  [merged]
 =?US-ASCII?Q?mm-filemap-add-missing-fgp=5F-flags-in-kerneldoc-comment-?=
 =?US-ASCII?Q?for-pagecache=5Fget=5Fpage.patch?= removed from -mm tree
Message-ID: <20200810023602.aRLNqP3hc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap: add missing FGP_ flags in kerneldoc comment for pagecache_get_page
has been removed from the -mm tree.  Its filename was
     mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: filemap: add missing FGP_ flags in kerneldoc comment for pagecache_get_page

FGP_{WRITE|NOFS|NOWAIT} were missed in pagecache_get_page's kerneldoc
comment.

Link: http://lkml.kernel.org/r/1593031747-4249-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Gang Deng <gavin.dg@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/filemap.c~mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page
+++ a/mm/filemap.c
@@ -1649,6 +1649,9 @@ EXPORT_SYMBOL(find_lock_entry);
  * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
  *   page is already in cache.  If the page was allocated, unlock it before
  *   returning so the caller can do the same dance.
+ * * %FGP_WRITE - The page will be written
+ * * %FGP_NOFS - __GFP_FS will get cleared in gfp mask
+ * * %FGP_NOWAIT - Don't get blocked by page lock
  *
  * If %FGP_LOCK or %FGP_CREAT are specified then the function may sleep even
  * if the %GFP flags specified for %FGP_CREAT are atomic.
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-thp-remove-debug_cow-switch.patch

