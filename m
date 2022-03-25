Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662FDC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348813AbiCYBhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357505AbiCYBf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE8C36301
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A57ACB8272E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412EEC340ED;
        Fri, 25 Mar 2022 01:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172038;
        bh=MBQX8TTjvsJ64U+Bcdf3ZGEvpQ5gwrfr60ilXlE7jOU=;
        h=Date:To:From:Subject:From;
        b=srq1JdA0r+aE10HoHT/GdpmfdP3DqVLkl3CDLCRhopKSxGfUU9ZniBhAKSujCK9IW
         nasO4Vw1IugG8k0Zh/Wqi3HafjEgkg8qNxsJxoz2pCDu5yvTW66iYB/IzlyJJXkwGL
         Ox/cB4I5pyV8MC17MYpwMs2qrlyDlYxiJzKEG0o4=
Date:   Thu, 24 Mar 2022 18:33:57 -0700
To:     mm-commits@vger.kernel.org, mingo@kernel.org,
        i.zhbanov@omprussia.ru, gregkh@linuxfoundation.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] init-mainc-return-1-from-handled-__setup-functions.patch removed from -mm tree
Message-Id: <20220325013358.412EEC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: return 1 from handled __setup() functions
has been removed from the -mm tree.  Its filename was
     init-mainc-return-1-from-handled-__setup-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: init/main.c: return 1 from handled __setup() functions

initcall_blacklist() should return 1 to indicate that it handled its
cmdline arguments.

set_debug_rodata() should return 1 to indicate that it handled its cmdline
arguments.  Print a warning if the option string is invalid.

This prevents these strings from being added to the 'init' program's
environment as they are not init arguments/parameters.

Link: https://lkml.kernel.org/r/20220221050901.23985-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/init/main.c~init-mainc-return-1-from-handled-__setup-functions
+++ a/init/main.c
@@ -1190,7 +1190,7 @@ static int __init initcall_blacklist(cha
 		}
 	} while (str_entry);
 
-	return 0;
+	return 1;
 }
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
@@ -1448,7 +1448,9 @@ static noinline void __init kernel_init_
 bool rodata_enabled __ro_after_init = true;
 static int __init set_debug_rodata(char *str)
 {
-	return strtobool(str, &rodata_enabled);
+	if (strtobool(str, &rodata_enabled))
+		pr_warn("Invalid option string for rodata: '%s'\n", str);
+	return 1;
 }
 __setup("rodata=", set_debug_rodata);
 #endif
_

Patches currently in -mm which might be from rdunlap@infradead.org are


