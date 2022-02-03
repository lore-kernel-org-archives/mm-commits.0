Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB58C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Feb 2022 23:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbiBCXMU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 18:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbiBCXMT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 18:12:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FCFC061714
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 15:12:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E03BB835EC
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 23:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5833C340E8;
        Thu,  3 Feb 2022 23:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643929936;
        bh=Ynv94u4vBwospwm33bu77BNXQxXT8ECBB1QNNYppX58=;
        h=Date:To:From:Subject:From;
        b=M30KYMm19gKx6KhmxndKnlUJ9HlAxW0KwqqJgKE3xEH0KU2EkQxJFqZ9cSt0WVPS6
         zxhTtPNN6qtnR3+ufBpwaiqiQjQ1g0kRdepF6oHxg+21SC+yZgTmsY4oPFhKlNlv8i
         7vXVo6WPIofwe7U//193RmYnkYmm/Drvl8EFn7TA=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 15:12:15 -0800
Date:   Thu, 03 Feb 2022 15:12:15 -0800
To:     mm-commits@vger.kernel.org, mingo@kernel.org,
        kirill.shutemov@linux.intel.com, jforbes@redhat.com,
        aquini@redhat.com, longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2.patch added to -mm tree
Message-Id: <20220203231215.A5833C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2
has been added to the -mm tree.  Its filename is
     mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2.patch

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
Subject: mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2

Link: https://lkml.kernel.org/r/20220202003550.698768-1-longman@redhat.com
Fixes: 83e3c48729d9 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y")
Fixes: 3e347261a80b ("sparsemem extreme implementation")
Reported-by: Justin Forbes <jforbes@redhat.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2
+++ a/include/linux/mmzone.h
@@ -1390,11 +1390,9 @@ static inline unsigned long *section_to_
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!*mem_section)
+	if (!*mem_section || !mem_section[SECTION_NR_TO_ROOT(nr)])
 		return NULL;
 #endif
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
-		return NULL;
 	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
 }
 extern size_t mem_section_usage_size(void);
_

Patches currently in -mm which might be from longman@redhat.com are

lib-vsprintf-avoid-redundant-work-with-0-size.patch
mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch
mm-page_owner-print-memcg-information.patch
mm-page_owner-record-task-command-name.patch
mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

