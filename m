Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E461EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiA0WOu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbiA0WOu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:14:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1970EC061714
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 14:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 796F861BAD
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71E9C340E4;
        Thu, 27 Jan 2022 22:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643321688;
        bh=9M1ZPJVyf5r7I1kqqjsWbwf+kjGLSqAaIHw85O/NtlE=;
        h=Date:From:To:Subject:From;
        b=0+Whe0sHJ+Y1l+Or/WuyWsobHDr1M3keleHpbgcEw8IULqJHHh7p0ChkRjfU5xCQJ
         YWCmarxPCh7tp//eC8XhQPugQMu+Go8Z8LSZNYcqD96YtkZGhHtYaQJjqAOqEPiH77
         lriEicjrQjjM8ucKERB9D1j3PzxUTiUh3SzlmYNQ=
Date:   Thu, 27 Jan 2022 14:14:48 -0800
From:   akpm@linux-foundation.org
To:     akirakawata1@gmail.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  +
 fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5.patch added to -mm tree
Message-ID: <20220127221448.1-CwX5BhV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch
fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files-v5.patch
fs-binfmt_elf-refactor-load_elf_binary-function.patch

