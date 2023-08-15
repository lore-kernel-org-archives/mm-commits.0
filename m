Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784A3C04FE0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Aug 2023 20:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbjHOUnk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Aug 2023 16:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbjHOUnb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2023 16:43:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3E5269E
        for <mm-commits@vger.kernel.org>; Tue, 15 Aug 2023 13:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC667661B2
        for <mm-commits@vger.kernel.org>; Tue, 15 Aug 2023 20:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D083C433C7;
        Tue, 15 Aug 2023 20:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692132105;
        bh=TvoeI9eA2w45fXSDqJKnZ+LSz46Deoxn5MXRnuU+zPQ=;
        h=Date:To:From:Subject:From;
        b=WGuS4VBWx6RZNQ1GQAWJ5IBC/t171HzcdDT8mykGK7dXN7tAHF+eERrtdidQIEjjV
         S5cwVj7chOzjqWCVmEUzR2VSaWNSoW+k77lp5zApIHtw8zTOFCFB0kU2NZBxNJp2rg
         CdZ0b9b37jPXO75bEZFHkcOv6He1cXLn+zvNJq+g=
Date:   Tue, 15 Aug 2023 13:41:44 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, glider@google.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, xiaolei.wang@windriver.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rename-kmemleak_initialized-to-kmemleak_late_initialized.patch added to mm-unstable branch
Message-Id: <20230815204145.2D083C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Rename kmemleak_initialized to kmemleak_late_initialized
has been added to the -mm mm-unstable branch.  Its filename is
     rename-kmemleak_initialized-to-kmemleak_late_initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rename-kmemleak_initialized-to-kmemleak_late_initialized.patch

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
From: Xiaolei Wang <xiaolei.wang@windriver.com>
Subject: Rename kmemleak_initialized to kmemleak_late_initialized
Date: Tue, 15 Aug 2023 22:41:28 +0800

The old name is confusing because it implies the completion of earlier
kmemleak_init(), the new name update to kmemleak_late_initial represents
the completion of kmemleak_late_init().

No functional changes.

Link: https://lkml.kernel.org/r/20230815144128.3623103-3-xiaolei.wang@windriver.com
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c~rename-kmemleak_initialized-to-kmemleak_late_initialized
+++ a/mm/kmemleak.c
@@ -218,7 +218,7 @@ static int kmemleak_enabled = 1;
 /* same as above but only for the kmemleak_free() callback */
 static int kmemleak_free_enabled = 1;
 /* set in the late_initcall if there were no errors */
-static int kmemleak_initialized;
+static int kmemleak_late_initialized;
 /* set if a kmemleak warning was issued */
 static int kmemleak_warning;
 /* set if a fatal kmemleak error has occurred */
@@ -2057,7 +2057,7 @@ static void kmemleak_disable(void)
 	kmemleak_enabled = 0;
 
 	/* check whether it is too early for a kernel thread */
-	if (kmemleak_initialized)
+	if (kmemleak_late_initialized)
 		schedule_work(&cleanup_work);
 	else
 		kmemleak_free_enabled = 0;
@@ -2122,7 +2122,7 @@ void __init kmemleak_init(void)
  */
 static int __init kmemleak_late_init(void)
 {
-	kmemleak_initialized = 1;
+	kmemleak_late_initialized = 1;
 
 	debugfs_create_file("kmemleak", 0644, NULL, NULL, &kmemleak_fops);
 
@@ -2130,7 +2130,7 @@ static int __init kmemleak_late_init(voi
 		/*
 		 * Some error occurred and kmemleak was disabled. There is a
 		 * small chance that kmemleak_disable() was called immediately
-		 * after setting kmemleak_initialized and we may end up with
+		 * after setting kmemleak_late_initialized and we may end up with
 		 * two clean-up threads but serialized by scan_mutex.
 		 */
 		schedule_work(&cleanup_work);
_

Patches currently in -mm which might be from xiaolei.wang@windriver.com are

mm-kmemleak-use-object_cache-instead-of-kmemleak_initialized-to-check-in-set_track_prepare.patch
rename-kmemleak_initialized-to-kmemleak_late_initialized.patch

