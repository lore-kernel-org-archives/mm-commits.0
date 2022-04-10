Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C715BC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Apr 2022 04:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiDJElZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Apr 2022 00:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiDJElS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Apr 2022 00:41:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732001157
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 21:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27884B80B83
        for <mm-commits@vger.kernel.org>; Sun, 10 Apr 2022 04:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3361C385A4;
        Sun, 10 Apr 2022 04:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565545;
        bh=71gjNdj0VnNAYvXNbdyWQQCUW50I0YmG0Ckzy4mCA1Q=;
        h=Date:To:From:Subject:From;
        b=gso8d+4vVVJsMSIxFhzTZotP+bsTaFo4Tln/APWQ2FYI5Fy7/nFmqXb3VEy7mf/Bp
         9uYTNNbXzyjOil+c6qWYzyPXiH8YgFhzGMuQRrmvC0h4f7WvmTFm4AadyuRmH0DE1M
         cvC8hGnO1zp2ie2TRiS6gjgDspWsEikWSZRzKbf4=
Date:   Sat, 09 Apr 2022 21:39:05 -0700
To:     mm-commits@vger.kernel.org, mingo@kernel.org,
        kirill.shutemov@linux.intel.com, jforbes@redhat.com,
        aquini@redhat.com, longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch removed from -mm tree
Message-Id: <20220410043905.B3361C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

The gcc 12 compiler reports a "'mem_section' will never be NULL" warning
on the following code:

    static inline struct mem_section *__nr_to_section(unsigned long nr)
    {
    #ifdef CONFIG_SPARSEMEM_EXTREME
        if (!mem_section)
                return NULL;
    #endif
        if (!mem_section[SECTION_NR_TO_ROOT(nr)])
                return NULL;
       :

It happens with CONFIG_SPARSEMEM_EXTREME off.  The mem_section definition
is

    #ifdef CONFIG_SPARSEMEM_EXTREME
    extern struct mem_section **mem_section;
    #else
    extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
    #endif

In the !CONFIG_SPARSEMEM_EXTREME case, mem_section
is a static 2-dimensional array and so the check
"!mem_section[SECTION_NR_TO_ROOT(nr)]" doesn't make sense.

Fix this warning by moving the "!mem_section[SECTION_NR_TO_ROOT(nr)]"
check up inside the CONFIG_SPARSEMEM_EXTREME block and adding an explicit
NR_SECTION_ROOTS check to make sure that there is no out-of-bound array
access.

Link: https://lkml.kernel.org/r/20220331180246.2746210-1-longman@redhat.com
Fixes: 3e347261a80b ("sparsemem extreme implementation")
Signed-off-by: Waiman Long <longman@redhat.com>
Reported-by: Justin Forbes <jforbes@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/include/linux/mmzone.h~mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning
+++ a/include/linux/mmzone.h
@@ -1397,13 +1397,16 @@ static inline unsigned long *section_to_
 
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
+	unsigned long root = SECTION_NR_TO_ROOT(nr);
+
+	if (unlikely(root >= NR_SECTION_ROOTS))
+		return NULL;
+
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!mem_section)
+	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
-		return NULL;
-	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr & SECTION_ROOT_MASK];
 }
 extern size_t mem_section_usage_size(void);
 
_

Patches currently in -mm which might be from longman@redhat.com are

ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

