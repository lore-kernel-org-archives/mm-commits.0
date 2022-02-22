Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDB0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiBVDm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:42:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235078AbiBVDmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:42:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA80D1D0EF
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:42:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 830EA61529
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CF9C340EF;
        Tue, 22 Feb 2022 03:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645501349;
        bh=voi9dHSamdi/0U+9kv+nXmsrLU7Yjwb5cSX0bIile08=;
        h=Date:To:From:Subject:From;
        b=WifhuDF3itJfLZCBfWOVvUylaWZXY6vrvKDP2f0nJfKKTIdowl+OZ/KgrdhExoHir
         qRtXhFpQgAQwj0grt68XqfzpVCHD55o7L1sTycwbN2E0KeEj1GhADZ7BraCGJGqsCk
         YbrDegxONG6aOb15BmxvEN8JUWQXO6nlAP3ccvKE=
Date:   Mon, 21 Feb 2022 19:42:29 -0800
To:     mm-commits@vger.kernel.org, mingo@kernel.org,
        i.zhbanov@omprussia.ru, gregkh@linuxfoundation.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-return-1-from-handled-__setup-functions.patch added to -mm tree
Message-Id: <20220222034229.D0CF9C340EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: return 1 from handled __setup() functions
has been added to the -mm tree.  Its filename is
     init-mainc-return-1-from-handled-__setup-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-mainc-return-1-from-handled-__setup-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-return-1-from-handled-__setup-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
inith-improve-__setup-and-early_param-documentation.patch
init-mainc-return-1-from-handled-__setup-functions.patch
docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch

