Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9082C43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85459613C5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhEGBEw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhEGBEw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26A21613C5;
        Fri,  7 May 2021 01:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349433;
        bh=zKi5RAC+Tbh/n7JjYPk+t7J/tmTUJEcKJKv0xSSBXgs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D60tu+9a5zEdutEbzsRX6BCeKk+RtfYlPAkq+7HBHL/Zs0Il5JptGZZXsWj0vqxO2
         M7RQIbXmuMquu5FJAnXefozGUY3PNCz5k2JDua/japT/MpXLKJeFe2mH0Mp3/c6/MN
         LglAcI1gdTwU9r0k/pVpuzuf3Gvcat1MznIM2Vgs=
Date:   Thu, 06 May 2021 18:03:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 35/91] include/linux/compat.h: remove unneeded
 declaration from COMPAT_SYSCALL_DEFINEx()
Message-ID: <20210507010352.VzagWgRH2%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
