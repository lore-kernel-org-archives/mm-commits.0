Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EF9EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 20:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjGJUYI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 16:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjGJUYH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 16:24:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3744A198
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 13:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 298F7611C6
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 20:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0FDC433C7;
        Mon, 10 Jul 2023 20:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689020643;
        bh=5lTJx7E4odrXVz1Upj6idlWrTGkY3rOOy6SDzjw21qc=;
        h=Date:To:From:Subject:From;
        b=XOOBMUpNGoyuC2wm5XrYo0fKgCTsh/OUbw/x901qycA9LWdzxnsnRLJ+xC992jFM3
         3PqittyBpzxWyZRW+cuIhiyjyv3rE7uH+TTuCUgEJkbUUi+Jrs3CpFTuFsYHy2rtG9
         B7BVnUMpdXQKpqxTc6ehKjxWrvjzf9Ql3/SlwCI4=
Date:   Mon, 10 Jul 2023 13:24:02 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-mark-check_for_memory-as-__init.patch added to mm-unstable branch
Message-Id: <20230710202403.7A0FDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: mark check_for_memory() as __init
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-mark-check_for_memory-as-__init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-mark-check_for_memory-as-__init.patch

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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: mark check_for_memory() as __init
Date: Mon, 10 Jul 2023 09:37:50 +0000

The only caller of check_for_memory() is free_area_init(), which is
annotated with __init, so it should be safe to also mark the former as
__init.

Link: https://lkml.kernel.org/r/20230710093750.1294-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-mark-check_for_memory-as-__init
+++ a/mm/mm_init.c
@@ -1736,7 +1736,7 @@ static void __init free_area_init_node(i
 }
 
 /* Any regular or high memory on that node ? */
-static void check_for_memory(pg_data_t *pgdat)
+static void __init check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
 
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-mark-check_for_memory-as-__init.patch

