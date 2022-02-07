Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75553C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiBGVAz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiBGVAi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06386C0401E9
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C363CB81705
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A7FC004E1;
        Mon,  7 Feb 2022 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267630;
        bh=ybqDipIik8MhRGCYK4dusWxVwtKTpgpxfagJslwshQQ=;
        h=Date:To:From:Subject:From;
        b=QeXNDKkHvL/YV0WKk3q0eqxkAuiPEveHzkCFhCOl0eDi+BAlZT5ysQdaGW2BKqk8t
         4BumNWpQb0XAGqaYlRRTNJn4EXfcRN71Fc+AoYO3bUy1MbMJDi0lPrhbprIwQecKMe
         wQmw4OxWQl+P1n9tXJgpFw4NLFf1iNGTegbYG/bY=
Date:   Mon, 07 Feb 2022 13:00:30 -0800
To:     mm-commits@vger.kernel.org, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-outline-copy_overflow-fix.patch added to -mm tree
Message-Id: <20220207210030.82A7FC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-outline-copy_overflow-fix
has been added to the -mm tree.  Its filename is
     mm-outline-copy_overflow-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-outline-copy_overflow-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-outline-copy_overflow-fix.patch

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
Subject: mm-outline-copy_overflow-fix

export copy_overflow() to modules

Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/maccess.c~mm-outline-copy_overflow-fix
+++ a/mm/maccess.c
@@ -340,3 +340,4 @@ void copy_overflow(int size, unsigned lo
 {
 	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
 }
+EXPORT_SYMBOL_GPL(copy_overflow);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-outline-copy_overflow-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

