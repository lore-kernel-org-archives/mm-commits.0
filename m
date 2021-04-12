Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910A1C43462
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 10:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6656D61366
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 10:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbhDLKD1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbhDLJ5F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Apr 2021 05:57:05 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6702DC06138D
        for <mm-commits@vger.kernel.org>; Mon, 12 Apr 2021 02:56:45 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id y204so5036594wmg.2
        for <mm-commits@vger.kernel.org>; Mon, 12 Apr 2021 02:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x64UxveCRW4RajFKsVGNGXf3lywyRk8W2oXT55aEfiI=;
        b=ZZehmiUQH7HTgWJusG3P63jtuZJ1fOZY0GJgJg9kG2fCHZw7zN5yM4QDuiIlh92iIG
         IdT6FSofFV3YhV7xfTvXE4biJV1u/j+4VPKgZyTa4dG9SycBgjYDN+yUNnuQII2cyHtr
         E9JuRod91aEodPIIFVZKBRM93dHU1O6S6xlcuauyvpADAk8TvIuH6/YrIpVQX1Grz5OD
         wtJNN4VUOTZGzFZJyQkfrujMOHUVD14AFVkXnZhJwzKjUUsk8uKg5lwNISqlW7U0TS19
         9fZ/nxnR/Pc8lnYflzqvoa+iwmOQeyCRKo1xwpCQoNkEuvm3G8o0G85w2kit5WxtzoVw
         F92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x64UxveCRW4RajFKsVGNGXf3lywyRk8W2oXT55aEfiI=;
        b=o3tlGWGI+icskFof49DS/jZ4cvcv73gq/LIA0gFcWNui7AZhZSPYMBw4g1Xjr3/kPZ
         aU+ZIiQnBK+SfYLziVpOmB9TpFC5K2z5jcGh1OyKovv0t2xG68FnRmH+Ktf8idkXP35n
         MyeOnP2fipde/Nlsu6X/Kwy4TxeSETaRw47FkdThPxXQrJ0Tv1r4ZIwdTNFgfeRLCaEz
         w+Jky+AgQ+PkCdvof7b0EC6CCrxRJg6QqAJ5nBQfRY+0DMWbSjHVBU3tpkumaLF+01l7
         vBO1IwHCu7VdJBj+TzRes6IdAYNQc9taAz8gHrm9qrn+uTmzIV3hr0vm6xX7GJzZOAZK
         kRrQ==
X-Gm-Message-State: AOAM530IS4d7BACSwgcR89TD7cqlgzLBRHe7MFMPl/LIzQPp66mMIy7U
        4n7ligzZyiJgJlep9VRIQzz2uw==
X-Google-Smtp-Source: ABdhPJwjgzdRR5eaK7rjE9blp5agPSFon+CFf8CCOZ9jJDid4aph+YE18Sx9zdSCN22W3I0lqG1/UA==
X-Received: by 2002:a05:600c:4f03:: with SMTP id l3mr26080729wmq.149.1618221404054;
        Mon, 12 Apr 2021 02:56:44 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:197c:ad7a:49b7:8f5c])
        by smtp.gmail.com with ESMTPSA id l4sm14539432wmh.8.2021.04.12.02.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 02:56:43 -0700 (PDT)
Date:   Mon, 12 Apr 2021 11:56:37 +0200
From:   Marco Elver <elver@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 05/16] kasan: fix hwasan build for gcc
Message-ID: <YHQZVfVVLE/LDK2v@elver.google.com>
References: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
 <20210409202713.NIELx3Tx9%akpm@linux-foundation.org>
 <CA+fCnZf1ABrQg0dsxtoZa9zM1BSbLYq_Xbu+xi9cv8WAZxdC2g@mail.gmail.com>
 <20210409135836.5fd622e4bec07650774f58c2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409135836.5fd622e4bec07650774f58c2@linux-foundation.org>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 09, 2021 at 01:58PM -0700, Andrew Morton wrote:
> On Fri, 9 Apr 2021 22:39:46 +0200 Andrey Konovalov <andreyknvl@gmail.com> wrote:
> 
> > >
> > >  endif # CONFIG_KASAN_SW_TAGS
> > > _
> > 
> > Hi,
> > 
> > As I commented on the patch, this breaks SW_TAGS build with Clang for me with:
> > 
> > arch/arm64/include/asm/current.h:19: undefined reference to `__hwasan_tls'
> > 
> > The reason for this is that cc-param is only defined for
> > KASAN_GENERIC, the definition needs to be moved.
> > 
> 
> Oh.  I thought that had been fixed.
> 
> Please send a patch?

I think we need something like the below.

Unless a fixed version has already been sent, feel free to squash
(applies immediately after "kasan: fix hwasan build for gcc", and before
the conflicting "kasan: remove redundant config option").

Thanks,
-- Marco

------ >8 ------

From: Marco Elver <elver@google.com>
Date: Sun, 11 Apr 2021 21:32:01 +0200
Subject: [PATCH] fixup for "kasan: fix hwasan build for gcc"

Signed-off-by: Marco Elver <elver@google.com>
---
 scripts/Makefile.kasan | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 0a2789783d1b..127012f45166 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -2,6 +2,8 @@
 CFLAGS_KASAN_NOSANITIZE := -fno-builtin
 KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
 
+cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
+
 ifdef CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_INLINE
@@ -12,8 +14,6 @@ endif
 
 CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
 
-cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
-
 # -fasan-shadow-offset fails without -fsanitize
 CFLAGS_KASAN_SHADOW := $(call cc-option, -fsanitize=kernel-address \
 			-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
-- 
2.31.1.295.g9ea45b61b8-goog

