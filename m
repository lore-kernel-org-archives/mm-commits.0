Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AB1C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 02:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiB1C6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiB1C6q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 21:58:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF9930F79
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 18:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ADA0B80D62
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 02:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944FDC36AE9;
        Mon, 28 Feb 2022 02:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646017085;
        bh=ivKPJTk4Z+fNJ+TsoOcXI+C8HQY8H5uQ5C5sWzC2uiQ=;
        h=Date:To:From:Subject:From;
        b=BVbeuJTGW1/SQZ6L/h6AhyqjVPZSv1Hes8vzWJXRKsXepdcIOiA8ocOQkZH2gB853
         L95dTf4HJGdrL9ncbA8mWBm/nwFpDjs7z1J92zEw4x5M29oSdVPt9DSfKuuPquIBqU
         ZtB4wFIvV4VpnK2QecIcC4KK3IHlRf2qoYpHzL8E=
Date:   Sun, 27 Feb 2022 18:58:04 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        akirakawata1@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5.patch removed from -mm tree
Message-Id: <20220228025805.944FDC36AE9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akira Kawata <akirakawata1@gmail.com>
Subject: fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5

add comment per Kees

Link: https://lkml.kernel.org/r/20220127124014.338760-2-akirakawata1@gmail.com
Signed-off-by: Akira Kawata <akirakawata1@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5
+++ a/fs/binfmt_elf.c
@@ -1170,6 +1170,10 @@ out_free_interp:
 			}
 		}
 
+		/*
+		 * Figure out which segment in the file contains the Program
+		 * Header table, and map to the associated memory address.
+		 */
 		if (elf_ppnt->p_offset <= elf_ex->e_phoff &&
 		    elf_ex->e_phoff < elf_ppnt->p_offset + elf_ppnt->p_filesz) {
 			phdr_addr = elf_ex->e_phoff - elf_ppnt->p_offset +
_

Patches currently in -mm which might be from akirakawata1@gmail.com are


