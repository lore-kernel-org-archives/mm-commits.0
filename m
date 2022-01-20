Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C924DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377809AbiATVXf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiATVXf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99D2C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 753F961893
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA740C340E0;
        Thu, 20 Jan 2022 21:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713813;
        bh=TGovT0JTzJs1DQMsdVDlGfLOpb35CO6jIwDUUEv0i4o=;
        h=Date:From:To:Subject:From;
        b=WiNaxLGKuKi/j8fxkTW7lHQY1SsSzx9eUHsN7I5NVl7r65Scl8mz1tt9MOF4VR5RR
         CfFChj+jN25gxwEoWA3NOplCsD76G3noGeqNdhOy0ifqcUXvoTbpwmbysrJXWg7jIA
         LjfXV+s69tFhLAKJNDyjdvfiI6+i23gkwfXQSJhA=
Date:   Thu, 20 Jan 2022 13:23:33 -0800
From:   akpm@linux-foundation.org
To:     amit.kachhap@arm.com, Kevin.Brodsky@arm.com,
        mm-commits@vger.kernel.org, Vincenzo.Frascino@arm.com,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-ioctl-remove-unnecessary-__user-annotation.patch removed from -mm tree
Message-ID: <20220120212333.XQfOx_ON8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ioctl: remove unnecessary __user annotation
has been removed from the -mm tree.  Its filename was
     fs-ioctl-remove-unnecessary-__user-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from amit.kachhap@arm.com are


