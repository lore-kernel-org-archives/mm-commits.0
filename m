Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451A1C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345404AbiCWXIJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345427AbiCWXHs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2753B9027D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7B50B82181
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A453C36AF5;
        Wed, 23 Mar 2022 23:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076775;
        bh=mZzWohm32Mk4wIVFFd0R9wbB44+Mbz7tzFrxU1t0AcI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=dUSXqz5xym9acVBsvG/1vSRbxWsOcX9lmLTC+ggnuKp4GjwI6XB02BrlSNVEzMcsR
         ZD16j8fzOE+iJjRe2k4jW5+6KlBdHcffa5yWmYwh2pcceDPanCRRH6vqlWYprkSrJJ
         VAQdeoXPC4vLWfEGWOJEWB5K9t44GU50xItZf2r8=
Date:   Wed, 23 Mar 2022 16:06:14 -0700
To:     mingo@kernel.org, i.zhbanov@omprussia.ru,
        gregkh@linuxfoundation.org, rdunlap@infradead.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 19/41] init/main.c: return 1 from handled __setup() functions
Message-Id: <20220323230615.5A453C36AF5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
