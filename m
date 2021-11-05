Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F5DC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3745611EE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhKEUho (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232084AbhKEUhm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B96A61242;
        Fri,  5 Nov 2021 20:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144502;
        bh=2hc4vY4Tu2uTNEDtYnPWoJC+AGdi9+R26xbGbgeX9Hg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GqbnmHlQUlOu1xWZrXSNdHpdpEPdcJKXcFgduDtyqQjKfTImcOXJq0FNJiW4+bCd2
         H9uvxQeEhYe9No+wWeMNE/ZJ7sjP6fFuHDthepv/f+KWOVvR8vJYTPqAl0HnaMZSbu
         Zp22ogdInNj1mbFGsCeFsOnB66lw5at+yEDGT4ug=
Date:   Fri, 05 Nov 2021 13:35:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de,
        christian.brauner@ubuntu.com, jamorris@linux.microsoft.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        mszeredi@redhat.com, serge@hallyn.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 009/262] fs/posix_acl.c: avoid -Wempty-body
 warning
Message-ID: <20211105203501.yNYlpMbop%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
