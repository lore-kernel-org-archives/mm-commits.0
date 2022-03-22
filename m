Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70B3C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbiCVVtU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbiCVVs4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B6C60065
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4428B61666
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4D1C340EC;
        Tue, 22 Mar 2022 21:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985645;
        bh=ie5oGyxFVGCmNbNWfhit0ER4qM+rx5o2roKxzo/Yspw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=DsrlBd6LYdCqB5WYWmmx1lC715pxpsyad84nYsBPDx1S9uIoVkSZuNBfN5WmjUfLC
         tGdjdK2/vmqImvp75RHXNC5Ef3jDIN/GmzHmvEw5BJJqJx8duZEEVBC3TfEsz/2haN
         LcUvkGqpY64aUvkvT+GIXgXtWfEVpAcWk2geRSMo=
Date:   Tue, 22 Mar 2022 14:47:24 -0700
To:     osalvador@suse.de, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 175/227] mm/memory_hotplug: fix misplaced comment in offline_pages
Message-Id: <20220322214725.9C4D1C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: fix misplaced comment in offline_pages

It's misplaced since commit 7960509329c2 ("mm, memory_hotplug: print
reason for the offlining failure").  Move it to the right place.

Link: https://lkml.kernel.org/r/20220207133643.23427-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-misplaced-comment-in-offline_pages
+++ a/mm/memory_hotplug.c
@@ -1963,6 +1963,7 @@ int __ref offline_pages(unsigned long st
 	return 0;
 
 failed_removal_isolated:
+	/* pushback to free area */
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
@@ -1973,7 +1974,6 @@ failed_removal:
 		 (unsigned long long) start_pfn << PAGE_SHIFT,
 		 ((unsigned long long) end_pfn << PAGE_SHIFT) - 1,
 		 reason);
-	/* pushback to free area */
 	mem_hotplug_done();
 	return ret;
 }
_
