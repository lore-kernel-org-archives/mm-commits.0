Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B550C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiD2Qdj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379241AbiD2QcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:32:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BC7DAFC1
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:28:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35B316233A
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7C3C385A4;
        Fri, 29 Apr 2022 16:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249734;
        bh=hPM2hsW28KrCS5ZJkKvdMDHxjFx6NnuXMap6/WFW/sM=;
        h=Date:To:From:Subject:From;
        b=go2yVyoiQrgopnMXr/kgSWclACQ6a3TgDAZ1e2zdk4z7Iay1xvu1LSvkw4hK445kk
         azxP5tG5vTUN4kwjxO8vwPhzKFFWsdCN8V+BT2X3dL8+dbRpIazoQbkSvzd4fGimPQ
         OzpU/v1PCkyBqjhOo7ic/iElTUG+t2YNWP3lWE9Q=
Date:   Fri, 29 Apr 2022 09:28:53 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + elf-uapi-fixup-elf_st_type-definition.patch added to mm-nonmm-unstable branch
Message-Id: <20220429162854.8B7C3C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ELF, uapi: fixup ELF_ST_TYPE definition
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     elf-uapi-fixup-elf_st_type-definition.patch

This patch should soon appear in the mm-nonmm-unstable branch at
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
Subject: ELF, uapi: fixup ELF_ST_TYPE definition

This is very theoretical compile failure:

	ELF_ST_TYPE(st_info = A)

Cast will bind first and st_info will stop being lvalue:

	error: lvalue required as left operand of assignment

Given that the only use of this macro is

	ELF_ST_TYPE(sym->st_info)

where st_info is "unsigned char" I've decided to remove cast especially
given that companion macro ELF_ST_BIND doesn't use cast.

Link: https://lkml.kernel.org/r/Ymv7G1BeX4kt3obz@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/elf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/elf.h~elf-uapi-fixup-elf_st_type-definition
+++ a/include/uapi/linux/elf.h
@@ -134,7 +134,7 @@ typedef __s64	Elf64_Sxword;
 #define STT_TLS     6
 
 #define ELF_ST_BIND(x)		((x) >> 4)
-#define ELF_ST_TYPE(x)		(((unsigned int) x) & 0xf)
+#define ELF_ST_TYPE(x)		((x) & 0xf)
 #define ELF32_ST_BIND(x)	ELF_ST_BIND(x)
 #define ELF32_ST_TYPE(x)	ELF_ST_TYPE(x)
 #define ELF64_ST_BIND(x)	ELF_ST_BIND(x)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch
elf-uapi-fixup-elf_st_type-definition.patch

