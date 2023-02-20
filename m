Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77ACC6FA99
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjBTUrJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBTUrG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:47:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F0F30E9
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2379AB80DCB
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6528C4339C;
        Mon, 20 Feb 2023 20:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926023;
        bh=3rXMaX58Uh1ooev2yJQNZCvGzT/KwsfyGCV2dCkqEtM=;
        h=Date:To:From:Subject:From;
        b=lWwRa3UJHxIRSEY7/NOsFBcNrPkTdggvmBtYPSrYfBoxkzNNLvAdhYbbX1GHg5WZN
         OY1cjiuktmD8KCC/rLGvE8t/zu98+qfj458jYbFYwINox6/EDOiGXA7t9FDBsP4/X6
         9d6y4BE/n6KxwM1wKInQisiJKAcfeHF6WTC8IlKc=
Date:   Mon, 20 Feb 2023 12:47:03 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-uffd-fix-comment-in-handling-pte-markers.patch removed from -mm tree
Message-Id: <20230220204703.B6528C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: fix comment in handling pte markers
has been removed from the -mm tree.  Its filename was
     mm-uffd-fix-comment-in-handling-pte-markers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: fix comment in handling pte markers
Date: Wed, 15 Feb 2023 15:58:00 -0500

The comment is obsolete after f369b07c8614 ("mm/uffd: reset write
protection when unregister with wp-mode", 2022-08-20).  Remove it.

Link: https://lkml.kernel.org/r/20230215205800.223549-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-uffd-fix-comment-in-handling-pte-markers
+++ a/mm/memory.c
@@ -3627,9 +3627,7 @@ static vm_fault_t pte_marker_handle_uffd
 {
 	/*
 	 * Just in case there're leftover special ptes even after the region
-	 * got unregistered - we can simply clear them.  We can also do that
-	 * proactively when e.g. when we do UFFDIO_UNREGISTER upon some uffd-wp
-	 * ranges, but it should be more efficient to be done lazily here.
+	 * got unregistered - we can simply clear them.
 	 */
 	if (unlikely(!userfaultfd_wp(vmf->vma) || vma_is_anonymous(vmf->vma)))
 		return pte_marker_clear(vmf);
_

Patches currently in -mm which might be from peterx@redhat.com are


