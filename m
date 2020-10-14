Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C9EC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C414222255
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708929;
	bh=VEDF5G4LBtqpruWZCDBrV+NFt3jd6YWqL8z55VYXOlA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rOGD7ANWxv211IliTwLEpvD0wwGPUXFZVuC8vz4Sh5ywiqmqcaXvotZGR6Lrwu72Y
	 g1H4g0GZ1/Zvj6eTlnKTYu4NmuXQbMQg8sQ0yQn7LUQ7cJF1I+MIZ7/RYhentuN1t+
	 zd9gciCkOfZXKjwu/T9PWQVytRriiM65TIdBG7aw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgJNUz3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgJNUz3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C200722253;
        Wed, 14 Oct 2020 20:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708928;
        bh=VEDF5G4LBtqpruWZCDBrV+NFt3jd6YWqL8z55VYXOlA=;
        h=Date:From:To:Subject:From;
        b=un00wAD5i4wKJF4PF6DsfukShadZuantGFoyoBYxZs4VLHEyFJZjpsTFp1hryY59G
         gwxzXX/2K7pz7J3Jhox9nYlUdPC7gGG85ABamQa4LLq4xR1f0bNNMznVEUVQ5yUyp8
         o35gKVQW9qWVDzgkakSc78Qdj8Vy/YUTUizO2oBA=
Date:   Wed, 14 Oct 2020 13:55:27 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ast@kernel.org, daniel@iogearbox.net,
        elver@google.com, keescook@chromium.org, masahiroy@kernel.org,
        maskray@google.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sedat.dilek@gmail.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [merged]
 revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch
 removed from -mm tree
Message-ID: <20201014205527.Cj67XCdJx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "arm64: bti: Require clang >= 10.0.1 for in-kernel BTI support"
has been removed from the -mm tree.  Its filename was
     revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Revert "arm64: bti: Require clang >= 10.0.1 for in-kernel BTI support"

This reverts commit b9249cba25a5dce5de87e5404503a5e11832c2dd.

The minimum supported version of clang is now 10.0.1.

Link: https://lkml.kernel.org/r/20200902225911.209899-4-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/Kconfig~revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support
+++ a/arch/arm64/Kconfig
@@ -1612,8 +1612,6 @@ config ARM64_BTI_KERNEL
 	depends on CC_HAS_BRANCH_PROT_PAC_RET_BTI
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94697
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
-	# https://reviews.llvm.org/rGb8ae3fdfa579dbf366b1bb1cbfdbf8c51db7fa55
-	depends on !CC_IS_CLANG || CLANG_VERSION >= 100001
 	depends on !(CC_IS_CLANG && GCOV_KERNEL)
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_REGS)
 	help
_

Patches currently in -mm which might be from ndesaulniers@google.com are


