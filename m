Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C297C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC25E64EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhBZBX1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhBZBWv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4AFD64F46;
        Fri, 26 Feb 2021 01:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302536;
        bh=npd51zvtuSRyDukwVobHPPJmeu3pdjj7Lu4TqiM3zFo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IVTSFo/pCq4r1OEzCuXgFmC4I+xNLmVtlQO7/6AhndiwFvx4H4zjsH33CPMbxUNk7
         rbpzCj4fQShXaCjIZIMAjTibtrdSkHV0hH2+4VnX/I6uGp77vK/VsbHOyUcB4eTWmv
         thUFLSjPSB3y1M1EuexVtbVyym7UStXEqTZsNDcM=
Date:   Thu, 25 Feb 2021 17:22:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, johan@kernel.org,
        linux-mm@kvack.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, ndesaulniers@gooogle.com,
        ojeda@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 109/118] init: clean up early_param_on_off() macro
Message-ID: <20210226012215.RdZaZD3LS%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>
Subject: init: clean up early_param_on_off() macro

Use early_param() to define early_param_on_off().

Link: https://lkml.kernel.org/r/20210201041532.4025025-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Nick Desaulniers <ndesaulniers@gooogle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/init.h~init-clean-up-early_param_on_off-macro
+++ a/include/linux/init.h
@@ -338,14 +338,14 @@ struct obs_kernel_param {
 		var = 1;						\
 		return 0;						\
 	}								\
-	__setup_param(str_on, parse_##var##_on, parse_##var##_on, 1);	\
+	early_param(str_on, parse_##var##_on);				\
 									\
 	static int __init parse_##var##_off(char *arg)			\
 	{								\
 		var = 0;						\
 		return 0;						\
 	}								\
-	__setup_param(str_off, parse_##var##_off, parse_##var##_off, 1)
+	early_param(str_off, parse_##var##_off)
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
_
