Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7912C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhLIUbY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhLIUbX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:31:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E769BC061746
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 12:27:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF6A2B823C3
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9729C004DD;
        Thu,  9 Dec 2021 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639081667;
        bh=F/Q+HoXWRBs4VuzSjnF935x/kwH9qrQQnDKsJKk/MGE=;
        h=Date:From:To:Subject:From;
        b=CVM4KmCKcVzpzrVa8SHWzixCam8I1nZ/Hv7LFXf8vDbplFtMi4BwnUxHLV0tDaSAR
         wn8r/bgHks6+EUQ5ugIauQl/f1+gMLjKga38VA/gG/i7riSOLifYVRrYZAViHRu1su
         3yLqa9IEA/DJieX1lDMTBjeSQmUGc2qRus5j7KhI=
Date:   Thu, 09 Dec 2021 12:27:46 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, ckennelly@google.com, hjl.tools@gmail.com,
        hughd@google.com, irogers@google.com,
        kirill.shutemov@linux.intel.com, maskray@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, rientjes@google.com, shuah@kernel.org,
        songliubraving@fb.com, sspatil@google.com, surenb@google.com,
        viro@zeniv.linux.org.uk
Subject:  +
 fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch added to -mm
 tree
Message-ID: <20211209202746.60OBIcmnu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: use PT_LOAD p_align values for static PIE
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "H.J. Lu" <hjl.tools@gmail.com>
Subject: fs/binfmt_elf: use PT_LOAD p_align values for static PIE

Extend

commit ce81bb256a224259ab686742a6284930cbe4f1fa
Author: Chris Kennelly <ckennelly@google.com>
Date:   Thu Oct 15 20:12:32 2020 -0700

    fs/binfmt_elf: use PT_LOAD p_align values for suitable start address

which fixed PIE binaries built with -Wl,-z,max-page-size=0x200000, to
cover static PIE binaries.  This fixes:

https://bugzilla.kernel.org/show_bug.cgi?id=215275

Tested by verifying static PIE binaries with -Wl,-z,max-page-size=0x200000
loading.

Link: https://lkml.kernel.org/r/20211209174052.370537-1-hjl.tools@gmail.com
Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie
+++ a/fs/binfmt_elf.c
@@ -1116,11 +1116,11 @@ out_free_interp:
 			 * independently randomized mmap region (0 load_bias
 			 * without MAP_FIXED nor MAP_FIXED_NOREPLACE).
 			 */
-			if (interpreter) {
+			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
+			if (alignment > ELF_MIN_ALIGN) {
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
-				alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
 				if (alignment)
 					load_bias &= ~(alignment - 1);
 				elf_flags |= MAP_FIXED_NOREPLACE;
_

Patches currently in -mm which might be from hjl.tools@gmail.com are

fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch

