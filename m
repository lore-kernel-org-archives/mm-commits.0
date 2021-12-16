Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC73C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 22:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhLPWXk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:23:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55232 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhLPWXk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 17:23:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B32B82654
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 22:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF363C36AE7;
        Thu, 16 Dec 2021 22:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639693418;
        bh=CCfyA/ianmm5hcIzaqq1OmgaMJdFi0iufJcngc4SAv8=;
        h=Date:From:To:Subject:From;
        b=iqCmM8Z2HODvD+3UqTs7cVaUH+cruJtKOyoZLXdYb7ZMoG7AwcCd8tY2ViyBHib1j
         zd6zAVYU2LNDD0wcY6Wi23lBq5IKVLlDFaa1xvot1EVgwRlE1ygmFj0p9XrrJeDxrw
         c3qj3GHpoBC0s01p2RCh/7oYzLruzFb48HGFJXyo=
Date:   Thu, 16 Dec 2021 14:23:37 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jirislaby@gmail.com,
        edumazet@google.com, vbabka@suse.cz
Subject:  +
 =?us-ascii?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-allocat?=
 =?us-ascii?Q?ion-by-kvmalloc-fixup4.patch?= added to -mm tree
Message-ID: <20211216222337.2t2-w%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup4
has been added to the -mm tree.  Its filename is
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup4

Due to 4e66934eaadc ("lib: add reference counting tracking
infrastructure") landing recently to net-next adding a new stack depot
user in lib/ref_tracker.c we need to add an appropriate call to
stack_depot_init() there as well.

Link: https://lkml.kernel.org/r/45c1b738-1a2f-5b5f-2f6d-86fab206d01c@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Slab <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ref_tracker.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/ref_tracker.h~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4
+++ a/include/linux/ref_tracker.h
@@ -4,6 +4,7 @@
 #include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/stackdepot.h>
 
 struct ref_tracker;
 
@@ -26,6 +27,7 @@ static inline void ref_tracker_dir_init(
 	spin_lock_init(&dir->lock);
 	dir->quarantine_avail = quarantine_count;
 	refcount_set(&dir->untracked, 1);
+	stack_depot_init();
 }
 
 void ref_tracker_dir_exit(struct ref_tracker_dir *dir);
_

Patches currently in -mm which might be from vbabka@suse.cz are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4.patch

