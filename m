Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658DEC54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjAZXSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbjAZXSP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:18:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4E4360A5
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:18:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED7B7B81EE2
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D96C433D2;
        Thu, 26 Jan 2023 23:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674775091;
        bh=QAFLziIxY3BsMMzwleNSlQZ5Sf4TRoOb4uCTFOgYJ18=;
        h=Date:To:From:Subject:From;
        b=Rhq/Xhx4QxK8mirojg/qKwJSsqNiMnmDGYYnIHgPJp7lpjfgv5xqOMTe3BE+W38JK
         TAgMryg9B7mx3tO65TbWUb7bd3YBWyX7FA/63yC7SPzIbEEMl29QvXClGl6UHfgaKe
         SOvaml2bD8pcKSCWzAPVpgmm2L92dnPsWZGY2i+s=
Date:   Thu, 26 Jan 2023 15:18:11 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch added to mm-nonmm-unstable branch
Message-Id: <20230126231811.87D96C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: fix DFLTCC ignoring flush modes when avail_in == 0
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch

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
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: fix DFLTCC ignoring flush modes when avail_in == 0
Date: Thu, 26 Jan 2023 14:14:24 +0100

This commit is based on:
  https://github.com/zlib-ng/zlib-ng/commit/40acb3f

Link: https://lkml.kernel.org/r/20230126131428.1222214-5-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_dfltcc/dfltcc_deflate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/zlib_dfltcc/dfltcc_deflate.c~lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0
+++ a/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -142,7 +142,8 @@ again:
         /* Clear history. */
         if (flush == Z_FULL_FLUSH)
             param->hl = 0;
-        *result = need_more;
+        /* Trigger block post-processing if necessary. */
+        *result = no_flush ? need_more : block_done;
         return 1;
     }
 
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are

lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch
lib-zlib-implement-switching-between-dfltcc-and-software.patch
lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch
lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch
lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch
lib-zlib-split-deflate-and-inflate-states-for-dfltcc.patch
lib-zlib-dfltcc-support-inflate-with-small-window.patch
lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

