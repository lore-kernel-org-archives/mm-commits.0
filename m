Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570CCEB64DD
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjG0UHo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbjG0UHn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A431BC3;
        Thu, 27 Jul 2023 13:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA47D61EF0;
        Thu, 27 Jul 2023 20:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBFBC433C8;
        Thu, 27 Jul 2023 20:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488460;
        bh=HPrpBONYZdCgcjM6Mk389I4+iKMfMzbdMyBjE+79eGI=;
        h=Date:To:From:Subject:From;
        b=hsBhVWRcBBNovy7fTGTZzu/cjkB98vDm9447qt7kzyb2qqaBlqbye+OYq7EXf9P9J
         0taduXgMXdvyaAkE0lqsgIDMX4eTSuqnA/eOBxbvfYCzCZsyUWEjHYl46brrjk8W9x
         zME8iEEOzrPtoJyvTn3FBLBzYAgebxHHCLyBlrMI=
Date:   Thu, 27 Jul 2023 13:07:39 -0700
To:     mm-commits@vger.kernel.org, yang.guang5@zte.com.cn,
        stable@vger.kernel.org, richard@nod.at, lkp@intel.com,
        linux@rasmusvillemoes.dk, johannes@sipsolutions.net,
        Jason@zx2c4.com, herve.codina@bootlin.com,
        anton.ivanov@cambridgegreys.com, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-um-use-swap-to-make-code-cleaner.patch removed from -mm tree
Message-Id: <20230727200740.2BBFBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "um: Use swap() to make code cleaner"
has been removed from the -mm tree.  Its filename was
     revert-um-use-swap-to-make-code-cleaner.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Revert "um: Use swap() to make code cleaner"
Date: Mon, 24 Jul 2023 17:31:31 +0300

This reverts commit 9b0da3f22307af693be80f5d3a89dc4c7f360a85.

The sigio.c is clearly user space code which is handled by
arch/um/scripts/Makefile.rules (see USER_OBJS rule).

The above mentioned commit simply broke this agreement,
we may not use Linux kernel internal headers in them without
thorough thinking.

Hence, revert the wrong commit.

Link: https://lkml.kernel.org/r/20230724143131.30090-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307212304.cH79zJp1-lkp@intel.com/
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Herve Codina <herve.codina@bootlin.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Richard Weinberger <richard@nod.at>
Cc: Yang Guang <yang.guang5@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sigio.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/um/os-Linux/sigio.c~revert-um-use-swap-to-make-code-cleaner
+++ a/arch/um/os-Linux/sigio.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2002 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  */
 
-#include <linux/minmax.h>
 #include <unistd.h>
 #include <errno.h>
 #include <fcntl.h>
@@ -51,7 +50,7 @@ static struct pollfds all_sigio_fds;
 
 static int write_sigio_thread(void *unused)
 {
-	struct pollfds *fds;
+	struct pollfds *fds, tmp;
 	struct pollfd *p;
 	int i, n, respond_fd;
 	char c;
@@ -78,7 +77,9 @@ static int write_sigio_thread(void *unus
 					       "write_sigio_thread : "
 					       "read on socket failed, "
 					       "err = %d\n", errno);
-				swap(current_poll, next_poll);
+				tmp = current_poll;
+				current_poll = next_poll;
+				next_poll = tmp;
 				respond_fd = sigio_private[1];
 			}
 			else {
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-count_args-and-concatenate-to-argsh.patch
x86-asm-replace-custom-count_args-concatenate-implementations.patch
arm64-smccc-replace-custom-count_args-concatenate-implementations.patch
genetlink-replace-custom-concatenate-implementation.patch

