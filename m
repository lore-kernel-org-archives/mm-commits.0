Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B984C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiANWD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiANWD6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52973C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:03:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A8C0B8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A900C36AE9;
        Fri, 14 Jan 2022 22:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197835;
        bh=ZNao/APMSnVraYf7V2i353zBOJ2zo6kziYgfy8pkItk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yhL8IHrnWE47GhxUbYUgzmEXKgX9CG7o+ckNKTCTakC6psqYzaXRFDI4obHPepTpg
         uAsaakpZh50lFvlr3vjb0jGDYhbt0NPKLru0fmmvI8Gc64a8xDYpUKULT5O38fiqMe
         HIH2kNAl8S1DJulKh2+2AGJcObw+/WcDizcvnJvw=
Date:   Fri, 14 Jan 2022 14:03:55 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit.kachhap@arm.com,
        Kevin.Brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        Vincenzo.Frascino@arm.com, viro@zeniv.linux.org.uk
Subject:  [patch 020/146] fs/ioctl: remove unnecessary __user
 annotation
Message-ID: <20220114220355.BH05XczvO%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: fs/ioctl: remove unnecessary __user annotation

__user annotations are used by the checker (e.g sparse) to mark user
pointers.  However here __user is applied to a struct directly, without a
pointer being directly involved.

Although the presence of __user does not cause sparse to emit a warning,
__user should be removed for consistency with other uses of offsetof().

Note: No functional changes intended.

Link: https://lkml.kernel.org/r/20211122101256.7875-1-amit.kachhap@arm.com
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Cc: Kevin Brodsky <Kevin.Brodsky@arm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ioctl.c~fs-ioctl-remove-unnecessary-__user-annotation
+++ a/fs/ioctl.c
@@ -430,7 +430,7 @@ static int ioctl_file_dedupe_range(struc
 		goto out;
 	}
 
-	size = offsetof(struct file_dedupe_range __user, info[count]);
+	size = offsetof(struct file_dedupe_range, info[count]);
 	if (size > PAGE_SIZE) {
 		ret = -ENOMEM;
 		goto out;
_
