Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71DFC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  3 Feb 2022 00:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348295AbiBCAGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Feb 2022 19:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238710AbiBCAGv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Feb 2022 19:06:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B1DC06173B
        for <mm-commits@vger.kernel.org>; Wed,  2 Feb 2022 16:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95EB8616F7
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 00:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE2EC004E1;
        Thu,  3 Feb 2022 00:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643846810;
        bh=TR60d42tFXdtWe7aDkI0sk6x+5KVyTCOz/uRshk8miY=;
        h=Date:To:From:Subject:From;
        b=xVNBTnSwAd2Nq/qhS6oubF0OA+a1At46Qfi33QDbyx5Iql2sFQg+/4e0x7PnbDVqX
         1APzAAkO7G050l32Q0vdDHw6qT8EEFtnuyxG+U1QTEJSx/QiDbbTMxNoENZLWOVKza
         Lj3Mln1XLHg54yaQXmG1zJlW8JQ9PJ1oAPfZdVH0=
Received: by hp1 (sSMTP sendmail emulation); Wed, 02 Feb 2022 16:06:48 -0800
Date:   Wed, 02 Feb 2022 16:06:48 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        rsalvaterra@gmail.com, keescook@chromium.org, hjl.tools@gmail.com,
        ebiederm@xmission.com, rppt@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch added to -mm tree
Message-Id: <20220203000648.BDE2EC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: fix PT_LOAD p_align values for loaders
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: fs/binfmt_elf: fix PT_LOAD p_align values for loaders

Rui Salvaterra reported that Aisleroit solitaire crashes with "Wrong
__data_start/_end pair" assertion from libgc after update to v5.17-rc1.

Bisection pointed to commit 9630f0d60fec ("fs/binfmt_elf: use PT_LOAD
p_align values for static PIE") that fixed handling of static PIEs, but
made the condition that guards load_bias calculation to exclude loader
binaries.

Restoring the check for presence of interpreter fixes the problem.

Link: https://lkml.kernel.org/r/20220202121433.3697146-1-rppt@kernel.org
Fixes: 9630f0d60fec ("fs/binfmt_elf: use PT_LOAD p_align values for static PIE")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders
+++ a/fs/binfmt_elf.c
@@ -1117,7 +1117,7 @@ out_free_interp:
 			 * without MAP_FIXED nor MAP_FIXED_NOREPLACE).
 			 */
 			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
-			if (alignment > ELF_MIN_ALIGN) {
+			if (interpreter || alignment > ELF_MIN_ALIGN) {
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-pgtable-define-pte_index-so-that-preprocessor-could-recognize-it.patch
fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch

