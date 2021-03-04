Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC231C4360C
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4DD465003
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242005AbhCDBP7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:15:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346641AbhCDBNh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:13:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B604364ED4;
        Thu,  4 Mar 2021 01:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614820376;
        bh=+HZDlaTru0bA6vsH/RSCVkwykBQzTmstKfBiT4LADj8=;
        h=Date:From:To:Subject:From;
        b=VIRrmm60Zl3fc7ZOCqqEZksAMDl++uv1FueiSngKmAq4leIIgntDns9Tgqduw34PX
         fpVyx17a/au77VSmiyaJn/Hql4lyRXg+J45Z99FwDqD7gNULH+xD2JeiP6kDj776r4
         VHcsnOLfSsJ5vkQl4DntI9FNNEhHPEpOIeTGFeQk=
Date:   Wed, 03 Mar 2021 17:12:56 -0800
From:   akpm@linux-foundation.org
To:     masahiroy@kernel.org, mm-commits@vger.kernel.org
Subject:  +
 compat-remove-unneeded-declaration-from-compat_syscall_definex.patch added
 to -mm tree
Message-ID: <20210304011256.XlnCqe7-w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compat.h: remove unneeded declaration from COMPAT_SYSCALL_DEFINEx()
has been added to the -mm tree.  Its filename is
     compat-remove-unneeded-declaration-from-compat_syscall_definex.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compat-remove-unneeded-declaration-from-compat_syscall_definex.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compat-remove-unneeded-declaration-from-compat_syscall_definex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: include/linux/compat.h: remove unneeded declaration from COMPAT_SYSCALL_DEFINEx()

compat_sys##name is declared twice, just one line below.

With this removal SYSCALL_DEFINEx() (defined in <linux/syscalls.h>)
and COMPAT_SYSCALL_DEFINEx() look symmetrical.

Link: https://lkml.kernel.org/r/20210223114924.854794-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/compat.h~compat-remove-unneeded-declaration-from-compat_syscall_definex
+++ a/include/linux/compat.h
@@ -75,7 +75,6 @@
 	__diag_push();								\
 	__diag_ignore(GCC, 8, "-Wattribute-alias",				\
 		      "Type aliasing is used to sanitize syscall arguments");\
-	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
 	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
 		__attribute__((alias(__stringify(__se_compat_sys##name))));	\
 	ALLOW_ERROR_INJECTION(compat_sys##name, ERRNO);				\
_

Patches currently in -mm which might be from masahiroy@kernel.org are

init-kconfig-make-compile_test-depend-on-has_iomem.patch
compat-remove-unneeded-declaration-from-compat_syscall_definex.patch

