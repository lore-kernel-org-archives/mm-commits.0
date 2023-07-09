Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3259C001DD
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjGIAal (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjGIAaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8923CE5E
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2075760B46
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B4BC433C7;
        Sun,  9 Jul 2023 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862631;
        bh=OOj1YQL4Rz3ZOUAgVNARM22Tg2++MUiHSB9M+cOD7fs=;
        h=Date:To:From:Subject:From;
        b=bcQ+7aAb0P3eJ7C4sV0yCYH6Q+nqlAuEhIwqf0ZPx75wE7zoxnSBYizoB+8SWbwEg
         TM9fPgPHUtpOIXyj7kEmYD2GTSBYoQnAh7FnouGmMs6LLSKDK756IXV/yZZuvJgIK3
         wWEGLdhfVzfl8snr7t+zrwLsf6ayKNp7Jcw7WF8Q=
Date:   Sat, 08 Jul 2023 17:30:30 -0700
To:     mm-commits@vger.kernel.org, dan.carpenter@linaro.org,
        geert+renesas@glider.be, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-dhry-fix-sleeping-allocations-inside-non-preemptable-section.patch removed from -mm tree
Message-Id: <20230709003031.75B4BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: dhry: fix sleeping allocations inside non-preemptable section
has been removed from the -mm tree.  Its filename was
     lib-dhry-fix-sleeping-allocations-inside-non-preemptable-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib: dhry: fix sleeping allocations inside non-preemptable section
Date: Wed, 5 Jul 2023 16:54:04 +0200

The Smatch static checker reports the following warnings:

    lib/dhry_run.c:38 dhry_benchmark() warn: sleeping in atomic context
    lib/dhry_run.c:43 dhry_benchmark() warn: sleeping in atomic context

Indeed, dhry() does sleeping allocations inside the non-preemptable
section delimited by get_cpu()/put_cpu().

Fix this by using atomic allocations instead.
Add error handling, as atomic these allocations may fail.

Link: https://lkml.kernel.org/r/bac6d517818a7cd8efe217c1ad649fffab9cc371.1688568764.git.geert+renesas@glider.be
Fixes: 13684e966d46283e ("lib: dhry: fix unstable smp_processor_id(_) usage")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/0469eb3a-02eb-4b41-b189-de20b931fa56@moroto.mountain
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dhry_1.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/lib/dhry_1.c~lib-dhry-fix-sleeping-allocations-inside-non-preemptable-section
+++ a/lib/dhry_1.c
@@ -139,8 +139,15 @@ int dhry(int n)
 
 	/* Initializations */
 
-	Next_Ptr_Glob = (Rec_Pointer)kzalloc(sizeof(Rec_Type), GFP_KERNEL);
-	Ptr_Glob = (Rec_Pointer)kzalloc(sizeof(Rec_Type), GFP_KERNEL);
+	Next_Ptr_Glob = (Rec_Pointer)kzalloc(sizeof(Rec_Type), GFP_ATOMIC);
+	if (!Next_Ptr_Glob)
+		return -ENOMEM;
+
+	Ptr_Glob = (Rec_Pointer)kzalloc(sizeof(Rec_Type), GFP_ATOMIC);
+	if (!Ptr_Glob) {
+		kfree(Next_Ptr_Glob);
+		return -ENOMEM;
+	}
 
 	Ptr_Glob->Ptr_Comp = Next_Ptr_Glob;
 	Ptr_Glob->Discr = Ident_1;
_

Patches currently in -mm which might be from geert+renesas@glider.be are


