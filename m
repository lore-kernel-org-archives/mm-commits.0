Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979FEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345772AbiCYBgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357423AbiCYBfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C110C12FB
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4E2E60A66
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC29C340ED;
        Fri, 25 Mar 2022 01:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171978;
        bh=Yqef/4gCF+3wIRbTDLruMbf+0m/nC67jRtmJZzUB+OY=;
        h=Date:To:From:Subject:From;
        b=ksdEi4NK/DcDFxW05AjpdRw9Vycb1g0EWP5NL71WrkRMmoe3+QquZ/XgfEe3sAAbH
         vWsILE3H/J/V3Liu/p25No5UsAB52vDNsSOzTnuPf11AaNrl7bAh0vKy3HGscY9lh+
         ScndjKzHymY6i0cgWio4YZuAwTjm9fxKSX1tlcrs=
Date:   Thu, 24 Mar 2022 18:32:57 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        rientjes@google.com, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-highmem-remove-unnecessary-done-label.patch removed from -mm tree
Message-Id: <20220325013258.1CC29C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: remove unnecessary done label
has been removed from the -mm tree.  Its filename was
     mm-highmem-remove-unnecessary-done-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/highmem: remove unnecessary done label

Remove unnecessary done label to simplify the code.

Link: https://lkml.kernel.org/r/20220126092542.64659-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/highmem.c~mm-highmem-remove-unnecessary-done-label
+++ a/mm/highmem.c
@@ -736,11 +736,11 @@ void *page_address(const struct page *pa
 		list_for_each_entry(pam, &pas->lh, list) {
 			if (pam->page == page) {
 				ret = pam->virtual;
-				goto done;
+				break;
 			}
 		}
 	}
-done:
+
 	spin_unlock_irqrestore(&pas->lock, flags);
 	return ret;
 }
@@ -773,13 +773,12 @@ void set_page_address(struct page *page,
 		list_for_each_entry(pam, &pas->lh, list) {
 			if (pam->page == page) {
 				list_del(&pam->list);
-				spin_unlock_irqrestore(&pas->lock, flags);
-				goto done;
+				break;
 			}
 		}
 		spin_unlock_irqrestore(&pas->lock, flags);
 	}
-done:
+
 	return;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

