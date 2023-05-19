Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C134CC7EE26
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjESVgl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjESVgk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:36:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164D3FB;
        Fri, 19 May 2023 14:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6B156130E;
        Fri, 19 May 2023 21:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB353C433D2;
        Fri, 19 May 2023 21:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532197;
        bh=l35e2dTKuxYIv3AwWoUZwqW/L9F98Nv7KOQTMjQN8Cs=;
        h=Date:To:From:Subject:From;
        b=1eECqefD0obQndkmxuQwOk9/Qo8rniytzKzHdEXK0eATw3KGKQ4rg1B52u41rdF6S
         04X1D9SPeuENkM5Lkj4vGor2HFz+O4kS1AcEuBkZOwYmYhYXWhMEhtkTLj00ZZjTRU
         hl+Q2W/jbIQXRZ3Rk19JPFwLB9WZunU7lYWhbCmk=
Date:   Fri, 19 May 2023 14:36:36 -0700
To:     mm-commits@vger.kernel.org, zwisler@google.com, trix@redhat.com,
        tglx@linutronix.de, stable@vger.kernel.org, rostedt@goodmis.org,
        prudo@redhat.com, paul.walmsley@sifive.com, palmer@rivosinc.com,
        palmer@dabbelt.com, npiggin@gmail.com, ndesaulniers@google.com,
        nathan@kernel.org, mpe@ellerman.id.au, mingo@redhat.com,
        hpa@zytor.com, horms@kernel.org, ebiederm@xmission.com,
        dyoung@redhat.com, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, bp@alien8.de, bhe@redhat.com,
        aou@eecs.berkeley.edu, ribalda@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-support-purgatories-with-texthot-sections.patch added to mm-hotfixes-unstable branch
Message-Id: <20230519213636.EB353C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: support purgatories with .text.hot sections
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-support-purgatories-with-texthot-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-support-purgatories-with-texthot-sections.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ricardo Ribalda <ribalda@chromium.org>
Subject: kexec: support purgatories with .text.hot sections
Date: Fri, 19 May 2023 16:47:36 +0200

Patch series "kexec: Fix kexec_file_load for llvm16 with PGO", v7.

When upreving llvm I realised that kexec stopped working on my test
platform.

The reason seems to be that due to PGO there are multiple .text sections
on the purgatory, and kexec does not supports that.


This patch (of 4):

Clang16 links the purgatory text in two sections when PGO is in use:

  [ 1] .text             PROGBITS         0000000000000000  00000040
       00000000000011a1  0000000000000000  AX       0     0     16
  [ 2] .rela.text        RELA             0000000000000000  00003498
       0000000000000648  0000000000000018   I      24     1     8
  ...
  [17] .text.hot.        PROGBITS         0000000000000000  00003220
       000000000000020b  0000000000000000  AX       0     0     1
  [18] .rela.text.hot.   RELA             0000000000000000  00004428
       0000000000000078  0000000000000018   I      24    17     8

And both of them have their range [sh_addr ... sh_addr+sh_size] on the
area pointed by `e_entry`.

This causes that image->start is calculated twice, once for .text and
another time for .text.hot. The second calculation leaves image->start
in a random location.

Because of this, the system crashes immediately after:

kexec_core: Starting new kernel

Link: https://lkml.kernel.org/r/20230321-kexec_clang16-v7-0-b05c520b7296@chromium.org
Link: https://lkml.kernel.org/r/20230321-kexec_clang16-v7-1-b05c520b7296@chromium.org
Fixes: 930457057abe ("kernel/kexec_file.c: split up __kexec_load_puragory")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Ross Zwisler <zwisler@google.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Philipp Rudo <prudo@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Rix <trix@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/kernel/kexec_file.c~kexec-support-purgatories-with-texthot-sections
+++ a/kernel/kexec_file.c
@@ -901,10 +901,22 @@ static int kexec_purgatory_setup_sechdrs
 		}
 
 		offset = ALIGN(offset, align);
+
+		/*
+		 * Check if the segment contains the entry point, if so,
+		 * calculate the value of image->start based on it.
+		 * If the compiler has produced more than one .text section
+		 * (Eg: .text.hot), they are generally after the main .text
+		 * section, and they shall not be used to calculate
+		 * image->start. So do not re-calculate image->start if it
+		 * is not set to the initial value, and warn the user so they
+		 * have a chance to fix their purgatory's linker script.
+		 */
 		if (sechdrs[i].sh_flags & SHF_EXECINSTR &&
 		    pi->ehdr->e_entry >= sechdrs[i].sh_addr &&
 		    pi->ehdr->e_entry < (sechdrs[i].sh_addr
-					 + sechdrs[i].sh_size)) {
+					 + sechdrs[i].sh_size) &&
+		    !WARN_ON(kbuf->image->start != pi->ehdr->e_entry)) {
 			kbuf->image->start -= sechdrs[i].sh_addr;
 			kbuf->image->start += kbuf->mem + offset;
 		}
_

Patches currently in -mm which might be from ribalda@chromium.org are

kexec-support-purgatories-with-texthot-sections.patch
x86-purgatory-remove-pgo-flags.patch
powerpc-purgatory-remove-pgo-flags.patch
riscv-purgatory-remove-pgo-flags.patch

