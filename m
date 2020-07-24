Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B52C433E4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B97D2070E
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633900;
	bh=snHDwn3taT0aWkkw9zMufdwpjTPpxyakLX3TLyJLRMc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1lmKQ4S8mAoqKniisjKffvkZJ0xCCIbOej/KGACdY0tjoKKcyCIC/irZSJoU8hzvF
	 yKChzy7Z48l1oeDWhhM9DuUKv56dZ0JGOWghNQ/HQ91NPQ3uQCAbNTanJL8ocMBfy6
	 qlOH192lZ6xfBeS3gGIY0zEmwt4UMwm1QXQz1ptA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGXXiU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgGXXiT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B249206E3;
        Fri, 24 Jul 2020 23:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633899;
        bh=snHDwn3taT0aWkkw9zMufdwpjTPpxyakLX3TLyJLRMc=;
        h=Date:From:To:Subject:From;
        b=iTYNTqaREmttd5m7z7dURHl89NrX+Wf9r3IfbjSWMhYCJW6uMmL1vZpPVsqyNvi5n
         z7TnsOfchQhY8PToFP59oK/BpkKyhJLlO4i4uNq2yXdOomgQHFKQizGYAJWvUZFLMB
         NdAvKDwvIsiJR5ZQz8OVDPv9MCa8vi996F1XsVV0=
Date:   Fri, 24 Jul 2020 16:38:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, trix@redhat.com
Subject:  [merged] mm-initialize-return-of-vm_insert_pages.patch
 removed from -mm tree
Message-ID: <20200724233819.hsl3DHJm4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: initialize return of vm_insert_pages
has been removed from the -mm tree.  Its filename was
     mm-initialize-return-of-vm_insert_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: mm: initialize return of vm_insert_pages

clang static analysis reports a garbage return

In file included from mm/memory.c:84:
mm/memory.c:1612:2: warning: Undefined or garbage value returned to caller [core.uninitialized.UndefReturn]
        return err;
        ^~~~~~~~~~

The setting of err depends on a loop executing.
So initialize err.

Link: http://lkml.kernel.org/r/20200703155354.29132-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-initialize-return-of-vm_insert_pages
+++ a/mm/memory.c
@@ -1601,7 +1601,7 @@ int vm_insert_pages(struct vm_area_struc
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
 #else
 	unsigned long idx = 0, pgcount = *num;
-	int err;
+	int err = -EINVAL;
 
 	for (; idx < pgcount; ++idx) {
 		err = vm_insert_page(vma, addr + (PAGE_SIZE * idx), pages[idx]);
_

Patches currently in -mm which might be from trix@redhat.com are


