Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0231AC71153
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjIDTer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjIDTeq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:34:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EA31701
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:34:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5035CE0FA6
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21410C433C8;
        Mon,  4 Sep 2023 19:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693856051;
        bh=QbOeRxCSpegBTKPgUO7noeIrwCdW0jewrXeBUAVpnrM=;
        h=Date:To:From:Subject:From;
        b=wDGXj9UP3FKMFE3XPsgKYfCrPrXCdLD6370tKzSHbDdzHyfTJIIozZEfS/qP/XkDA
         lky8QVjKxbtPyXhEBx0vQ1/+CrpTb9tIf3dfnjl8Yq5XOA0sxJSakP/D180cxMHoIi
         hQ2dUmGF7ZSq3pZg/BS7obNd4QdHKXhg2IxOjYmM=
Date:   Mon, 04 Sep 2023 12:34:10 -0700
To:     mm-commits@vger.kernel.org, linux@roeck-us.net, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc64-add-missing-initialization-of-folio-in-tlb_batch_add.patch added to mm-unstable branch
Message-Id: <20230904193411.21410C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc64: add missing initialization of folio in tlb_batch_add()
has been added to the -mm mm-unstable branch.  Its filename is
     sparc64-add-missing-initialization-of-folio-in-tlb_batch_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc64-add-missing-initialization-of-folio-in-tlb_batch_add.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: sparc64: add missing initialization of folio in tlb_batch_add()
Date: Mon, 4 Sep 2023 20:37:59 +0300

Commit 1a10a44dfc1d ("sparc64: implement the new page table range API")
missed initialization of folio variable in tlb_batch_add() which causes
boot tests to crash.

Add missing initialization.

Link: https://lkml.kernel.org/r/20230904174350.GF3223@kernel.org
Fixes: 1a10a44dfc1d ("sparc64: implement the new page table range API")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/mm/tlb.c~sparc64-add-missing-initialization-of-folio-in-tlb_batch_add
+++ a/arch/sparc/mm/tlb.c
@@ -301,3 +301,4 @@ pgtable_t pgtable_trans_huge_withdraw(st
 	return pgtable;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+Mon Sep  4 12:33:06 PM PDT 2023
_

Patches currently in -mm which might be from rppt@kernel.org are

sparc64-add-missing-initialization-of-folio-in-tlb_batch_add.patch

