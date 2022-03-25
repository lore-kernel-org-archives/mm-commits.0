Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACB6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244460AbiCYBgl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357422AbiCYBfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16DFC12F7
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9290EB81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B83C340EC;
        Fri, 25 Mar 2022 01:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171975;
        bh=653QMhT9H3k2ZQcUuZ1CR0t/PFJa8ISJpsLI2PbpRNk=;
        h=Date:To:From:Subject:From;
        b=ChKMWiS+N1lcXQvmRHyeMOUOwd4xgeQEE71m5rBdD76h7rPL0IVkNNvLBerVekcWb
         QCxsihvk8jZs1Yc0GbFAl+K9du6HgAR05tPl8YfPTm8wIxcsbOXFUrMOWIu6erOGxv
         6xytwcsNDZ3N12KzX37gRjVYRKESxDDnwWC9OyLU=
Date:   Thu, 24 Mar 2022 18:32:54 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        i.zhbanov@omprussia.ru, crecklin@redhat.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch removed from -mm tree
Message-Id: <20220325013255.37B83C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/usercopy: return 1 from hardened_usercopy __setup() handler
has been removed from the -mm tree.  Its filename was
     mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Chris von Recklinghausen <crecklin@redhat.com>
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


