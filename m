Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F31C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377938AbiATVbN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60446 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377936AbiATVbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9272BB81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB043C340E0;
        Thu, 20 Jan 2022 21:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714270;
        bh=8fgwYIhZmZjldc6tqsBkL6dcF8HcM0+l1os0aDylagI=;
        h=Date:From:To:Subject:From;
        b=YpEhuz7R63ED6qu4vZGXc7LTEX/kOHvG/Nsm2BHsGUg0+Ibn92e8/mD6AK0YlwDih
         nL9K4sv3oZZtoPdsYmEgm/oPE8lKRLsfOTJOzXwU96nRqZOqDPks900bjB/d3bagsO
         SLwQs3NVItwzyEBz7cBKNDNSJFiad2FeZg4DOJU0=
Date:   Thu, 20 Jan 2022 13:31:09 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, ckennelly@google.com, hjl.tools@gmail.com,
        hughd@google.com, irogers@google.com,
        kirill.shutemov@linux.intel.com, maskray@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, rientjes@google.com, shuah@kernel.org,
        songliubraving@fb.com, sspatil@google.com, surenb@google.com,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch removed from
 -mm tree
Message-ID: <20220120213109.uaSFDybOp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: use PT_LOAD p_align values for static PIE
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


