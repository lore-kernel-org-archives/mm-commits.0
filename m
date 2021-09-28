Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC00C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 562E460FF2
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbhI1AjV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238236AbhI1AjU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 20:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B081760F4A;
        Tue, 28 Sep 2021 00:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632789459;
        bh=zlL0vjNonDQN0iBkLUSnm0ZnAMt+vxCeeHEiDY7tCD8=;
        h=Date:From:To:Subject:From;
        b=WTKOBOEeNgRTfQInS5OqmRAaB1cxQXBRRH41zMZhizIwhNpddx4zltmA8YpzyucSl
         SvFkEAQFHkqGbgOlTG8qc/a7DUfV2c0M/Fwe6yhmXbhA01a34jMaHHJyBcGbU2avi3
         7wUpUJTALXwS65hAuwvcNt+8uBc6inJrXTeBwa04=
Date:   Mon, 27 Sep 2021 17:37:38 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, christian.brauner@ubuntu.com,
        jamorris@linux.microsoft.com, mm-commits@vger.kernel.org,
        mszeredi@redhat.com, serge@hallyn.com, viro@zeniv.linux.org.uk
Subject:  + posix-acl-avoid-wempty-body-warning.patch added to -mm
 tree
Message-ID: <20210928003738.MsC1U-yJe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/posix_acl.c: avoid -Wempty-body warning
has been added to the -mm tree.  Its filename is
     posix-acl-avoid-wempty-body-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/posix-acl-avoid-wempty-body-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/posix-acl-avoid-wempty-body-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

posix-acl-avoid-wempty-body-warning.patch
hfs-hfsplus-use-warn_on-for-sanity-check.patch

