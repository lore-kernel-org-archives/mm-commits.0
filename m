Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D84C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 18:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378973AbjLFSA4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 13:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378944AbjLFSAz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 13:00:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EE618D
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 10:01:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114D5C433C8;
        Wed,  6 Dec 2023 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701885661;
        bh=/u6XDVM6J3JFFjEfkQMaOazzzBzGauJpqXWxVgIQyCo=;
        h=Date:To:From:Subject:From;
        b=eofFuHaYJjnO7Y+M3R0XKOh9IlA1l/XsHDSHaSK7fQe2UZjXSFH4I/izsSv6aeK14
         0owgj+PoJhC4VGSxXHVlGUa0fFvcgF5blxEWruPk0KlKoAItww0pnlZ3L9QNO1pllo
         13c1bM5UPKUsF7BC73NfEvnFRXtpDduCQz2/MhY0=
Date:   Wed, 06 Dec 2023 10:01:00 -0800
To:     mm-commits@vger.kernel.org, chen.haonan2@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-vma_pages-for-vma-objects.patch added to mm-unstable branch
Message-Id: <20231206180101.114D5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vma_pages() for vma objects
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-vma_pages-for-vma-objects.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-vma_pages-for-vma-objects.patch

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
From: Chen Haonan <chen.haonan2@zte.com.cn>
Subject: mm: use vma_pages() for vma objects
Date: Wed, 6 Dec 2023 18:36:27 +0800

vma_pages() is more readable and also better at avoiding error codes, so
use vma_pages() instead of direct operations on vma

Link: https://lkml.kernel.org/r/tencent_151850CF327EB055BBC83298A929BD06CD0A@qq.com
Signed-off-by: Chen Haonan <chen.haonan2@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-use-vma_pages-for-vma-objects
+++ a/mm/internal.h
@@ -616,7 +616,7 @@ folio_within_range(struct folio *folio,
 		unsigned long start, unsigned long end)
 {
 	pgoff_t pgoff, addr;
-	unsigned long vma_pglen = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	unsigned long vma_pglen = vma_pages(vma);
 
 	VM_WARN_ON_FOLIO(folio_test_ksm(folio), folio);
 	if (start > end)
_

Patches currently in -mm which might be from chen.haonan2@zte.com.cn are

mm-use-vma_pages-for-vma-objects.patch

