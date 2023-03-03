Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8C9C61DA3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 23:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjCCXGP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 18:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjCCXFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 18:05:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A88A5CF
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 15:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBB856199F
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 23:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCA4C433D2;
        Fri,  3 Mar 2023 23:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677884655;
        bh=IV/Melsi1CxqqkmajwQ7773RBu4r5dlvJr86alGEIUE=;
        h=Date:To:From:Subject:From;
        b=1a2LVUQDrQUmTcHQu1gdE3omXPTuTtR4CF7fDJnJcfrnL4+9nncvSkub5V+6WjlzA
         Qzq/MkE8EiNa1bi9awipLXqL4VR6dOvxKdgjCh8lunsGn0CGTy2RoSHq2CWVeKkTqH
         C0hGCc8r8fUfevKgs8ja9uQQyBYnqBcEgAvdH+wM=
Date:   Fri, 03 Mar 2023 15:04:14 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        stevensd@chromium.org, shy828301@gmail.com, hannes@cmpxchg.org,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch added to mm-unstable branch
Message-Id: <20230303230415.2FCA4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: cleanup memcg uncharge for failure path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/khugepaged: cleanup memcg uncharge for failure path
Date: Fri, 3 Mar 2023 10:12:18 -0500

Explicit memcg uncharging is not needed when the memcg accounting has the
same lifespan of the page/folio.  That becomes the case for khugepaged
after Yang & Zach's recent rework so the hpage will be allocated for each
collapse rather than being cached.

Cleanup the explicit memcg uncharge in khugepaged failure path and leave
that for put_page().

Link: https://lkml.kernel.org/r/20230303151218.311015-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/khugepaged.c~mm-khugepaged-cleanup-memcg-uncharge-for-failure-path
+++ a/mm/khugepaged.c
@@ -1136,10 +1136,8 @@ static int collapse_huge_page(struct mm_
 out_up_write:
 	mmap_write_unlock(mm);
 out_nolock:
-	if (hpage) {
-		mem_cgroup_uncharge(page_folio(hpage));
+	if (hpage)
 		put_page(hpage);
-	}
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
 	return result;
 }
@@ -2145,10 +2143,8 @@ xa_unlocked:
 		unlock_page(hpage);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	if (hpage) {
-		mem_cgroup_uncharge(page_folio(hpage));
+	if (hpage)
 		put_page(hpage);
-	}
 
 	trace_mm_khugepaged_collapse_file(mm, hpage, index, is_shmem, addr, file, nr, result);
 	return result;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch

