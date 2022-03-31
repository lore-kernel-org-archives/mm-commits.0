Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399C4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 02:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiCaCEp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 22:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiCaCEo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 22:04:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD956661B
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 19:02:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21C63B81E23
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AA7C340EC;
        Thu, 31 Mar 2022 02:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648692175;
        bh=2c1Nrn7FcpFJFvaQ4Klbjxin2CosJnFzrK/nBFnS2zo=;
        h=Date:To:From:Subject:From;
        b=VtnRR9X4h6vC8U8D4Ya4hhRZMGUxtFl8Ny4MWOjxxm1rfcc7CXlHKvfLjmtdhDNaH
         6ZEt2ELtF1ovxiJfQhc/18Jb5SmzS4VrozSD6/dXVeYO2tQIevf+DaEXKLqOiRLFCO
         POQiiMaARt7B1xfssu9/py1EvC06e5Lc9LzdD8BI=
Date:   Wed, 30 Mar 2022 19:02:55 -0700
To:     mm-commits@vger.kernel.org, mingo@kernel.org,
        kirill.shutemov@linux.intel.com, jforbes@redhat.com,
        aquini@redhat.com, longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch added to -mm tree
Message-Id: <20220331020255.C2AA7C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparsemem: Fix 'mem_section' will never be NULL gcc 12 warning
has been added to the -mm tree.  Its filename is
     mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/sparsemem: Fix 'mem_section' will never be NULL gcc 12 warning

The gcc 12 compiler reports a "'mem_section' will never be NULL"
warning on the following code:

    static inline struct mem_section *__nr_to_section(unsigned long nr)
    {
    #ifdef CONFIG_SPARSEMEM_EXTREME
        if (!mem_section)
                return NULL;
    #endif
        if (!mem_section[SECTION_NR_TO_ROOT(nr)])
                return NULL;
       :

It happens with CONFIG_SPARSEMEM_EXTREME off. The mem_section
definition is

    #ifdef CONFIG_SPARSEMEM_EXTREME
    extern struct mem_section **mem_section;
    #else
    extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
    #endif

In the !CONFIG_SPARSEMEM_EXTREME case, mem_section
is a static 2-dimensional array and so the check
"!mem_section[SECTION_NR_TO_ROOT(nr)]" doesn't make sense.

Fix this warning by moving the "!mem_section[SECTION_NR_TO_ROOT(nr)]"
check up inside the CONFIG_SPARSEMEM_EXTREME block.

Link: https://lkml.kernel.org/r/20220330205919.2713275-1-longman@redhat.com
Fixes: 3e347261a80b ("sparsemem extreme implementation")
Signed-off-by: Waiman Long <longman@redhat.com>
Reported-by: Justin Forbes <jforbes@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning
+++ a/include/linux/mmzone.h
@@ -1398,11 +1398,9 @@ static inline unsigned long *section_to_
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!mem_section)
+	if (!mem_section || !mem_section[SECTION_NR_TO_ROOT(nr)])
 		return NULL;
 #endif
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
-		return NULL;
 	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
 }
 extern size_t mem_section_usage_size(void);
_

Patches currently in -mm which might be from longman@redhat.com are

mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

