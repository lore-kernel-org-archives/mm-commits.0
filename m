Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F34C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Feb 2022 20:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbiBYU2Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 15:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236763AbiBYU2Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 15:28:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9014F9F3B9
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 12:27:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 445B3B8334C
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 20:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C6AC340E7;
        Fri, 25 Feb 2022 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645820868;
        bh=Gzzp+shmaU7hHLP7ophyNmRFDYzvESBVIwg4ubwfEC0=;
        h=Date:To:From:Subject:From;
        b=FyNDS1VC9t5C8Q4drt9P8P1ITuOU6sccPyqjppfv1cKbPlre/+Vy+aX2rR4u9ONXJ
         6LY6mPpNt7/WcBtBd9GUTcOPddJqAA5tRsBr7Ni6IRxYDWkB9yqMQvc3R+kKigZBVe
         vOhT21GWus2h3fiOjDR/yU4RjOvvjhHt+aLBfZlg=
Date:   Fri, 25 Feb 2022 12:27:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mhocko@suse.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3.patch added to -mm tree
Message-Id: <20220225202748.D3C6AC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3
has been added to the -mm tree.  Its filename is
     mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3

fix comment

Link: https://lkml.kernel.org/r/20220223153613.835563-1-surenb@google.com
Link: https://lkml.kernel.org/r/20220224231834.1481408-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm_inline.h~mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3
+++ a/include/linux/mm_inline.h
@@ -175,7 +175,7 @@ static inline void dup_anon_vma_name(str
 static inline void free_anon_vma_name(struct vm_area_struct *vma)
 {
 	/*
-	 * Not using anon_vma_name because it generates a warning if vma->vm_mm
+	 * Not using anon_vma_name because it generates a warning if mmap_lock
 	 * is not held, which might be the case here.
 	 */
 	if (!vma->vm_file)
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch
mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch
mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3.patch
mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch
mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

