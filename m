Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FE0EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 20:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjGKU5z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjGKU5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 16:57:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA461709
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 13:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 652A0615D4
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 20:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4A1C433C8;
        Tue, 11 Jul 2023 20:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689109069;
        bh=7b37nSWQTao9y4JwZN/GedNpQjHIOHW7L0tUmVsKv8k=;
        h=Date:To:From:Subject:From;
        b=APPZfl1ghA1k8lU1YctqVdhFeaFKOihdJ8/WVeCHgkWlmvKZLbLC5bUV5DjGjExEs
         zsIYzo9Fe5ASRpT3OhaD0hkQyiDLESXdrezVUpHeje7ZBY74Mj3Z96+XMGtXl2K1j1
         CjF7kDTNfrcMI29B8XSZ76rleYRSav49A/N7FnNs=
Date:   Tue, 11 Jul 2023 13:57:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-add-in_range-macro-fix-4.patch added to mm-unstable branch
Message-Id: <20230711205749.BF4A1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: in_range(): add parentheses
has been added to the -mm mm-unstable branch.  Its filename is
     minmax-add-in_range-macro-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-add-in_range-macro-fix-4.patch

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
Subject: in_range(): add parentheses
Date: Tue Jul 11 01:51:16 PM PDT 2023

fs/ext4/extents.c: In function 'ext4_ext_convert_to_initialized':
./include/linux/minmax.h:184:23: error: logical not is only applied to the left 

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h~minmax-add-in_range-macro-fix-4
+++ a/include/linux/minmax.h
@@ -181,8 +181,8 @@ static inline bool in_range32(u32 val, u
  * Do not blindly replace one form with the other.
  */
 #define in_range(val, start, len)					\
-	sizeof(start) <= sizeof(u32) ? in_range32(val, start, len) :	\
-		in_range64(val, start, len)
+	(sizeof(start) <= sizeof(u32) ? in_range32(val, start, len) :	\
+		in_range64(val, start, len))
 
 /**
  * swap - swap values of @a and @b
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
minmax-add-in_range-macro-fix.patch
minmax-add-in_range-macro-fix-fix.patch
minmax-add-in_range-macro-fix-3.patch
minmax-add-in_range-macro-fix-4.patch
minmax-add-in_range-macro-fix-5.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

