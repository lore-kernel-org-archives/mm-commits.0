Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A729C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiLLDbL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiLLDbK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F00D138
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36813B80A1F
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36A4C433D2;
        Mon, 12 Dec 2022 03:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815867;
        bh=kEdxF/dyJ1Q/uRnjK73AcCFuwrrfMVEbOl2fi0R/PA8=;
        h=Date:To:From:Subject:From;
        b=D96ugNLdI5vtkOiH65bOqZgBTSvnxbUnNS1Kiu1gbhm1Eu38Fpu3qwAH8g8fHmoGO
         8MAgFbdqwCnC0Oh4sokMtsBKxtCqjEt5UTm4C1FVqs4n6n9lL287P7BYjObUvPyp+u
         adLvx2auYX2VtGytUkeQFF87MKvtjAxSPeZa+iOI=
Date:   Sun, 11 Dec 2022 19:31:06 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com,
        wuchi.zero@gmail.com, colin.i.king@gmail.com, axboe@kernel.dk,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relay-use-strscpy-is-more-robust-and-safer.patch removed from -mm tree
Message-Id: <20221212033106.E36A4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: relay: use strscpy() is more robust and safer
has been removed from the -mm tree.  Its filename was
     relay-use-strscpy-is-more-robust-and-safer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xu Panda <xu.panda@zte.com.cn>
Subject: relay: use strscpy() is more robust and safer
Date: Tue, 22 Nov 2022 08:53:25 +0800 (CST)

The implementation of strscpy() is more robust and safer.  That's now the
recommended way to copy NUL terminated strings.

Link: https://lkml.kernel.org/r/202211220853259244666@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: wuchi <wuchi.zero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/relay.c~relay-use-strscpy-is-more-robust-and-safer
+++ a/kernel/relay.c
@@ -507,7 +507,7 @@ struct rchan *relay_open(const char *bas
 	chan->private_data = private_data;
 	if (base_filename) {
 		chan->has_base_filename = 1;
-		strlcpy(chan->base_filename, base_filename, NAME_MAX);
+		strscpy(chan->base_filename, base_filename, NAME_MAX);
 	}
 	chan->cb = cb;
 	kref_init(&chan->kref);
@@ -578,7 +578,7 @@ int relay_late_setup_files(struct rchan
 	if (!chan || !base_filename)
 		return -EINVAL;
 
-	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+	strscpy(chan->base_filename, base_filename, NAME_MAX);
 
 	mutex_lock(&relay_channels_mutex);
 	/* Is chan already set up? */
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are


