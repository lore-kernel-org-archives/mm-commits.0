Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDEEC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B5664E66
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBKSeo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232817AbhBKScz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 13:32:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B7164E70;
        Thu, 11 Feb 2021 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068257;
        bh=GGuDgfQY5xMqwjDHMqTFnmIXpUFuULRDTEJjoAUexPU=;
        h=Date:From:To:Subject:From;
        b=su124/7tw5wVXf8/NBZXa2wTRjDlGG+LXGIah8HKpsHBze4UPJj7lGXeCsEv/bfAz
         3mr0i/HMPbUa/Q3kuI9l9ettOr+yZNYE264geXflHcNwV5s5jPJgA79CknpFxAPcn/
         eam6EnN1sFoEnHqYiMMdqjSoaPiCui02esQYyuTE=
Date:   Thu, 11 Feb 2021 10:30:57 -0800
From:   akpm@linux-foundation.org
To:     amir73il@gmail.com, chris@chrisdown.name, hughd@google.com,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rth@twiddle.net,
        seth.forshee@canonical.com, stable@vger.kernel.org
Subject:  [merged]
 tmpfs-disallow-config_tmpfs_inode64-on-alpha.patch removed from -mm tree
Message-ID: <20210211183057.Ou3yopthO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
has been removed from the -mm tree.  Its filename was
     tmpfs-disallow-config_tmpfs_inode64-on-alpha.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Seth Forshee <seth.forshee@canonical.com>
Subject: tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha

As with s390, alpha is a 64-bit architecture with a 32-bit ino_t.  With
CONFIG_TMPFS_INODE64=y tmpfs mounts will get 64-bit inode numbers and
display "inode64" in the mount options, whereas passing "inode64" in the
mount options will fail.  This leads to erroneous behaviours such as this:

 # mkdir mnt
 # mount -t tmpfs nodev mnt
 # mount -o remount,rw mnt
 mount: /home/ubuntu/mnt: mount point not mounted or bad option.

Prevent CONFIG_TMPFS_INODE64 from being selected on alpha.

Link: https://lkml.kernel.org/r/20210208215726.608197-1-seth.forshee@canonical.com
Fixes: ea3271f7196c ("tmpfs: support 64-bit inums per-sb")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/Kconfig~tmpfs-disallow-config_tmpfs_inode64-on-alpha
+++ a/fs/Kconfig
@@ -203,7 +203,7 @@ config TMPFS_XATTR
 
 config TMPFS_INODE64
 	bool "Use 64-bit ino_t by default in tmpfs"
-	depends on TMPFS && 64BIT && !S390
+	depends on TMPFS && 64BIT && !(S390 || ALPHA)
 	default n
 	help
 	  tmpfs has historically used only inode numbers as wide as an unsigned
_

Patches currently in -mm which might be from seth.forshee@canonical.com are


