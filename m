Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17644EB64DC
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jun 2023 20:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjFVUDm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Jun 2023 16:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjFVUDl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2023 16:03:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860DA1FF2
        for <mm-commits@vger.kernel.org>; Thu, 22 Jun 2023 13:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20282618D1
        for <mm-commits@vger.kernel.org>; Thu, 22 Jun 2023 20:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64867C433CD;
        Thu, 22 Jun 2023 20:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687464218;
        bh=NWEYUXcqCQnbSQYUd75j5CQC8ViKGs0Z8Cpy//TMnC0=;
        h=Date:To:From:Subject:From;
        b=L6Af9EcO+nTXS5wGHglHY6d10JWf0fHMR8EUStxlQkFPcvD6NqQv0C18wFa4630II
         2xd8xUDVQlpCRECN4+fcpctBtyeNC90jEUuSYPHLiilPEUvk/bDT6O/VsgH/ifZLwv
         TTYVr5ET/M5OJU4rRzcjS1DIAirnkLViqQj8gm1o=
Date:   Thu, 22 Jun 2023 13:03:37 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        baolin.wang@linux.alibaba.com, jglauber@digitalocean.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-shmem-thp-counters-on-migration-v3.patch added to mm-unstable branch
Message-Id: <20230622200338.64867C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-shmem-thp-counters-on-migration-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-shmem-thp-counters-on-migration-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-shmem-thp-counters-on-migration-v3.patch

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
From: Jan Glauber <jglauber@digitalocean.com>
Subject: mm-fix-shmem-thp-counters-on-migration-v3
Date: Thu, 22 Jun 2023 11:47:20 +0200

use folio_test_pmd_mappable instead of folio_test_transhuge

Link: https://lkml.kernel.org/r/20230622094720.510540-1-jglauber@digitalocean.com
Signed-off-by: Jan Glauber <jglauber@digitalocean.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-fix-shmem-thp-counters-on-migration-v3
+++ a/mm/migrate.c
@@ -487,7 +487,7 @@ int folio_migrate_mapping(struct address
 			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
 			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 
-			if (folio_test_transhuge(folio)) {
+			if (folio_test_pmd_mappable(folio)) {
 				__mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
 				__mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
 			}
_

Patches currently in -mm which might be from jglauber@digitalocean.com are

mm-fix-shmem-thp-counters-on-migration.patch
mm-fix-shmem-thp-counters-on-migration-v3.patch

