Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8C4C7618E
	for <mm-commits@archiver.kernel.org>; Thu, 20 Apr 2023 22:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjDTWka (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Apr 2023 18:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbjDTWk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Apr 2023 18:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AF613E
        for <mm-commits@vger.kernel.org>; Thu, 20 Apr 2023 15:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E86764C5F
        for <mm-commits@vger.kernel.org>; Thu, 20 Apr 2023 22:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1237C433EF;
        Thu, 20 Apr 2023 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682030426;
        bh=vsLmJfx3v1UACCdJ4fjPxXbLKAcOc0CBBK+CQYCNrrY=;
        h=Date:To:From:Subject:From;
        b=oSZR5oB7JHg6RX21HXQXyzTjCsQMO49sb3OA8Kk3uKdBnFjonJU6YrtfRCIKECnDg
         fKdXiTZFFOXhyYr+R/ea0fSgqRUO3eRHt41nIWJO691iPtf+dtpURKqBZKdevuKE9a
         NL55mIdlNociFE4OSSkmGhIcrFERRS+Kfn1fmj9U=
Date:   Thu, 20 Apr 2023 15:40:25 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        willy@infradead.org, p.raghav@samsung.com, mcgrof@kernel.org,
        keescook@chromium.org, hughd@google.com, dave@stgolabs.net,
        a.manzanares@samsung.com, brauner@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-restrict-noswap-option-to-initial-user-namespace.patch added to mm-unstable branch
Message-Id: <20230420224026.A1237C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: restrict noswap option to initial user namespace
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-restrict-noswap-option-to-initial-user-namespace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-restrict-noswap-option-to-initial-user-namespace.patch

This patch will later appear in the mm-unstable branch at
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
From: Christian Brauner <brauner@kernel.org>
Subject: shmem: restrict noswap option to initial user namespace
Date: Thu, 20 Apr 2023 10:57:43 +0200

Prevent tmpfs instances mounted in an unprivileged namespaces from evading
accounting of locked memory by using the "noswap" mount option.

Link: https://lkml.kernel.org/r/20230420-faxen-advokat-40abb4c1a152@brauner
Signed-off-by: Christian Brauner <brauner@kernel.org>
Reported-by: Hugh Dickins <hughd@google.com>
  Link: https://lore.kernel.org/lkml/79eae9fe-7818-a65c-89c6-138b55d609a@google.com
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/shmem.c~shmem-restrict-noswap-option-to-initial-user-namespace
+++ a/mm/shmem.c
@@ -3712,6 +3712,10 @@ static int shmem_parse_one(struct fs_con
 		ctx->seen |= SHMEM_SEEN_INUMS;
 		break;
 	case Opt_noswap:
+		if ((fc->user_ns != &init_user_ns) || !capable(CAP_SYS_ADMIN)) {
+			return invalfc(fc,
+				       "Turning off swap in unprivileged tmpfs mounts unsupported");
+		}
 		ctx->noswap = true;
 		ctx->seen |= SHMEM_SEEN_NOSWAP;
 		break;
_

Patches currently in -mm which might be from brauner@kernel.org are

shmem-restrict-noswap-option-to-initial-user-namespace.patch

