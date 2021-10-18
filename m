Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A43C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369266113D
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJRWgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhJRWgF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF3F560F0F;
        Mon, 18 Oct 2021 22:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634596434;
        bh=iDGvGi/m7trdfuxJ21U/p3srHM69oYbN59Tdyidq4k8=;
        h=Date:From:To:Subject:From;
        b=jF+9MET91wCarc1pQx8JwCYCTPYoLvPBpJGZb6l8cMf+ILnDrcx2hkosNI2KY09ro
         pQ8wlNzY9dYNCWGwa/I4forGfVEld8H27mpKH3iszXjzJx5TqYi6FbU9Ny1BmtF8Wp
         PBzkc87CyLvZTdIC2KoIe/ao/n2JshyYNDd2uAjM=
Date:   Mon, 18 Oct 2021 15:33:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-pa?=
 =?US-ASCII?Q?ge-fault-vs-folios.patch?= added to -mm tree
Message-ID: <20211018223353.Gw62iz243%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios
has been added to the -mm tree.  Its filename is
     mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios

fix
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
for folio tree PAGEFLAG_FALSE() change.

Cc: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios
+++ a/include/linux/page-flags.h
@@ -803,8 +803,8 @@ PAGEFLAG_FALSE(DoubleMap, double_map)
 PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
 	TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
 #else
-PAGEFLAG_FALSE(HasHWPoisoned)
-	TESTSCFLAG_FALSE(HasHWPoisoned)
+PAGEFLAG_FALSE(HasHWPoisoned, has_hwpoisoned)
+	TESTSCFLAG_FALSE(HasHWPoisoned, has_hwpoisoned)
 #endif
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch

