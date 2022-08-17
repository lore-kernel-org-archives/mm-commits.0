Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4428CC28B2B
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 17:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbiHQRnH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 13:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbiHQRnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 13:43:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D44A222C
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 10:43:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C993E61312
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 17:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC96C433C1;
        Wed, 17 Aug 2022 17:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660758185;
        bh=yOadQz4/60OD6BS4s0UjmB6p09j01bxSoMhCcJTdzZs=;
        h=Date:To:From:Subject:From;
        b=zapUAAkYJj4Ph8tI/MLAulgXYmX+vjDkE0XFJGaYvWOSoPu4aolhyXDRUSX9txjXu
         S4iFY0oyxaCIAJG+3+QBdyqmtizFghfWWgU++2WMpvyxEPLIpRiN5C8I97Eo7Gcu/3
         SzqinC1Zxw+U/QsqfA1v3E7o3pc2+14JEQVKv5i0=
Date:   Wed, 17 Aug 2022 10:43:04 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-zs_object_copy-replace-email-link-to-doc.patch added to mm-unstable branch
Message-Id: <20220817174305.1AC96C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: zs_object_copy: replace email link to doc
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-zs_object_copy-replace-email-link-to-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-zs_object_copy-replace-email-link-to-doc.patch

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
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zsmalloc: zs_object_copy: replace email link to doc
Date: Mon, 15 Aug 2022 17:48:25 +0300

Emails are not documentation.

Link: https://lkml.kernel.org/r/20220815144825.39001-1-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-zs_object_copy-replace-email-link-to-doc
+++ a/mm/zsmalloc.c
@@ -1559,8 +1559,8 @@ static void zs_object_copy(struct size_c
 		 * Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic()
 		 * calls must occurs in reverse order of calls to kmap_atomic().
 		 * So, to call kunmap_atomic(s_addr) we should first call
-		 * kunmap_atomic(d_addr).  For more details see
-		 * https://lore.kernel.org/linux-mm/5512421D.4000603@samsung.com/
+         * kunmap_atomic(d_addr). For more details see
+         * Documentation/mm/highmem
 		 */
 		if (s_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zsmalloc-zs_object_copy-add-clarifying-comment.patch
zsmalloc-remove-unnecessary-size_class-null-check.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc.patch

