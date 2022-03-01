Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D81C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 19:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiCATGZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 14:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiCATGZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 14:06:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113FC42484
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 11:05:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70CAC61416
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 19:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA613C340EE;
        Tue,  1 Mar 2022 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646161542;
        bh=5zAGlAJ9hmCMERxeI4OtnyZVVUAhmgFZHGueWrAaJ/s=;
        h=Date:To:From:Subject:From;
        b=AngWelbRHNZfv0mXwH1fhPEEqkHKjPnssoZqAROBqQPZfi87+z1MxHhSt/hadIdwZ
         pJAI8KAUsewG7G6asPLkdTKG7MqB8+kalru88lx2mqa35KL3ulTHO3KlniVR52oJ6h
         LRjQFDOzCd3IcdeUJHpgZ1Nf/47hPfqbScWlEyeA=
Date:   Tue, 01 Mar 2022 11:05:42 -0800
To:     mm-commits@vger.kernel.org, tiberiu.georgescu@nutanix.com,
        sj@kernel.org, shy828301@gmail.com, peterx@redhat.com,
        linmiaohe@huawei.com, ivan.teterevkov@nutanix.com,
        florian.schmidt@nutanix.com, david@redhat.com, corbet@lwn.net,
        ccross@google.com, axelrasmussen@google.com, apopple@nvidia.com,
        aarcange@redhat.com, yun.zhou@windriver.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-documentation-and-description-of-pagemap.patch added to -mm tree
Message-Id: <20220301190542.BA613C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix documentation and description of pagemap
has been added to the -mm tree.  Its filename is
     proc-fix-documentation-and-description-of-pagemap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-fix-documentation-and-description-of-pagemap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-documentation-and-description-of-pagemap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yun Zhou <yun.zhou@windriver.com>
Subject: proc: fix documentation and description of pagemap

Since bit 57 was exported for uffd-wp write-protected(commit
fb8e37f35a2f), fixing it can reduce some unnecessary confusion.

Link: https://lkml.kernel.org/r/20220301044538.3042713-1-yun.zhou@windriver.com
Fixes: fb8e37f35a2fe1 ("mm/pagemap: export uffd-wp protection information")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Tiberiu A Georgescu <tiberiu.georgescu@nutanix.com>
Cc: Florian Schmidt <florian.schmidt@nutanix.com>
Cc: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Colin Cross <ccross@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    2 +-
 fs/proc/task_mmu.c                       |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~proc-fix-documentation-and-description-of-pagemap
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -23,7 +23,7 @@ There are four components to pagemap:
     * Bit  56    page exclusively mapped (since 4.2)
     * Bit  57    pte is uffd-wp write-protected (since 5.13) (see
       :ref:`Documentation/admin-guide/mm/userfaultfd.rst <userfaultfd>`)
-    * Bits 57-60 zero
+    * Bits 58-60 zero
     * Bit  61    page is file-page or shared-anon (since 3.5)
     * Bit  62    page swapped
     * Bit  63    page present
--- a/fs/proc/task_mmu.c~proc-fix-documentation-and-description-of-pagemap
+++ a/fs/proc/task_mmu.c
@@ -1597,7 +1597,8 @@ static const struct mm_walk_ops pagemap_
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
- * Bits 57-60 zero
+ * Bit  57    pte is uffd-wp write-protected
+ * Bits 58-60 zero
  * Bit  61    page is file-page or shared-anon
  * Bit  62    page swapped
  * Bit  63    page present
_

Patches currently in -mm which might be from yun.zhou@windriver.com are

proc-fix-documentation-and-description-of-pagemap.patch

