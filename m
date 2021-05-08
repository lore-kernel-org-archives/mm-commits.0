Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40478C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 239EE6142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWyN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEHWyM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D106143B;
        Sat,  8 May 2021 22:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514389;
        bh=0F6YdInNJHIGtTwfVWPBkgcttBRmaxaXsJopegbZnZU=;
        h=Date:From:To:Subject:From;
        b=u4POdPlIoxpfy6cuhXIEIZ//mzi8HkVjau8840vOhyVoioScHNiP58S5NokT1CvQ4
         L1sJpbL3sLEj29zaH/8WI4IwQQJSz9qrLLjKReVlbowzhcwqXrm0LK1arHASX7nXER
         qKbDON+rP3pj1ArESWzWa0Ns1jdK+YYlNm20oP10=
Date:   Sat, 08 May 2021 15:53:09 -0700
From:   akpm@linux-foundation.org
To:     masahiroy@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 compat-remove-unneeded-declaration-from-compat_syscall_definex.patch
 removed from -mm tree
Message-ID: <20210508225309.vqKAme4jr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compat.h: remove unneeded declaration from COMPAT_SYSCALL_DEFINEx()
has been removed from the -mm tree.  Its filename was
     compat-remove-unneeded-declaration-from-compat_syscall_definex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


