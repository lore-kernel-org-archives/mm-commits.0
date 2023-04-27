Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68CFC77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Apr 2023 20:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344256AbjD0Umt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Apr 2023 16:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344241AbjD0Umt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2023 16:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A32CE55
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 13:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2650363FC0
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72792C433EF;
        Thu, 27 Apr 2023 20:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682628163;
        bh=8lgjwHOAuqi121hH1uaAlGy+urhwkr2uZxIuTYCKsxk=;
        h=Date:To:From:Subject:From;
        b=MAFQ6x0W4LB3Q+fVU20ewzxkQCcqICLz+qDdaRoZjyUpfcu+zm3mNK0mnX7dTq1p1
         vxe1YZz6oM/q+KQVjxL2KqvJDqUo3Z5v/n1Vo2SDnP2iPnJtniXSqdp2snM5Gm/pPL
         9+RhFL2IP2xU1E0se05LJiqETCVccNjpX5taMoyc=
Date:   Thu, 27 Apr 2023 13:42:42 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        willy@infradead.org, p.raghav@samsung.com, mcgrof@kernel.org,
        keescook@chromium.org, hughd@google.com, dave@stgolabs.net,
        a.manzanares@samsung.com, brauner@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-restrict-noswap-option-to-initial-user-namespace.patch removed from -mm tree
Message-Id: <20230427204243.72792C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: restrict noswap option to initial user namespace
has been removed from the -mm tree.  Its filename was
     shmem-restrict-noswap-option-to-initial-user-namespace.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3582,6 +3582,10 @@ static int shmem_parse_one(struct fs_con
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


