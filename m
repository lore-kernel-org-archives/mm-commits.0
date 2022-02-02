Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB3AC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Feb 2022 00:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiBBACK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 19:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243057AbiBBACK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 19:02:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274A0C061714
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 16:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96F72CE1AFE
        for <mm-commits@vger.kernel.org>; Wed,  2 Feb 2022 00:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5201C340EB;
        Wed,  2 Feb 2022 00:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643760126;
        bh=v7I504ZDwSv9yYb5LmjAqWzoIzZwhfMBidkrw3mjHJQ=;
        h=Date:To:From:Subject:From;
        b=R3NtvUgbGLkofaollmjA4FdSzVFBPQicjvwJ/f6WM+IXRMbYTTRk6kjyM0SMpFMZG
         qTPjH4GKSl+UnbiABIJG0FNGoJOeGHMSLZdVZkiUItwr53vjIv0TPStkjIR01J9fIi
         5iKgZmiVIpdowzyXpjHlOvbTm1a4xzF7b2hXhoFI=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 16:02:05 -0800
Date:   Tue, 01 Feb 2022 16:02:05 -0800
To:     mm-commits@vger.kernel.org, neilb@suse.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch added to -mm tree
Message-Id: <20220202000205.C5201C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: remove-bdi_congested-and-wb_congested-and-related-functions-fix
has been added to the -mm tree.  Its filename is
     remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch

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
Subject: remove-bdi_congested-and-wb_congested-and-related-functions-fix

fix build

fs/nilfs2/segbuf.c: In function 'nilfs_segbuf_submit_bio':
fs/nilfs2/segbuf.c:358:2: error: label 'failed' defined but not used [-Werror=unused-label]

Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nilfs2/segbuf.c~remove-bdi_congested-and-wb_congested-and-related-functions-fix
+++ a/fs/nilfs2/segbuf.c
@@ -355,7 +355,6 @@ static int nilfs_segbuf_submit_bio(struc
 	wi->start = wi->end;
 	return 0;
 
- failed:
 	wi->bio = NULL;
 	return err;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

