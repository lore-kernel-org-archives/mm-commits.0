Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F25C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D6FE61872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhKKCm1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233813AbhKKCm1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A57D06187A;
        Thu, 11 Nov 2021 02:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598378;
        bh=MDkRi3y5RHxCM1VhiX146mR0WKkmR/BF9cX8uSXQ++U=;
        h=Date:From:To:Subject:From;
        b=sF1cmQAhf1ch+wxk3njCTwwdbVwprRb1KQm72pSuxz/iiJNsyXZxn/TTXft0Fn55K
         vN136MYH5xGPRew1RaXvkrqF0YLcPh7bplndu9T44a5LCi3UVdnAnnmVjHVMGCKs4U
         IIgjnIkr9b5gCtMNx2vXv+lpEu25oR0PmgBtywtE=
Date:   Wed, 10 Nov 2021 18:39:38 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, christian.brauner@ubuntu.com,
        jamorris@linux.microsoft.com, mm-commits@vger.kernel.org,
        mszeredi@redhat.com, serge@hallyn.com, viro@zeniv.linux.org.uk
Subject:  [merged] posix-acl-avoid-wempty-body-warning.patch
 removed from -mm tree
Message-ID: <20211111023938.OsJU8IzY-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/posix_acl.c: avoid -Wempty-body warning
has been removed from the -mm tree.  Its filename was
     posix-acl-avoid-wempty-body-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fs/posix_acl.c: avoid -Wempty-body warning

The fallthrough comment for an ignored cmpxchg() return value produces a
harmless warning with 'make W=1':

fs/posix_acl.c: In function 'get_acl':
fs/posix_acl.c:127:36: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  127 |                 /* fall through */ ;
      |                                    ^

Simplify it as a step towards a clean W=1 build.  As all architectures
define cmpxchg() as a statement expression these days, it is no longer
necessary to evaluate its return code, and the if() can just be droped.

Link: https://lkml.kernel.org/r/20210927102410.1863853-1-arnd@kernel.org
Link: https://lore.kernel.org/all/20210322132103.qiun2rjilnlgztxe@wittgenstein/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/posix_acl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/posix_acl.c~posix-acl-avoid-wempty-body-warning
+++ a/fs/posix_acl.c
@@ -134,8 +134,7 @@ struct posix_acl *get_acl(struct inode *
 	 * to just call ->get_acl to fetch the ACL ourself.  (This is going to
 	 * be an unlikely race.)
 	 */
-	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
-		/* fall through */ ;
+	cmpxchg(p, ACL_NOT_CACHED, sentinel);
 
 	/*
 	 * Normally, the ACL returned by ->get_acl will be cached.
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-test-use-underlying-string-helpers.patch

