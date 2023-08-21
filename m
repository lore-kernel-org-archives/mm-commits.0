Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4A2EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjHUUoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjHUUni (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC788CEE
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B51B649CB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3502C433C7;
        Mon, 21 Aug 2023 20:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650530;
        bh=ezaUD1CR2yTQlRjoVOHJoQ1hZWO+I0rug5SRl2n/vy8=;
        h=Date:To:From:Subject:From;
        b=fv+g8wrKxl6IvecBgsxxE8ovxcaJjXk3tDWqRy3a6ktC8Cnn6o6ujcYULQi8EHElm
         t4/1r3e/BznlRhXnwwp5KPNE2n6uhe5tXCfGuVI1Q4lopHnkEh+s9cXjPy+kW2jvmS
         OqDG9R0n6MxRuyL5xesh/QFK5d5sbLvNSq38IcGM=
Date:   Mon, 21 Aug 2023 13:42:10 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, glider@google.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, xiaolei.wang@windriver.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rename-kmemleak_initialized-to-kmemleak_late_initialized.patch removed from -mm tree
Message-Id: <20230821204210.A3502C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Rename kmemleak_initialized to kmemleak_late_initialized
has been removed from the -mm tree.  Its filename was
     rename-kmemleak_initialized-to-kmemleak_late_initialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


