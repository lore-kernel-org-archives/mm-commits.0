Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936B5C64ED8
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 21:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjB0VnL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 16:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjB0VnK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 16:43:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1108283EB
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 13:43:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5394B80D9A
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 21:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C48EC433EF;
        Mon, 27 Feb 2023 21:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677534184;
        bh=od2OIxSXDzvIDD9KJKFDyvj54QR8EM3/Kzjcg634yjE=;
        h=Date:To:From:Subject:From;
        b=oF52/+rukQtDA+RnxO66igUZSBevkyfBqG9oC0JvjNtAyp7xhEzwJkPqhGLe+eNCn
         wNy1zHfOztX6Gh59LCRIvn7DqBRlprniK+VOE9EOIQaMBzPHYc4ttWlI5zdLZSTObn
         EfQB6bWtm+Ox8OJUjwV87deMta//BqyZB48Zoo7w=
Date:   Mon, 27 Feb 2023 13:43:03 -0800
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        anna@kernel.org, ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl.patch added to mm-nonmm-unstable branch
Message-Id: <20230227214304.6C48EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nfs: remove empty if statement from nfs3_prepare_get_acl
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: nfs: remove empty if statement from nfs3_prepare_get_acl
Date: Wed, 30 Nov 2022 16:12:31 +0100

Remove empty if statement from nfs3_prepare_get_acl and update comment to
follow the one from the referred fs/posix_acl.c:get_acl().

No functional change intended.

Link: https://lkml.kernel.org/r/20221130151231.3654-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/nfs/nfs3acl.c~nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl
+++ a/fs/nfs/nfs3acl.c
@@ -21,9 +21,8 @@ static void nfs3_prepare_get_acl(struct
 {
 	struct posix_acl *sentinel = uncached_acl_sentinel(current);
 
-	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED) {
-		/* Not the first reader or sentinel already in place. */
-	}
+	/* If the ACL isn't being read yet, set our sentinel. */
+	cmpxchg(p, ACL_NOT_CACHED, sentinel);
 }
 
 static void nfs3_complete_get_acl(struct posix_acl **p, struct posix_acl *acl)
_

Patches currently in -mm which might be from ubizjak@gmail.com are

nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl.patch

