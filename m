Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3969AC4332E
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C1D664FD3
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBFDGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232383AbhBFC44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 21:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C05C864FB9;
        Fri,  5 Feb 2021 22:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612564850;
        bh=v5to3wJT6oCeBQLjTN/xdPeoqryHgTyVhTgIZGMZkOw=;
        h=Date:From:To:Subject:From;
        b=Bwpc9vmfGlswgKGiVh2JQE2LqdMoEaC5aKBaTzdKSEY24PeWwlc0aLGGtTK7uCqmJ
         +86afy2NfJviKw7VE1qIE6f0rEbL/gJeOCqTeC8bGubyaQmWE1GBgtos06eozP0Tji
         Cb4pl06aYhbfJaxEKQcmTU9+NoSQ45GFly3Zp5eY=
Date:   Fri, 05 Feb 2021 14:40:49 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        neilb@suse.de, willy@infradead.org
Subject:  +
 seq_file-document-how-per-entry-resources-are-managed-fix.patch added to
 -mm tree
Message-ID: <20210205224049.N-BfGYsTj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file-document-how-per-entry-resources-are-managed-fix
has been added to the -mm tree.  Its filename is
     seq_file-document-how-per-entry-resources-are-managed-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/seq_file-document-how-per-entry-resources-are-managed-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/seq_file-document-how-per-entry-resources-are-managed-fix.patch

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
Subject: seq_file-document-how-per-entry-resources-are-managed-fix

fix typo, per Willy

Cc: NeilBrown <neilb@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/seq_file.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/filesystems/seq_file.rst~seq_file-document-how-per-entry-resources-are-managed-fix
+++ a/Documentation/filesystems/seq_file.rst
@@ -218,7 +218,7 @@ is a reasonable thing to do. The seq_fil
 other locks while the iterator is active.
 
 The iterater value returned by start() or next() is guaranteed to be
-passed to a subsequenct next() or stop() call.  This allows resources
+passed to a subsequent next() or stop() call.  This allows resources
 such as locks that were taken to be reliably released.  There is *no*
 guarantee that the iterator will be passed to show(), though in practice
 it often will be.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch

