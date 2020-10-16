Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A85CC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3714A20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816495;
	bh=o6h6sHTPzbBGqA+13JqNUYsrSuw57A0h9MTwY4ZFl7E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GUa0ccU8lSlHzapesq7arNdaAbHe8prGqI73qAW3QPBAOFbD4TaT1mmo92MYEMXzx
	 EjZ+8Pmy6timF2njItc5agiEHYi3e9B6GR1K9Vetf4zDQ+lq4JmBOW4EcLzyeQ5P6g
	 Ge9llnZecGMhH67AqFucWN4+XSWn/obGHs2pTw/U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404361AbgJPCsO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbgJPCsO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4C4E2087D;
        Fri, 16 Oct 2020 02:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816494;
        bh=o6h6sHTPzbBGqA+13JqNUYsrSuw57A0h9MTwY4ZFl7E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hc/ZN/h+/jf/+nJgfxUwJNgm/UF46QpabpUK6j53paK3+W55tedT3rMKL2w7A7aW+
         WL4vXT9m4TETPArAZC/R8r99EWUn8tAOxmyFHMmOTBBKJ0tnssbr48iXwsm6ggnnmL
         X9iL6g0Pfj00fQeRcp+4w5rfy37/No4KQ4W6pbJs=
Date:   Thu, 15 Oct 2020 19:48:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, swboyd@chromium.org,
        torvalds@linux-foundation.org, trong@android.com,
        willy@infradead.org
Subject:  [patch 113/156] lib/idr.c: document that
 ida_simple_{get,remove}() are deprecated
Message-ID: <20201016024813.YS2j9xrno%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>
Subject: lib/idr.c: document that ida_simple_{get,remove}() are deprecated

These two functions are deprecated.  Users should call ida_alloc() or
ida_free() respectively instead.  Add documentation to this effect until
the macro can be removed.

Link: https://lkml.kernel.org/r/20200910055246.2297797-2-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Tri Vo <trong@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/idr.h~idr-document-that-ida_simple_getremove-are-deprecated
+++ a/include/linux/idr.h
@@ -314,6 +314,10 @@ static inline void ida_init(struct ida *
 	xa_init_flags(&ida->xa, IDA_INIT_FLAGS);
 }
 
+/*
+ * ida_simple_get() and ida_simple_remove() are deprecated. Use
+ * ida_alloc() and ida_free() instead respectively.
+ */
 #define ida_simple_get(ida, start, end, gfp)	\
 			ida_alloc_range(ida, start, (end) - 1, gfp)
 #define ida_simple_remove(ida, id)	ida_free(ida, id)
_
