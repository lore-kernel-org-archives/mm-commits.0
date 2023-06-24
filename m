Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4467DEB64DD
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjFXAAU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjFXAAL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E92270D
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B9FE614A8
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA45C433C8;
        Sat, 24 Jun 2023 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564810;
        bh=KYYrYwJAEa5Rccb/CkGNM2eGCXrTdZX8RUrG9REdW5I=;
        h=Date:To:From:Subject:From;
        b=tnwaHpiVkNgcf8lFFDKvJZgJk/x60NMwIsQwnmUKwscW+s8v0849mX2zOuI9qUOj5
         QaFGjLlV5Yvy2KAopuiNXRnL/tI7BfDlOak9UfHfWGUYt5pCQJG6eVU5+pKwJ9mwow
         mGvtzoRGfToEtZm7t8yPlCHqbU1QgEscvaPUpKTA=
Date:   Fri, 23 Jun 2023 17:00:09 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        baolin.wang@linux.alibaba.com, jglauber@digitalocean.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-shmem-thp-counters-on-migration.patch removed from -mm tree
Message-Id: <20230624000009.EFA45C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix shmem THP counters on migration
has been removed from the -mm tree.  Its filename was
     mm-fix-shmem-thp-counters-on-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Glauber <jglauber@digitalocean.com>
Subject: mm: fix shmem THP counters on migration
Date: Mon, 19 Jun 2023 12:33:51 +0200

The per node numa_stat values for shmem don't change on page migration for
THP:

  grep shmem /sys/fs/cgroup/machine.slice/.../memory.numa_stat:

    shmem N0=1092616192 N1=10485760
    shmem_thp N0=1092616192 N1=10485760

  migratepages 9181 0 1:

    shmem N0=0 N1=1103101952
    shmem_thp N0=1092616192 N1=10485760

Fix that by updating shmem_thp counters likewise to shmem counters on page
migration.

[jglauber@digitalocean.com: use folio_test_pmd_mappable instead of folio_test_transhuge]
  Link: https://lkml.kernel.org/r/20230622094720.510540-1-jglauber@digitalocean.com
Link: https://lkml.kernel.org/r/20230619103351.234837-1-jglauber@digitalocean.com
Signed-off-by: Jan Glauber <jglauber@digitalocean.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/migrate.c~mm-fix-shmem-thp-counters-on-migration
+++ a/mm/migrate.c
@@ -486,6 +486,11 @@ int folio_migrate_mapping(struct address
 		if (folio_test_swapbacked(folio) && !folio_test_swapcache(folio)) {
 			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
 			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
+
+			if (folio_test_pmd_mappable(folio)) {
+				__mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
+				__mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
+			}
 		}
 #ifdef CONFIG_SWAP
 		if (folio_test_swapcache(folio)) {
_

Patches currently in -mm which might be from jglauber@digitalocean.com are


