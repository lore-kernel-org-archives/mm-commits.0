Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC50BFA3743
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJ1VIJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiJ1VHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CDD248C9E
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B50E1B82C97
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A50AC433C1;
        Fri, 28 Oct 2022 21:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991244;
        bh=3oA65MerYmNJyYid3kVHvLJsrxvCPnW0pxkivL4LDJk=;
        h=Date:To:From:Subject:From;
        b=drINVbMV0FGn75zRZDe6LqhD+IGEpifHRni/IfCEtR4tah6vgcnZsre+6zRzE6QaO
         4dSHL80TlVejlqN7Z+4/RCKio7rGQzQp5uGvROiBWxh0/u44XcYH8qReA1CQGXGKbF
         SQLqL2rEvnmUdCyd6CySc8Y2Zb8qy1bqNiHY8vBs=
Date:   Fri, 28 Oct 2022 14:07:23 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        masahiroy@kernel.org, keescook@chromium.org, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch removed from -mm tree
Message-Id: <20221028210724.3A50AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Kconfig.debug: disable CONFIG_FRAME_WARN for KMSAN by default
has been removed from the -mm tree.  Its filename was
     kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: Kconfig.debug: disable CONFIG_FRAME_WARN for KMSAN by default
Date: Mon, 24 Oct 2022 23:21:42 +0200

KMSAN adds a lot of instrumentation to the code, which results in
increased stack usage (up to 2048 bytes and more in some cases).  It's
hard to predict how big the stack frames can be, so we disable the
warnings for KMSAN instead.

Link: https://lkml.kernel.org/r/20221024212144.2852069-3-glider@google.com
Link: https://github.com/google/kmsan/issues/89
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/Kconfig.debug~kconfigdebug-disable-config_frame_warn-for-kmsan-by-default
+++ a/lib/Kconfig.debug
@@ -400,8 +400,9 @@ config FRAME_WARN
 	default 1536 if (!64BIT && XTENSA)
 	default 1024 if !64BIT
 	default 2048 if 64BIT
+	default 0 if KMSAN
 	help
-	  Tell gcc to warn at build time for stack frames larger than this.
+	  Tell the compiler to warn at build time for stack frames larger than this.
 	  Setting this too low will cause a lot of warnings.
 	  Setting it to 0 disables the warning.
 
_

Patches currently in -mm which might be from glider@google.com are


