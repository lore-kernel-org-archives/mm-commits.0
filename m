Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A945C77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbjDFCxe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbjDFCxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16BD5243
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FB5A64125
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A559C433EF;
        Thu,  6 Apr 2023 02:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749579;
        bh=i3r/GHWovpY5cahz5cM1Q5l14ga4f4qxihn1nE/7ib4=;
        h=Date:To:From:Subject:From;
        b=k8V3njqZS4KPa+sPL/la+LTGJ19J7MmB2VxLNOE4VrpXpgyOC3+VB+CJyBweuKrTk
         wi1jDDxuszLCtx04zM2nkfDyavqeiYTf2rIwGYwMjBV64BL25GVPB5M3r7c8AcEtOK
         815/qIJYXL67+b56q8NnDi4N06X0RGXzGQAITDcg=
Date:   Wed, 05 Apr 2023 19:52:58 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        anna@kernel.org, ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl.patch removed from -mm tree
Message-Id: <20230406025259.7A559C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nfs: remove empty if statement from nfs3_prepare_get_acl
has been removed from the -mm tree.  Its filename was
     nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 fs/nfs/nfs3acl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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


