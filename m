Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3453C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 22:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiGDWhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 18:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiGDWhE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 18:37:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC21BB87A
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 15:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6764D6178B
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 22:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A22C3411E;
        Mon,  4 Jul 2022 22:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656974222;
        bh=gVJ3jRRZ9/k/yQweladufjVrl1/RWSe7CWf4JIfRoEk=;
        h=Date:To:From:Subject:From;
        b=xMZVzz5zYHADI+TP/t66pYTzJ478DZZ6MDwaPPC2C+tUlJ3jqp9PhWl0GFvdtSsrU
         X10edWyDU10O3CLo9trgkIdlTn5ZQOyqGzegW567gAlbQOna5COi5XNWMHfaEihi69
         bQBOEnwxrysjUGKwasnx/Y/hQzznGH3UaWI0zpVw=
Date:   Mon, 04 Jul 2022 15:37:01 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-ts_bmc-remove-redundant-store-to-variable-consumed-after-addition.patch added to mm-nonmm-unstable branch
Message-Id: <20220704223702.B5A22C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ts_bm.c: remove redundant store to variable consumed after addition
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-ts_bmc-remove-redundant-store-to-variable-consumed-after-addition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-ts_bmc-remove-redundant-store-to-variable-consumed-after-addition.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: lib/ts_bm.c: remove redundant store to variable consumed after addition
Date: Mon, 4 Jul 2022 22:53:25 +0100

There is no need to store the result of the addition back to variable
consumed after the addition.  The store is redundant, replace += with just
+

Cleans up clang scan build warning: lib/ts_bm.c:83:11: warning: Although
the value stored to 'consumed' is used in the enclosing expression, the
value is never actually read from 'consumed' [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220704215325.600993-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ts_bm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ts_bm.c~lib-ts_bmc-remove-redundant-store-to-variable-consumed-after-addition
+++ a/lib/ts_bm.c
@@ -80,7 +80,7 @@ static unsigned int bm_find(struct ts_co
 
 			/* London calling... */
 			DEBUGP("found!\n");
-			return consumed += (shift-(bm->patlen-1));
+			return consumed + (shift-(bm->patlen-1));
 
 next:			bs = bm->bad_shift[text[shift-i]];
 
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

lib-ts_bmc-remove-redundant-store-to-variable-consumed-after-addition.patch

