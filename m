Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8F1C38A02
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 01:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiJZBtn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 21:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiJZBtl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 21:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BC5272B
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 18:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46E4561C33
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 01:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B44FC433C1;
        Wed, 26 Oct 2022 01:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666748977;
        bh=RCBbB7B5zYVGyVo17woA4oR8j+ekWf2ESsi3MAyATW4=;
        h=Date:To:From:Subject:From;
        b=eosEOz3wLqNsQcwPXSArMHWdOvMz5mjG473e9pG3Sok3KjFcEvkDSWcM7comG1Vm1
         InJYmaxrRfcUDpmVmaovvag7/Zc0RE89P6zU9EsjYKYSmIS2cOskavR0JSLAc3T5zD
         vRmY4ae2PUTei2rxrWFNyDFHnc8EY6dXBM32D0jc=
Date:   Tue, 25 Oct 2022 18:49:36 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mas_find_rev-comment.patch added to mm-unstable branch
Message-Id: <20221026014937.8B44FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_find_rev() comment
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-mas_find_rev-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mas_find_rev-comment.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_find_rev() comment
Date: Tue, 25 Oct 2022 17:38:14 +0000

mas_find_rev() uses mas_prev_entry(), not mas_next_entry(), correct comment.

Link: https://lkml.kernel.org/r/20221025173756.2719616-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-fix-mas_find_rev-comment
+++ a/lib/maple_tree.c
@@ -6056,7 +6056,7 @@ void *mas_find_rev(struct ma_state *mas,
 	if (mas->index < min)
 		return NULL;
 
-	/* Retries on dead nodes handled by mas_next_entry */
+	/* Retries on dead nodes handled by mas_prev_entry */
 	return mas_prev_entry(mas, min);
 }
 EXPORT_SYMBOL_GPL(mas_find);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_find_rev-comment.patch

