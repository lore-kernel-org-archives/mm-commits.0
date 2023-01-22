Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759FFC38142
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 00:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjAVA5p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 19:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAVA5p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 19:57:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49770106
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 16:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C646460B76
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 00:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1161DC433EF;
        Sun, 22 Jan 2023 00:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674349062;
        bh=XROT+AwZ5PxYA/H9FLslEqIiqsHPsA9x/f035Z1XlZI=;
        h=Date:To:From:Subject:From;
        b=YUWhqWMJY+wUPZyxtFjTxUGrmpZAo8bsOPNDpG6fwXgCHHxwJpWY+YCgUXcYiM2o2
         pr74+USDhIjy7X+ULR2/nnMCQY+CXrkrZPXk5jmL91lP+YBgD6oXqpiz1OhHsbu8U1
         clUBH1QCMUnF4uv9ytYtIAQwZp9pESbuhxeqSFyU=
Date:   Sat, 21 Jan 2023 16:57:41 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        rientjes@google.com, mhocko@kernel.org, iamjoonsoo.kim@lge.com,
        david@redhat.com, 42.hyeyoo@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-record-single-timestamp-value-for-high-order-allocations.patch added to mm-unstable branch
Message-Id: <20230122005742.1161DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: record single timestamp value for high order allocations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-record-single-timestamp-value-for-high-order-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-record-single-timestamp-value-for-high-order-allocations.patch

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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/page_owner: record single timestamp value for high order allocations
Date: Sun, 22 Jan 2023 01:50:54 +0900

When allocating a high-order page, separate allocation timestamp is
recorded for each sub-page resulting in different timestamp values between
them.

This behavior is not consistent with the behavior when recording free
timestamp and caused confusion when analyzing memory dumps.  Record single
timestamp for the entire allocation, aligning with the behavior for free
timestamps.

Link: https://lkml.kernel.org/r/20230121165054.520507-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_owner.c~mm-page_owner-record-single-timestamp-value-for-high-order-allocations
+++ a/mm/page_owner.c
@@ -163,6 +163,7 @@ static inline void __set_page_owner_hand
 {
 	struct page_owner *page_owner;
 	int i;
+	u64 ts_nsec = local_clock();
 
 	for (i = 0; i < (1 << order); i++) {
 		page_owner = get_page_owner(page_ext);
@@ -172,7 +173,7 @@ static inline void __set_page_owner_hand
 		page_owner->last_migrate_reason = -1;
 		page_owner->pid = current->pid;
 		page_owner->tgid = current->tgid;
-		page_owner->ts_nsec = local_clock();
+		page_owner->ts_nsec = ts_nsec;
 		strscpy(page_owner->comm, current->comm,
 			sizeof(page_owner->comm));
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-page_owner-record-single-timestamp-value-for-high-order-allocations.patch

