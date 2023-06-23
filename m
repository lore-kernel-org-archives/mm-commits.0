Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A58EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 23:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbjFWXxk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 19:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjFWXxd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 19:53:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE75C270A
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 16:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E66361300
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 23:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4135C433C0;
        Fri, 23 Jun 2023 23:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564411;
        bh=npNj/1NLmRbb3hr8C5LJVwq+CP2YoSrjZH3RlgasPXY=;
        h=Date:To:From:Subject:From;
        b=dvHarzO+c3HWrqLpjnOlmO27PfAufsk50jZeLJWYbMl4GMTzpL8LpzpXrL4FCSiYc
         erIbOGI/e+Kan4DJbTMAjNtSUKleZrtXqQqm04zd5YJiyUGKpS8MvghAmf/kkoJkof
         ifs4WjMAzORDIWGjUu2Dxpvag+TGKpKx0HyOTc5c=
Date:   Fri, 23 Jun 2023 16:53:31 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        baolin.wang@linux.alibaba.com, jglauber@digitalocean.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-shmem-thp-counters-on-migration-v3.patch removed from -mm tree
Message-Id: <20230623235331.B4135C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-shmem-thp-counters-on-migration-v3
has been removed from the -mm tree.  Its filename was
     mm-fix-shmem-thp-counters-on-migration-v3.patch

This patch was dropped because it was folded into mm-fix-shmem-thp-counters-on-migration.patch

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

