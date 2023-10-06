Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327D3E94108
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjJFTTE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbjJFTTC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4272BE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:18:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0800AC433C7;
        Fri,  6 Oct 2023 19:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619936;
        bh=/Yu9fSe4bVSsfBtWrQxl4cktw5uTkcOuHqM55TLvscc=;
        h=Date:To:From:Subject:From;
        b=J4RUY6GNW9jyVqJEaAydUrM5bJ0LCD02uum67zjqpyGe6md7GNTHV0UQ6Fn8mcJ1a
         Zw+izQaKxM2tYFy/f2rvrKdNnlkryQYcHw6R9uX354Qs7CMl5/mJCF9sUKrBzFDV+N
         m8cOEBcKSWL/QhWp3M65SLjaQB4Ac7dDM4Gn/idA=
Date:   Fri, 06 Oct 2023 12:18:53 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        ndesaulniers@google.com, mhiramat@kernel.org,
        keescook@chromium.org, arnd@kernel.org, adobriyan@gmail.com,
        paulmck@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-add-boot-loader-arguments-as-comment-to-proc-bootconfig.patch added to mm-nonmm-unstable branch
Message-Id: <20231006191856.0800AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: add boot loader arguments as comment to /proc/bootconfig
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-proc-add-boot-loader-arguments-as-comment-to-proc-bootconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-add-boot-loader-arguments-as-comment-to-proc-bootconfig.patch

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
From: "Paul E. McKenney" <paulmck@kernel.org>
Subject: fs/proc: add boot loader arguments as comment to /proc/bootconfig
Date: Thu, 5 Oct 2023 10:17:46 -0700

In kernels built with CONFIG_BOOT_CONFIG_FORCE=y, /proc/cmdline will show
all kernel boot parameters, both those supplied by the boot loader and
those embedded in the kernel image.  This works well for those who just
want to see all of the kernel boot parameters, but is not helpful to those
who need to see only those parameters supplied by the boot loader.  This
is especially important when these parameters are presented to the boot
loader by automation that might gather them from diverse sources.  It is
also useful when booting the next kernel via kexec(), in which case it is
necessary to supply only those kernel command-line arguments from the boot
loader, and most definitely not those that were embedded into the current
kernel.

Therefore, add comments to /proc/bootconfig of the form:

	# Parameters from bootloader:
	# root=UUID=ac0f0548-a69d-43ca-a06b-7db01bcbd5ad ro quiet ...

The second added line shows only those kernel boot parameters supplied
by the boot loader.

Link: https://lore.kernel.org/all/CAHk-=wjpVAW3iRq_bfKnVfs0ZtASh_aT67bQBG11b4W6niYVUw@mail.gmail.com/
Link: https://lore.kernel.org/all/20230731233130.424913-1-paulmck@kernel.org/
Link: https://lkml.kernel.org/r/20231005171747.541123-2-paulmck@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Co-developed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/bootconfig.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/proc/bootconfig.c~fs-proc-add-boot-loader-arguments-as-comment-to-proc-bootconfig
+++ a/fs/proc/bootconfig.c
@@ -62,6 +62,12 @@ static int __init copy_xbc_key_value_lis
 				break;
 			dst += ret;
 		}
+		if (ret >= 0 && boot_command_line[0]) {
+			ret = snprintf(dst, rest(dst, end), "# Parameters from bootloader:\n# %s\n",
+				       boot_command_line);
+			if (ret > 0)
+				dst += ret;
+		}
 	}
 out:
 	kfree(key);
_

Patches currently in -mm which might be from paulmck@kernel.org are

fs-proc-add-boot-loader-arguments-as-comment-to-proc-bootconfig.patch

