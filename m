Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6D7C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiDLXcP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiDLXb5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C31A8FE44
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 15:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A89B6B82058
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CC4C385A5;
        Tue, 12 Apr 2022 21:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649799755;
        bh=A2dedvV0gDCULqoeoNxsRtyD9HsLCSN18jxuRXj2PKE=;
        h=Date:To:From:Subject:From;
        b=GyiOfki7HVmzubbA7ofmbn4dORKXwaAKWWXlYFwBlbUQFP6bAH1clcefXh8RwrhuL
         2edIc9rVre4mzO00em6Wv3cjfvISS4X4K4PeqSTwlEo5lPG8SXZbhfU3fmEyJgyYkt
         y96nrKRwCEFIyMOx+cJvW9mSUG3JNL5pCtvowIdM=
Date:   Tue, 12 Apr 2022 14:42:32 -0700
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        masahiroy@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-kconfig-remove-uselib-syscall-by-default.patch added to -mm tree
Message-Id: <20220412214235.42CC4C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: remove USELIB syscall by default
has been added to the -mm tree.  Its filename is
     init-kconfig-remove-uselib-syscall-by-default.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-kconfig-remove-uselib-syscall-by-default.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-kconfig-remove-uselib-syscall-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: init/Kconfig: remove USELIB syscall by default

The uselib syscall has been long deprecated.  There's no need to keep this
enabled by default under X86_32.

Link: https://lkml.kernel.org/r/20220412212519.4113845-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

init-kconfig-remove-uselib-syscall-by-default.patch

