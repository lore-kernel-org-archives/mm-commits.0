Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228E3C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiKOWdO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiKOWch (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B971BE90
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83ECCB81B89
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C57C433C1;
        Tue, 15 Nov 2022 22:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551546;
        bh=Ksw46u5CVMOd/UtAQVNG6WbXMkevAHrwmXgFhwcw1Lo=;
        h=Date:To:From:Subject:From;
        b=DRuPDajIpfpxdC82FKBm+eO+F8DAjQ2Rv9pdni0mDJRsTW65qUGSr4FTW4X7Iv2vV
         gNRgQkMWf6/pyouPiWh5jYfeITHyI+c9OJlTOMrw5qwvcKhDZc9NecOTGSGaqgqcqa
         h35NsWh3tMnReuTEF68u/ocsYd4fgDs7KaPRKxeM=
Date:   Tue, 15 Nov 2022 14:32:25 -0800
To:     mm-commits@vger.kernel.org, wuchi.zero@gmail.com, rppt@kernel.org,
        mwilck@suse.com, ebiederm@xmission.com, ddiss@suse.de,
        brauner@kernel.org, xupengfei@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] initramfs-remove-unnecessary-void-conversions.patch removed from -mm tree
Message-Id: <20221115223226.24C57C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: initramfs: remove unnecessary (void*) conversion
has been removed from the -mm tree.  Its filename was
     initramfs-remove-unnecessary-void-conversions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: XU pengfei <xupengfei@nfschina.com>
Subject: initramfs: remove unnecessary (void*) conversion
Date: Wed, 26 Oct 2022 16:05:18 +0800

Remove unnecessary void* type casting.

Link: https://lkml.kernel.org/r/20221026080517.3221-1-xupengfei@nfschina.com
Signed-off-by: XU pengfei <xupengfei@nfschina.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Disseldorp <ddiss@suse.de>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: wuchi <wuchi.zero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/initramfs.c~initramfs-remove-unnecessary-void-conversions
+++ a/init/initramfs.c
@@ -461,7 +461,7 @@ static long __init write_buffer(char *bu
 
 static long __init flush_buffer(void *bufv, unsigned long len)
 {
-	char *buf = (char *) bufv;
+	char *buf = bufv;
 	long written;
 	long origLen = len;
 	if (message)
_

Patches currently in -mm which might be from xupengfei@nfschina.com are


