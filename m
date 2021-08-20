Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27C8C43214
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED7361130
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhHTCEx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 22:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235640AbhHTCEw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 22:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD11610F9;
        Fri, 20 Aug 2021 02:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425055;
        bh=kel0n0GkmccTUY1vmYL1b4mdp5UuRQbGs7GU+pqqAQ0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZNjr+IPe2ctkGTCXO6VflnBDVTFYImMU+rRB/X1b2PDPx8IbtfL21jdhCkgDj27BF
         grK/Lc5JDAKdEHuktq5dD5oj/FNsOMFhEUep7O8Me2pgtnTdKI6bWvQTNEERbPIXIg
         SDruFTg8JlE6Os3sNYvUszwNK4VQ1SbQd1wgy8nk=
Date:   Thu, 19 Aug 2021 19:04:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pcc@google.com, rostedt@goodmis.org,
        rppt@linux.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 04/10] mmflags.h: add missing __GFP_ZEROTAGS and
 __GFP_SKIP_KASAN_POISON names
Message-ID: <20210820020415.5uRw4R9Fk%akpm@linux-foundation.org>
In-Reply-To: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mmflags.h: add missing __GFP_ZEROTAGS and __GFP_SKIP_KASAN_POISON names

printk("%pGg") outputs these two flags as hexadecimal number, rather
than as a string, e.g:

	GFP_KERNEL|0x1800000

Fix this by adding missing names of __GFP_ZEROTAGS and
__GFP_SKIP_KASAN_POISON flags to __def_gfpflag_names.

Link: https://lkml.kernel.org/r/20210816133502.590-1-rppt@kernel.org
Fixes: 013bb59dbb7c ("arm64: mte: handle tags zeroing at page allocation time")
Fixes: c275c5c6d50a ("kasan: disable freed user page poisoning with HW tags")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/trace/events/mmflags.h~mmflagsh-add-missing-__gfp_zerotags-and-__gfp_skip_kasan_poison-names
+++ a/include/trace/events/mmflags.h
@@ -48,7 +48,9 @@
 	{(unsigned long)__GFP_WRITE,		"__GFP_WRITE"},		\
 	{(unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
 	{(unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
-	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"}\
+	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
+	{(unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"},	\
+	{(unsigned long)__GFP_SKIP_KASAN_POISON,"__GFP_SKIP_KASAN_POISON"}\
 
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
_
