Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082DDC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 21:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiKHV0a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 16:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiKHV03 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 16:26:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7775E9C9
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 13:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37F86B81BEA
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 21:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE9DC433D6;
        Tue,  8 Nov 2022 21:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667942783;
        bh=Ca+po0GOLblnkk5ol73AeVvK+/5SKGe25juBbr1FsZE=;
        h=Date:To:From:Subject:From;
        b=WmMqzGI9msYYwZCT0wS7YHsELsmrv3nDJRFq8o5405gB8LxFcMZalkQGTUUm1qZQ1
         EojYU0HiDBxpkOqF33Gmjc54Qop4SznZqtEXOeYwWOaAEGJHJdwqoNCIp+l/OJFsYD
         N/eQsd4RG2s9V2ou81whvixOaIrCtCs4PPh8dHyw=
Date:   Tue, 08 Nov 2022 13:26:23 -0800
To:     mm-commits@vger.kernel.org, thomas.petazzoni@bootlin.com,
        catalin.marinas@arm.com, alexandre.belloni@bootlin.com,
        clement.leger@bootlin.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-use-%pk-to-display-kernel-pointers-in-backtrace.patch added to mm-unstable branch
Message-Id: <20221108212623.CFE9DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: use %pK to display kernel pointers in backtrace
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-use-%pk-to-display-kernel-pointers-in-backtrace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-use-%pk-to-display-kernel-pointers-in-backtrace.patch

This patch will later appear in the mm-unstable branch at
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
From: Clément Léger <clement.leger@bootlin.com>
Subject: mm/kmemleak: use %pK to display kernel pointers in backtrace
Date: Tue, 8 Nov 2022 10:43:22 +0100

Currently, %p is used to display kernel pointers in backtrace which result
in a hashed value that is not usable to correlate the address for debug. 
Use %pK which will respect the kptr_restrict configuration value and thus
allow to extract meaningful information from the backtrace.

Link: https://lkml.kernel.org/r/20221108094322.73492-1-clement.leger@bootlin.com
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-%pk-to-display-kernel-pointers-in-backtrace
+++ a/mm/kmemleak.c
@@ -361,7 +361,7 @@ static void print_unreferenced(struct se
 
 	for (i = 0; i < nr_entries; i++) {
 		void *ptr = (void *)entries[i];
-		warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
+		warn_or_seq_printf(seq, "    [<%pK>] %pS\n", ptr, ptr);
 	}
 }
 
_

Patches currently in -mm which might be from clement.leger@bootlin.com are

mm-kmemleak-use-%pk-to-display-kernel-pointers-in-backtrace.patch

