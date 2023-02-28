Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB34C64EC4
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 20:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjB1UXj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Feb 2023 15:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjB1UXj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2023 15:23:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56B932E4F
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 12:23:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35924B80E1A
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 20:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA0BC433EF;
        Tue, 28 Feb 2023 20:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677615777;
        bh=BCAtbRfiX/oJGPIrjur3lctQihr29Mc8jZ88LpSRVuI=;
        h=Date:To:From:Subject:From;
        b=DSNCFmhUh06S+O3fNMrSi/9MCGhkF8c3yvWF0JjNpfF0pS6RWa3e8/C7AspNieOUB
         6fRkq5NCfR9DMAWDFyoIN99kmSk4nETWjGUOJUJGKBLOCqDntWgmZBDsIHznoQmLnL
         4mCS0dwzakfo/or2YK7Z9j1JtuTeMt/5B0hdibcU=
Date:   Tue, 28 Feb 2023 12:22:57 -0800
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uninline-kstrdup.patch added to mm-nonmm-unstable branch
Message-Id: <20230228202257.BEA0BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline kstrdup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-uninline-kstrdup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uninline-kstrdup.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-uninline-kstrdup.patch

