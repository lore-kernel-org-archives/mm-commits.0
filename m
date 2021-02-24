Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078EBC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED7364E90
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhBXUB3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235165AbhBXUAx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:00:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE4F164EDD;
        Wed, 24 Feb 2021 20:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196813;
        bh=KhBZu/x9Y9iz441us0rEONmOakIrn2jhUmCr6tbzEwk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pCs3RvokqPXI35YcZF0w7hlyz154yeLcXyV4mkg4u7uJWKRacBykegJidH5PRKthJ
         DYEgzabiw5RyPkzxXS8NmJNqsjEl9VAC/yrCtNf7Ai2NHB4enVyBt4nHPySQe8pwfO
         6hzzckTkojwj1VpLVO1lZWn2NUe+6K8Hnw2RYqSg=
Date:   Wed, 24 Feb 2021 12:00:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bcain@codeaurora.org,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 001/173] hexagon: remove CONFIG_EXPERIMENTAL from
 defconfigs
Message-ID: <20210224200012.M4mVg_RSL%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: hexagon: remove CONFIG_EXPERIMENTAL from defconfigs

Since CONFIG_EXPERIMENTAL was removed in 2013, go ahead and drop it
from any defconfig files.

Link: https://lkml.kernel.org/r/20210115010011.29483-1-rdunlap@infradead.org
Fixes: 3d374d09f16f ("final removal of CONFIG_EXPERIMENTAL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Brian Cain <bcain@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/configs/comet_defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/hexagon/configs/comet_defconfig~hexagon-remove-config_experimental-from-defconfigs
+++ a/arch/hexagon/configs/comet_defconfig
@@ -1,7 +1,6 @@
 CONFIG_SMP=y
 CONFIG_DEFAULT_MMAP_MIN_ADDR=0
 CONFIG_HZ_100=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_CROSS_COMPILE="hexagon-"
 CONFIG_LOCALVERSION="-smp"
 # CONFIG_LOCALVERSION_AUTO is not set
_
