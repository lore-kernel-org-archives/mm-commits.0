Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4905C54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjAPU2S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjAPU2R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:28:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF7B35BD
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7559E6112E
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C536BC433D2;
        Mon, 16 Jan 2023 20:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673900895;
        bh=wzR/UCxZP81GHe8BkDcxaUkjuP2B9GTCWdlLJjh2CMk=;
        h=Date:To:From:Subject:From;
        b=qhVJADOsH5gn3mxCoGKeqZLMHFSPdX+/z6XjEti0QMGsY0iVkJ6LeOOVSHsuHVMHk
         HPTd42Px+Z3ENrTx1t5m9LuDXmD/WylNGcVSP2zPgeGbgq2+6t+P7G2qTim3plCdX1
         L1vHLI7KGRS61atlIGSH39Yg8x6s5WNBfKG2KiAw=
Date:   Mon, 16 Jan 2023 12:28:15 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-remove-redundant-initiialization-of-pointer-file.patch added to mm-unstable branch
Message-Id: <20230116202815.C536BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [next] mm/secretmem: remove redundant initiialization of pointer file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-secretmem-remove-redundant-initiialization-of-pointer-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-remove-redundant-initiialization-of-pointer-file.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: [next] mm/secretmem: remove redundant initiialization of pointer file
Date: Mon, 16 Jan 2023 16:43:32 +0000

The pointer file is being initialized with a value that is never read, it
is being re-assigned later on.  Clean up code by removing the redundant
initialization.

Link: https://lkml.kernel.org/r/20230116164332.79500-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/secretmem.c~mm-secretmem-remove-redundant-initiialization-of-pointer-file
+++ a/mm/secretmem.c
@@ -190,7 +190,7 @@ static struct vfsmount *secretmem_mnt;
 
 static struct file *secretmem_file_create(unsigned long flags)
 {
-	struct file *file = ERR_PTR(-ENOMEM);
+	struct file *file;
 	struct inode *inode;
 	const char *anon_name = "[secretmem]";
 	const struct qstr qname = QSTR_INIT(anon_name, strlen(anon_name));
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mm-secretmem-remove-redundant-initiialization-of-pointer-file.patch

