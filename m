Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDDEC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80A2322250
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708948;
	bh=ajGdNG+EJyHK+0qsl38YPcOXli6k8ImSBuMbAVu6hFA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Hj/Wh0mgiGXVM044teR6X66ZmTttJKxc0/l/o+qjst07MIMbJQY35c1mJoXvm/GvR
	 ad4KbqmXrSMR1/kmNC0vYrtwkIp4Mm3rju16Z1EViHIv9fgrU4hnajL9ZOcCj99e5C
	 XQeK+m8+HGeIGkoXidGCzNGdl6uPEx5eISEfa7fc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387909AbgJNUzs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNUzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B5B22253;
        Wed, 14 Oct 2020 20:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708947;
        bh=ajGdNG+EJyHK+0qsl38YPcOXli6k8ImSBuMbAVu6hFA=;
        h=Date:From:To:Subject:From;
        b=17/XkTSnw+drCzgrq+G/laWeNxiRA5NWjt/NTIx7SYaN1R8mvfEbe7Y+4ndc5kqlX
         pA/QfGX4z3nUcj0cwMQNYpWLXcoOk5IbTHh0jJ+esdQ+3GT//qvTGG1sw0lQ+iaSBY
         9JLiCcg7CcRsPqO90t5NLNiFbC9uUfL0lkJjo2BA=
Date:   Wed, 14 Oct 2020 13:55:46 -0700
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, jeyu@kernel.org, keescook@chromium.org,
        lkp@intel.com, maennich@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com, will@kernel.org,
        yamada.masahiro@socionext.com
Subject:  [merged]
 exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang.patch
 removed from -mm tree
Message-ID: <20201014205546.1MMBW_qnY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: export.h: fix section name for CONFIG_TRIM_UNUSED_KSYMS for Clang
has been removed from the -mm tree.  Its filename was
     exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: export.h: fix section name for CONFIG_TRIM_UNUSED_KSYMS for Clang

When enabling CONFIG_TRIM_UNUSED_KSYMS, the linker will warn about the
orphan sections:

(".discard.ksym") is being placed in '".discard.ksym"'

repeatedly when linking vmlinux.  This is because the stringification
operator, `#`, in the preprocessor escapes strings.  GCC and Clang differ
in how they treat section names that contain \".

The portable solution is to not use a string literal with the preprocessor
stringification operator.

Link: https://bugs.llvm.org/show_bug.cgi?id=42950
Link: https://github.com/ClangBuiltLinux/linux/issues/1166
Link: https://lkml.kernel.org/r/20200929190701.398762-1-ndesaulniers@google.com
Fixes: commit bbda5ec671d3 ("kbuild: simplify dependency generation for CONFIG_TRIM_UNUSED_KSYMS")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthias Maennich <maennich@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/export.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/export.h~exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang
+++ a/include/linux/export.h
@@ -130,7 +130,7 @@ struct kernel_symbol {
  * discarded in the final link stage.
  */
 #define __ksym_marker(sym)	\
-	static int __ksym_marker_##sym[0] __section(".discard.ksym") __used
+	static int __ksym_marker_##sym[0] __section(.discard.ksym) __used
 
 #define __EXPORT_SYMBOL(sym, sec, ns)					\
 	__ksym_marker(sym);						\
_

Patches currently in -mm which might be from ndesaulniers@google.com are


