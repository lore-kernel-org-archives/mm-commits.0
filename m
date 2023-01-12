Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B747C46467
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 00:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbjALAPb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 19:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjALAPN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 19:15:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DE7D11F
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 16:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 371D4B81D92
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 00:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFE7C433D2;
        Thu, 12 Jan 2023 00:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482509;
        bh=9d8mKXTGT5TaM8gqVbqpkKPF1lY3vzbJTr37QStgb6o=;
        h=Date:To:From:Subject:From;
        b=eMb9TRfNJ5y05eEgiB/vORoULophCWXRDYiQj3GezeNffzcJN8YZXHW4G/jttkHn0
         DWYDq86EjqYvIOd4wY3zX/6gl1XM3ppw4m8UB/77zoe7a7A83CXezFe4pi/RxejY7h
         qLCemD5Ey1E0ABlV782jvp5MJUFvCgk1KlCjQsPc=
Date:   Wed, 11 Jan 2023 16:15:08 -0800
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        hughd@google.com, david@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch removed from -mm tree
Message-Id: <20230112001509.CBFE7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix vma->anon_name memory leak for anonymous shmem VMAs
has been removed from the -mm tree.  Its filename was
     mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix vma->anon_name memory leak for anonymous shmem VMAs
Date: Wed, 4 Jan 2023 16:02:40 -0800

free_anon_vma_name() is missing a check for anonymous shmem VMA which
leads to a memory leak due to refcount not being dropped.  Fix this by
calling anon_vma_name_put() unconditionally.  It will free vma->anon_name
whenever it's non-NULL.

Link: https://lkml.kernel.org/r/20230105000241.1450843-1-surenb@google.com
Fixes: d09e8ca6cb93 ("mm: anonymous shared memory naming")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+91edf9178386a07d06a7@syzkaller.appspotmail.com
Cc: Hugh Dickins <hughd@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm_inline.h~mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas
+++ a/include/linux/mm_inline.h
@@ -413,8 +413,7 @@ static inline void free_anon_vma_name(st
 	 * Not using anon_vma_name because it generates a warning if mmap_lock
 	 * is not held, which might be the case here.
 	 */
-	if (!vma->vm_file)
-		anon_vma_name_put(vma->anon_name);
+	anon_vma_name_put(vma->anon_name);
 }
 
 static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
_

Patches currently in -mm which might be from surenb@google.com are


