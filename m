Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECC9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbiCVVtu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbiCVVtd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E85ADE8
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 657FEB81DC3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCC0C340EC;
        Tue, 22 Mar 2022 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985682;
        bh=/zLP9MOXMJ3xicO3J2mxQjO4RL4KSCc6UFcpTeEo2EU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=DwjDMB/MusslyG1lX0xvXbA9bEq3/LkMVFSSqg0bgfQWq4pZFVE4rh1ZHAiBxSIDc
         syPAlwZ1wcs2aNPen3qPge4MNfMeTOy/efcwb2fpOqoX216u/aSdLtqewdX0ZBJVZg
         wUJqWK+KrQjSvNoF298hEzlkuh3u0qnWZ5IAj5pA=
Date:   Tue, 22 Mar 2022 14:48:01 -0700
To:     songmuchun@bytedance.com, rientjes@google.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 187/227] mm/highmem: remove unnecessary done label
Message-Id: <20220322214801.EBCC0C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
