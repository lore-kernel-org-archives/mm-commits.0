Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD02C54EED
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 20:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbjAXUtX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 15:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAXUtW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 15:49:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518E750859
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 12:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81141B816D8
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 20:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C9EC433EF;
        Tue, 24 Jan 2023 20:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674593358;
        bh=6ZuKLhGRsjM3lcx5DRXws3S5rKBjQ3vXUDLYagntXho=;
        h=Date:To:From:Subject:From;
        b=IAB2rBKsi7GUi2c+Zs7Bv06RZe7NDIsL0RwGPNSOz5XSiagMIrqSwRGoVrbg2dC/B
         UtYDCcwI6g0AEGwqUKFqrlOdLCx9gT13IIoJYG6O1I7hmbvysmaGGxIBFLSLy2KduX
         IfHOKDruoctwKtZs4492BES8xmLaB0VojwIUP3T0=
Date:   Tue, 24 Jan 2023 12:49:17 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, elver@google.com,
        dvyukov@google.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfig-fix-spellos.patch added to mm-hotfixes-unstable branch
Message-Id: <20230124204918.13C9EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: Kconfig: fix spellos
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-kconfig-fix-spellos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfig-fix-spellos.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: Kconfig: fix spellos
Date: Tue, 24 Jan 2023 10:16:55 -0800

Fix spelling in lib/ Kconfig files.
(reported by codespell)

Link: https://lkml.kernel.org/r/20230124181655.16269-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 lib/Kconfig.kcsan |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/lib/Kconfig.debug~lib-kconfig-fix-spellos
+++ a/lib/Kconfig.debug
@@ -1917,7 +1917,7 @@ config FUNCTION_ERROR_INJECTION
 	help
 	  Add fault injections into various functions that are annotated with
 	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
-	  value of theses functions. This is useful to test error paths of code.
+	  value of these functions. This is useful to test error paths of code.
 
 	  If unsure, say N
 
--- a/lib/Kconfig.kcsan~lib-kconfig-fix-spellos
+++ a/lib/Kconfig.kcsan
@@ -194,7 +194,7 @@ config KCSAN_WEAK_MEMORY
 	  Enable support for modeling a subset of weak memory, which allows
 	  detecting a subset of data races due to missing memory barriers.
 
-	  Depends on KCSAN_STRICT, because the options strenghtening certain
+	  Depends on KCSAN_STRICT, because the options strengthening certain
 	  plain accesses by default (depending on !KCSAN_STRICT) reduce the
 	  ability to detect any data races invoving reordered accesses, in
 	  particular reordered writes.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-kconfig-fix-spellos.patch
freevxfs-fix-kernel-doc-warnings.patch
ntfs-fix-multiple-kernel-doc-warnings.patch
userns-fix-a-structs-kernel-doc-notation.patch

