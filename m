Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26082C4332B
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D285B64F34
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhBZBSq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhBZBSe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:18:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D82BA64F1A;
        Fri, 26 Feb 2021 01:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302274;
        bh=uWjzaaz86y/VYYq7deNhMjooxJDEvDlRP0I7FFSiYgo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=l/wCIN/YUpCnwpn6Am2B/rkUaW8otlx+VjvsPYCyu5Z2Nv+d7m+x+AoBpC/hEV9mx
         JCVQQzHR0xbMi821/RqLLyXn5DT7mUZ73fG3hbDKHVpM4oxdsJ4VYAtY5j9ktRLs4l
         d6Wlkd15E3RwfJ1/zVwt3D6pbhWqmsTjtAFLhQsI=
Date:   Thu, 25 Feb 2021 17:17:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, riel@surriel.com,
        torvalds@linux-foundation.org
Subject:  [patch 040/118] mm/rmap: correct some obsolete comments
 of anon_vma
Message-ID: <20210226011753.Q5VHvNWMS%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: correct some obsolete comments of anon_vma

commit 2b575eb64f7a ("mm: convert anon_vma->lock to a mutex") changed
spinlock used to serialize access to vma list to mutex.  And further, the
commit 5a505085f043 ("mm/rmap: Convert the struct anon_vma::mutex to an
rwsem") converted the mutex to an rwsem for solving scalability problem. 
So replace spinlock with rwsem to make comment uptodate.

Link: https://lkml.kernel.org/r/20210123072459.25903-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-correct-some-obsolete-comments-of-anon_vma
+++ a/mm/rmap.c
@@ -168,7 +168,7 @@ static void anon_vma_chain_link(struct v
  *
  * Anon-vma allocations are very subtle, because we may have
  * optimistically looked up an anon_vma in page_lock_anon_vma_read()
- * and that may actually touch the spinlock even in the newly
+ * and that may actually touch the rwsem even in the newly
  * allocated vma (it depends on RCU to make sure that the
  * anon_vma isn't actually destroyed).
  *
@@ -359,7 +359,7 @@ int anon_vma_fork(struct vm_area_struct
 		goto out_error_free_anon_vma;
 
 	/*
-	 * The root anon_vma's spinlock is the lock actually used when we
+	 * The root anon_vma's rwsem is the lock actually used when we
 	 * lock any of the anon_vmas in this anon_vma tree.
 	 */
 	anon_vma->root = pvma->anon_vma->root;
_
