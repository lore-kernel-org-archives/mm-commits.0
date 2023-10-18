Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDFBCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 14:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345093AbjJRO2h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 10:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345009AbjJRO2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 10:28:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C35112
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 07:28:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443E1C433C8;
        Wed, 18 Oct 2023 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697639314;
        bh=20fmtdmIEpT5OP3z0DL8sbgrcB3RDatc4UCxY4vdLxE=;
        h=Date:To:From:Subject:From;
        b=KT17QaMXpjaVljVBGLNzJVr7KDML2gEucssa7qcU7CVgjbwPeCtz1AxOrBTCQVAGL
         DuOakKy8DPQloxet+l899H9EaW5+u7C2iAtgG+oZKE6mvTuQPR5rHZYMfJJIJ2z9oA
         KAJDIP4yfOPWK/ZrZBAvt1hf1YS9S+bHRGK2fZ7E=
Date:   Wed, 18 Oct 2023 07:28:33 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rostedt@goodmis.org, ndesaulniers@google.com, mhiramat@kernel.org,
        keescook@chromium.org, arnd@kernel.org, adobriyan@gmail.com,
        paulmck@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-proc-add-boot-loader-arguments-as-comment-to-proc-bootconfig.patch removed from -mm tree
Message-Id: <20231018142834.443E1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc: add boot loader arguments as comment to /proc/bootconfig
has been removed from the -mm tree.  Its filename was
     fs-proc-add-boot-loader-arguments-as-comment-to-proc-bootconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Steven Rostedt <rostedt@goodmis.org>
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


