Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AAFC77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbjDFCxu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjDFCx3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427EC93FE
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A922864086
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110CCC433EF;
        Thu,  6 Apr 2023 02:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749585;
        bh=3to92UlghB3Yd8++rgi0JXDLtxt10LVzNt2OQO0uGm0=;
        h=Date:To:From:Subject:From;
        b=rNHTYqmdZg3IFDpko3s/VlXOZ8NUSNEjF+0xF+b2Blw2uZD6dV96GMaKRO0atLPvC
         zapG2OLovcmKWhsPD8swGKo59dxjqlbWpJbFeTZgtHg5Ql89lw+Eg7fKDeiImyhiFY
         htvu82gwIIxnR+IAR/8/GdMK0WHRo1djNN4BE1ZQ=
Date:   Wed, 05 Apr 2023 19:53:04 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-uninline-kstrdup.patch removed from -mm tree
Message-Id: <20230406025305.110CCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: uninline kstrdup()
has been removed from the -mm tree.  Its filename was
     mm-uninline-kstrdup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: mm: uninline kstrdup()
Date: Tue, 28 Feb 2023 18:34:38 +0300

gcc inlines kstrdup into kstrdup_const() but it can very efficiently tail
call into it instead:

	$ ./scripts/bloat-o-meter ../vmlinux-000 ../obj/vmlinux
	add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-84 (-84)
	Function                                     old     new   delta
	kstrdup_const                                119      35     -84

Link: https://lkml.kernel.org/r/Y/4fDlbIhTLNLFHz@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/util.c~mm-uninline-kstrdup
+++ a/mm/util.c
@@ -49,6 +49,7 @@ EXPORT_SYMBOL(kfree_const);
  *
  * Return: newly allocated copy of @s or %NULL in case of error
  */
+noinline
 char *kstrdup(const char *s, gfp_t gfp)
 {
 	size_t len;
_

Patches currently in -mm which might be from adobriyan@gmail.com are


