Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F26FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 21:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiL3Vij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3Vii (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 16:38:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC7F183B1
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 13:38:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85B2E60CF0
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 21:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF60C433D2;
        Fri, 30 Dec 2022 21:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672436317;
        bh=9ymTyIW7cWN4+J2ura05gzjQmtkXsFCCiO7Tu70GLBQ=;
        h=Date:To:From:Subject:From;
        b=Or2zrvdj6yqAIB8drdKl6xnY+nWw2FCK5+QszqjfeBpDQEd48zuW8GYNDmbF5ePSw
         JMWSFTIIJ3KuT/GkSvrDObVCR+3lEVREXacH1YD7/WNDD9sCz9Gwr8Gw0q6XBccsni
         7mG+wBpDI/gp8pD+mhk8dmU37gAKO9LctJSOKnCE=
Date:   Fri, 30 Dec 2022 13:38:36 -0800
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-mark-proc-cmdline-as-permanent.patch added to mm-nonmm-unstable branch
Message-Id: <20221230213836.DCF60C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: mark /proc/cmdline as permanent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-mark-proc-cmdline-as-permanent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-mark-proc-cmdline-as-permanent.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: mark /proc/cmdline as permanent
Date: Fri, 30 Dec 2022 12:36:02 +0300

/proc/cmdline is never removed, mark is as permanent for slightly faster
open and close.

Link: https://lkml.kernel.org/r/Y66xAveh2yUsP7m9@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/cmdline.c~proc-mark-proc-cmdline-as-permanent
+++ a/fs/proc/cmdline.c
@@ -17,6 +17,7 @@ static int __init proc_cmdline_init(void
 	struct proc_dir_entry *pde;
 
 	pde = proc_create_single("cmdline", 0, NULL, cmdline_proc_show);
+	pde_make_permanent(pde);
 	pde->size = saved_command_line_len + 1;
 	return 0;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-mark-proc-cmdline-as-permanent.patch

