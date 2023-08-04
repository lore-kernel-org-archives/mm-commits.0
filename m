Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBD3C001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 17:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjHDROH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjHDROH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 13:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86784422B
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 10:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21081620AF
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 17:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75023C433C7;
        Fri,  4 Aug 2023 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691169245;
        bh=Zx5ocVYCigWOxeQhKFtOAJc54UxqnwstkYvNMtxRg5A=;
        h=Date:To:From:Subject:From;
        b=b2k3p245mz8Unac9gtp63uMzU/6k/VVgwF1TBE5ckbZxFXaxUII0DMsTz+UY9AV33
         /s9yx6iakFtS/bLwgn2fwmjdosvlZl690gAFmUn2ulTCZQ9TlIutR5Avlje2IdsZjS
         XCyBbqlhTKvAQbT3uCfz5QKdvoAVjaCWbufSMR0c=
Date:   Fri, 04 Aug 2023 10:14:04 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, linmiaohe@huawei.com,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-no-need-to-export-mm_kobj.patch added to mm-unstable branch
Message-Id: <20230804171405.75023C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: no need to export mm_kobj
has been added to the -mm mm-unstable branch.  Its filename is
     mm-no-need-to-export-mm_kobj.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-no-need-to-export-mm_kobj.patch

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
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mm: no need to export mm_kobj
Date: Fri, 4 Aug 2023 08:43:37 +0200

There are no modules using mm_kobj, so do not export it.

Link: https://lkml.kernel.org/r/2023080436-algebra-cabana-417d@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/mm_init.c~mm-no-need-to-export-mm_kobj
+++ a/mm/mm_init.c
@@ -154,7 +154,6 @@ early_param("mminit_loglevel", set_mmini
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
 struct kobject *mm_kobj;
-EXPORT_SYMBOL_GPL(mm_kobj);
 
 #ifdef CONFIG_SMP
 s32 vm_committed_as_batch = 32;
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

mm-no-need-to-export-mm_kobj.patch
kthread-unexport-__kthread_should_park.patch

