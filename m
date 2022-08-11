Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B24C19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiHKVWD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiHKVWC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:22:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AA29C203
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:22:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24E51B82076
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B732BC433C1;
        Thu, 11 Aug 2022 21:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660252918;
        bh=Zm9swO24qeumYzlOg9sCvM/+lkF12+vXCaErf/C4D9k=;
        h=Date:To:From:Subject:From;
        b=163v1n0UL1fnadwJV119tqYkQz0XL66hdN5u6YOKspvN1QSNXDaOOzzYj3MHgAFiA
         HsW03wVF4rykkjB/egoU9w8yFsvsY9JtpIPjKPu9IchhkgY4VxEYLSE/111wwkmV8l
         nbBVULa7b/iCu1eXfKAMx9dJ0MAMiPAzDt5tT5JA=
Date:   Thu, 11 Aug 2022 14:21:58 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch added to mm-unstable branch
Message-Id: <20220811212158.B732BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-zs_object_copy-add-clarifying-comment-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-zs_object_copy-add-clarifying-comment-fix
Date: Thu Aug 11 02:20:45 PM PDT 2022

tweak comment layout

Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-zs_object_copy-add-clarifying-comment-fix
+++ a/mm/zsmalloc.c
@@ -1555,10 +1555,11 @@ static void zs_object_copy(struct size_c
 		d_off += size;
 		d_size -= size;
 
-		/* Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic() calls
-		 * must occurs in reverse order of calls to kmap_atomic().
-		 * So, to call kunmap_atomic(s_addr) we should first call kunmap_atomic(d_addr).
-		 * For more details see:
+		/*
+		 * Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic()
+		 * calls must occurs in reverse order of calls to kmap_atomic().
+		 * So, to call kunmap_atomic(s_addr) we should first call
+		 * kunmap_atomic(d_addr).  For more details see
 		 * https://lore.kernel.org/linux-mm/5512421D.4000603@samsung.com/
 		 */
 		if (s_off >= PAGE_SIZE) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch

