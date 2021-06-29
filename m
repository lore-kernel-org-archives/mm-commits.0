Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5D5C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0018E61A2B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhF2ChL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2ChL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62C2261CEF;
        Tue, 29 Jun 2021 02:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934083;
        bh=wlhS2E2HZLv8akGNQH5URCXZ0QNDoQvNpKNwGdbsDao=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j02zDDc7Xy5+5lyRsdDUGkAUSULYz7vdPD5ZUxH4sCarVjPhb8bAPDTySErzifTeD
         I0K2l8251h9U/82YhYPftvtTmuBG/pFpzmn0YEWp//smYm/x0js4+kZ86vAxazR6MB
         w0VL55JHR2qYo/Q8co8VB8jHWX2BkKNIICC0uTbg=
Date:   Mon, 28 Jun 2021 19:34:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, pmladek@suse.com, rientjes@google.com,
        songmuchun@bytedance.com, swboyd@chromium.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 027/192] slub: restore slub_debug=- behavior
Message-ID: <20210629023443.gV9pF8mwV%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>
Subject: slub: restore slub_debug=- behavior

Petch series "slub: Print non-hashed pointers in slub debugging", v3.

I was doing some debugging recently and noticed that my pointers were
being hashed while slub_debug was on the kernel commandline.  Let's force
on the no hash pointer option when slub_debug is on the kernel commandline
so that the prints are more meaningful.

The first two patches are something else I noticed while looking at the
code.  The message argument is never used so the debugging messages are
not as clear as they could be and the slub_debug=- behavior seems to be
busted.  Then there's a printf fixup from Joe and the final patch is the
one that force disables pointer hashing.


This patch (of 4):

Passing slub_debug=- on the kernel commandline is supposed to disable slub
debugging.  This is especially useful with CONFIG_SLUB_DEBUG_ON where the
default is to have slub debugging enabled in the build.  Due to some code
reorganization this behavior was dropped, but the code to make it work
mostly stuck around.  Restore the previous behavior by disabling the
static key when we parse the commandline and see that we're trying to
disable slub debugging.

Link: https://lkml.kernel.org/r/20210601182202.3011020-1-swboyd@chromium.org
Link: https://lkml.kernel.org/r/20210601182202.3011020-2-swboyd@chromium.org
Fixes: ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/slub.c~slub-restore-slub_debug=-behavior
+++ a/mm/slub.c
@@ -1429,6 +1429,8 @@ static int __init setup_slub_debug(char
 out:
 	if (slub_debug != 0 || slub_debug_string)
 		static_branch_enable(&slub_debug_enabled);
+	else
+		static_branch_disable(&slub_debug_enabled);
 	if ((static_branch_unlikely(&init_on_alloc) ||
 	     static_branch_unlikely(&init_on_free)) &&
 	    (slub_debug & SLAB_POISON))
_
