Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B70C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiBVDzT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:55:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiBVDzT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:55:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE8F33E8E
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:54:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57EA86159E
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDBFC340E8;
        Tue, 22 Feb 2022 03:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645502090;
        bh=maRN0pSeOCBXAbAXhDp7s+7o+y/8GoNPe59GyEelBxI=;
        h=Date:To:From:Subject:From;
        b=gTtG60uQtyJpV2sM1bIDykmuHwQ0oEkcUXrv1pG0xOzYO3h12UyVDHBvtquiYKgYx
         GWN5vOfLG43JRpuJuNVgznSVEi6zPa907sOOpzdB/K2xJe1+dTOOIAxnNDCopTjWKu
         o1bZ7zR/tkzqscPD2x2/6jdZet8FbhxeTCfCcT+c=
Date:   Mon, 21 Feb 2022 19:54:50 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        i.zhbanov@omprussia.ru, crecklin@redhat.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch added to -mm tree
Message-Id: <20220222035450.ABDBFC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/usercopy: return 1 from hardened_usercopy __setup() handler
has been added to the -mm tree.  Its filename is
     mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch

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
Subject: mm/usercopy: return 1 from hardened_usercopy __setup() handler

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; it just pollutes init's
environment). This prevents:

  Unknown kernel command line parameters \
  "BOOT_IMAGE=/boot/bzImage-517rc5 hardened_usercopy=off", will be \
  passed to user space.

  Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     hardened_usercopy=off
or
     hardened_usercopy=on
but when "hardened_usercopy=foo" is used, there is no Unknown kernel
command line parameter.

Return 1 to indicate that the boot option has been handled.
Print a warning if strtobool() returns an error on the option string,
but do not mark this as in unknown command line option and do not cause
init's environment to be polluted with this string.

Link: https://lkml.kernel.org/r/20220222034249.14795-1-rdunlap@infradead.org
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: b5cb15d9372ab ("usercopy: Allow boot cmdline disabling of hardening")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Chris von Recklinghausen <crecklin@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/usercopy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/usercopy.c~mm-usercopy-return-1-from-hardened_usercopy-__setup-handler
+++ a/mm/usercopy.c
@@ -284,7 +284,10 @@ static bool enable_checks __initdata = t
 
 static int __init parse_hardened_usercopy(char *str)
 {
-	return strtobool(str, &enable_checks);
+	if (strtobool(str, &enable_checks))
+		pr_warn("Invalid option string for hardened_usercopy: '%s'\n",
+			str);
+	return 1;
 }
 
 __setup("hardened_usercopy=", parse_hardened_usercopy);
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
inith-improve-__setup-and-early_param-documentation.patch
init-mainc-return-1-from-handled-__setup-functions.patch
docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch

