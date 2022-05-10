Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC8BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbiEJEXt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiEJEXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E852E1C7641
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED6361773
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D468BC385C2;
        Tue, 10 May 2022 04:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156267;
        bh=EsT8kZ1EvPYaLMhu0wAY30/1JzvnTJPKeAcBw6gIxJs=;
        h=Date:To:From:Subject:From;
        b=WD+dfSqE3RBt6yt3Xep4IcBlpc3mz94uTqxuNgJkeHD/glgOrDFbsomhhV+pJrRU+
         yQdAzQLjj2RgcHFiN6yi09LNA7bLQUNNNipD4Fk5kKXxzmQf2tWqaNuGgM5aDpASE5
         K8mA5H4EoxV05NEyp0A2yl0x4onBLLu3yL6qzbhQ=
Date:   Mon, 09 May 2022 21:17:47 -0700
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        masahiroy@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-kconfig-remove-uselib-syscall-by-default.patch removed from -mm tree
Message-Id: <20220510041747.D468BC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init/Kconfig: remove USELIB syscall by default
has been removed from the -mm tree.  Its filename was
     init-kconfig-remove-uselib-syscall-by-default.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: init/Kconfig: remove USELIB syscall by default

The uselib syscall has been long deprecated.  There's no need to keep this
enabled by default under X86_32.

Link: https://lkml.kernel.org/r/20220412212519.4113845-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/Kconfig~init-kconfig-remove-uselib-syscall-by-default
+++ a/init/Kconfig
@@ -435,8 +435,8 @@ config CROSS_MEMORY_ATTACH
 	  See the man page for more details.
 
 config USELIB
-	bool "uselib syscall"
-	def_bool ALPHA || M68K || SPARC || X86_32 || IA32_EMULATION
+	bool "uselib syscall (for libc5 and earlier)"
+	default ALPHA || M68K || SPARC
 	help
 	  This option enables the uselib syscall, a system call used in the
 	  dynamic linker from libc5 and earlier.  glibc does not use this
_

Patches currently in -mm which might be from keescook@chromium.org are


