Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76026C43217
	for <mm-commits@archiver.kernel.org>; Sat,  5 Mar 2022 04:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiCEEYl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Mar 2022 23:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiCEEYj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2022 23:24:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552D0532CF
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 20:23:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E058160AFB
        for <mm-commits@vger.kernel.org>; Sat,  5 Mar 2022 04:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37689C004E1;
        Sat,  5 Mar 2022 04:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646454229;
        bh=y9a+fKXN1JIEIA+ytaEfLkYa30rqI9IppW+WReaPLRw=;
        h=Date:To:From:Subject:From;
        b=g6MTSgMwlOCFsB7CdnyIUPS9htBM8FTixbn/sphstQcJMGY8zT/hhngb7ypkkKQN1
         qNHuysm9SUJm+nDxxNDN8fyf2n4CgkxAb/eKOkkC9Uv5SWMEoZtQAH8wKNTGJEo4wt
         Etu4IQlS07QMkKzNGuZ+3rZzZeiryDyQmWINMqFE=
Date:   Fri, 04 Mar 2022 20:23:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mhocko@suse.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3.patch removed from -mm tree
Message-Id: <20220305042349.37689C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3
has been removed from the -mm tree.  Its filename was
     mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3.patch

This patch was dropped because it was folded into mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch

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

mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch
mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch
mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

