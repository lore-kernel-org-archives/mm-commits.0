Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E312BECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiJ0U2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbiJ0U2o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:28:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC722900D5
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F171B82638
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB67C433C1;
        Thu, 27 Oct 2022 20:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666902520;
        bh=bkqycvruClbGoSefSbYTiXwJdE1hjtnVpiEb3GGPCiI=;
        h=Date:To:From:Subject:From;
        b=TbWrN6nNT00+JPa5IIx5iZMgMpjRmGw3vjYtemvLQQYOUA80EfgeQY8W95NHFAzr3
         ieuZW8MOR3uQekxL+d0WI19ZnEKgh5R+g4fo7C9wMmWjCyV16FFntmNuAetOGV+QLa
         WszYkjJLgFvjzeViaSg68vE2hvahW6taePGUeAPY=
Date:   Thu, 27 Oct 2022 13:28:39 -0700
To:     mm-commits@vger.kernel.org, wuchi.zero@gmail.com, rppt@kernel.org,
        mwilck@suse.com, ebiederm@xmission.com, ddiss@suse.de,
        brauner@kernel.org, xupengfei@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + initramfs-remove-unnecessary-void-conversions.patch added to mm-nonmm-unstable branch
Message-Id: <20221027202839.EEB67C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: remove unnecessary (void*) conversion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     initramfs-remove-unnecessary-void-conversions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/initramfs-remove-unnecessary-void-conversions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

initramfs-remove-unnecessary-void-conversions.patch

