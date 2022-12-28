Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD4CC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 21:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiL1VxA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 16:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiL1Vw6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 16:52:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3A8BE1F
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 13:52:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17FD4B818BE
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 21:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7930BC433EF;
        Wed, 28 Dec 2022 21:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672264373;
        bh=POkYUEYZ+U8Ex+oIkwGHnUT5IvSRuHse1/qquX6Drt0=;
        h=Date:To:From:Subject:From;
        b=Rx31luymbuhN/Hqg007mbAxGfXYNilBWEoBfidCnaNi7/HFqwcaFvyQKQ3XDnwC4p
         vNS5XvDGZSBLQ6yb0PFTPR2fsbQmqAIB589H+bLzMYg+yReJ9/xC0Fi/W8a4MXSrD0
         x9s8le76zzUYCzfKXYjeNXvSOCtZ5qKXD5zj6OvE=
Date:   Wed, 28 Dec 2022 13:52:50 -0800
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        hughd@google.com, david@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20221228215253.7930BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix vma->anon_name memory leak for anonymous shmem VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix vma->anon_name memory leak for anonymous shmem VMAs
Date: Wed, 28 Dec 2022 11:42:49 -0800

free_anon_vma_name() is missing a check for anonymous shmem VMA which
leads to a memory leak due to refcount not being dropped.  Fix this by
adding the missing check.

Link: https://lkml.kernel.org/r/20221228194249.170354-1-surenb@google.com
Fixes: d09e8ca6cb93 ("mm: anonymous shared memory naming")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+91edf9178386a07d06a7@syzkaller.appspotmail.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm_inline.h~mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas
+++ a/include/linux/mm_inline.h
@@ -413,7 +413,7 @@ static inline void free_anon_vma_name(st
 	 * Not using anon_vma_name because it generates a warning if mmap_lock
 	 * is not held, which might be the case here.
 	 */
-	if (!vma->vm_file)
+	if (!vma->vm_file || vma_is_anon_shmem(vma))
 		anon_vma_name_put(vma->anon_name);
 }
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-vma-anon_name-memory-leak-for-anonymous-shmem-vmas.patch

