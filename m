Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B047C77B7D
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 21:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244559AbjEOVBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 17:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240909AbjEOVBc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 17:01:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70C9D050
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 14:01:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2304762376
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 21:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCFAC433EF;
        Mon, 15 May 2023 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684184477;
        bh=2MeEpdTmfLd4VwOV/1XZCH/QCnmMCthKM0wVawEB6Dc=;
        h=Date:To:From:Subject:From;
        b=siRl9JslH+ttxhBP74hsSnUpL1hI/xsg72bhGDhod17uZ4+0Ok0y2CU82gVS/gEub
         Vv3Yg4Nnc0ddLKV5Fs2NU9cI3sA8K3N5Nz4yRNWmFaH4l0AqFQzvs9yFJSeA/U6Wr9
         eObwN8MYQBsAP6WGWdTP0fObb9OEUZrpu/D/pJEc=
Date:   Mon, 15 May 2023 14:01:16 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix.patch added to mm-unstable branch
Message-Id: <20230515210117.7CCFAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix
Date: Mon May 15 01:53:28 PM PDT 2023

fix missed kernel/trace/trace_events_user.c

Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_events_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_user.c~mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix
+++ a/kernel/trace/trace_events_user.c
@@ -406,7 +406,7 @@ static int user_event_enabler_write(stru
 		return -EBUSY;
 
 	ret = pin_user_pages_remote(mm->mm, uaddr, 1, FOLL_WRITE | FOLL_NOFAULT,
-				    &page, NULL, NULL);
+				    &page, NULL);
 
 	if (unlikely(ret <= 0)) {
 		if (!fixup_fault)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch

