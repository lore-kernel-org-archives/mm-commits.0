Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8220CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiKOAtN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiKOAtM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:49:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB3417A98
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:49:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FF77B8133B
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D5DC433D7;
        Tue, 15 Nov 2022 00:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668473348;
        bh=sOQzyt4KuJOgR7wHmG0vGAl5bJLpUPcwLmasSAkZaGY=;
        h=Date:To:From:Subject:From;
        b=Wedyo8Uxw/NwPhewnOcgOZh9qz6IyRevJ38iHIHc2mXIZ4bT2DmIimPQn5QQIMY7x
         e4WboraNJzlCYXP7l5dZZX9MjBZKjeB/a5ULLds992qahxn8I2YshDwKLEitqBjjJz
         w+PXqW1H7Z1O5TqlatMpPIsa/xAv+yJ4go9/kxjg=
Date:   Mon, 14 Nov 2022 16:49:07 -0800
To:     mm-commits@vger.kernel.org, yijiangshan@kylinos.cn,
        samitolvanen@google.com, rdunlap@infradead.org,
        peterz@infradead.org, keescook@chromium.org, masahiroy@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-inith-include-linux-build_bugh-and-linux-stringifyh.patch added to mm-nonmm-unstable branch
Message-Id: <20221115004908.A7D5DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/init.h: include <linux/build_bug.h> and <linux/stringify.h>
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     linux-inith-include-linux-build_bugh-and-linux-stringifyh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/linux-inith-include-linux-build_bugh-and-linux-stringifyh.patch

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
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: linux/init.h: include <linux/build_bug.h> and <linux/stringify.h>
Date: Sun, 13 Nov 2022 20:08:02 +0900

With CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y, the following code fails to
build:

  ---------------->8----------------
  #include <linux/init.h>

  int foo(void) { return 0; }
  core_initcall(foo);
  ---------------->8----------------

Include <linux/build_bug.h> for static_assert() and <linux/stringify.h>
for __stringify().

Link: https://lkml.kernel.org/r/20221113110802.3760705-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org> # build-tested
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/init.h~linux-inith-include-linux-build_bugh-and-linux-stringifyh
+++ a/include/linux/init.h
@@ -2,7 +2,9 @@
 #ifndef _LINUX_INIT_H
 #define _LINUX_INIT_H
 
+#include <linux/build_bug.h>
 #include <linux/compiler.h>
+#include <linux/stringify.h>
 #include <linux/types.h>
 
 /* Built-in __init functions needn't be compiled with retpoline */
_

Patches currently in -mm which might be from masahiroy@kernel.org are

linux-inith-include-linux-build_bugh-and-linux-stringifyh.patch

