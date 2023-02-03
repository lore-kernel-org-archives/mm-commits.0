Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25271C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjBCGfk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjBCGfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCBB80F90
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EE1161D98
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F384EC433EF;
        Fri,  3 Feb 2023 06:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406127;
        bh=h57CR4j26YkoZKERDPAWue3q6gvL1ogxCFHvhKaIoJ4=;
        h=Date:To:From:Subject:From;
        b=UMnfHLOQoPQ7Cj/bKurv1nxm9HZoW6DgC7ByRYy6YX4S6jqDv5TKMnKKZVX1LlMFD
         ErWiHsIGUu7UYNCo+fJ4dlJiVri6VsuyevCmA4ar1lxKONr9tIH/YXsg73m89ZuRzi
         jtz1KvnuuYLdCDYDDUlMdnk2wGJtEXT4NSYSaDfc=
Date:   Thu, 02 Feb 2023 22:35:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch removed from -mm tree
Message-Id: <20230203063526.F384EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: remove redundant VM_BUG_ON() in compact_zone()
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: remove redundant VM_BUG_ON() in compact_zone()
Date: Tue, 10 Jan 2023 21:36:18 +0800

Patch series "Some small improvements for compaction".

When I did some compaction testing, I found some small room for
improvement as well as some code cleanups.


This patch (of 5):

The compaction_suitable() will never return values other than
COMPACT_SUCCESS, COMPACT_SKIPPED and COMPACT_CONTINUE, so after validation
of COMPACT_SUCCESS and COMPACT_SKIPPED, we will never hit other unexpected
case.  Thus remove the redundant VM_BUG_ON() validation for the return
values of compaction_suitable().

Link: https://lkml.kernel.org/r/cover.1673342761.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/740a2396d9b98154dba76e326cba5e798b640ead.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-remove-redundant-vm_bug_on-in-compact_zone
+++ a/mm/compaction.c
@@ -2313,9 +2313,6 @@ compact_zone(struct compact_control *cc,
 	if (ret == COMPACT_SUCCESS || ret == COMPACT_SKIPPED)
 		return ret;
 
-	/* huh, compaction_suitable is returning something unexpected */
-	VM_BUG_ON(ret != COMPACT_CONTINUE);
-
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
 	 * is about to be retried after being deferred.
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


