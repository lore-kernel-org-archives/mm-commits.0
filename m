Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81875EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 18:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjFSShF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 14:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjFSShE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 14:37:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC62130
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 11:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFBEC60E33
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 18:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BDDC433C0;
        Mon, 19 Jun 2023 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687199822;
        bh=3ycZwikWowdVvoU044IQepAqGs88JkqigPzt6J9wu3c=;
        h=Date:To:From:Subject:From;
        b=YJcCP+wSpxplb1RP+ENZxytr6BmZaZf39WfzVpaUR6AXF7nzQTFHxG9z8opQesq0k
         j/EwUwRHIVSEejvUecfm3glvRGdj0Nch9YZ/lf3OqbhrhIHEN9R2HDJKMisuMhXM1d
         0uSmCTt8+3juE52HSCBtqv5OoTgG1H8J9dRlkPPE=
Date:   Mon, 19 Jun 2023 11:37:01 -0700
To:     mm-commits@vger.kernel.org, jglauber@digitalocean.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-shmem-thp-counters-on-migration.patch added to mm-unstable branch
Message-Id: <20230619183702.31BDDC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix shmem THP counters on migration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-shmem-thp-counters-on-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-shmem-thp-counters-on-migration.patch

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
Subject: mm: fix shmem THP counters on migration
Date: Mon, 19 Jun 2023 12:33:51 +0200

The per node numa_stat values for shmem don't change on
page migration for THP:

  grep shmem /sys/fs/cgroup/machine.slice/.../memory.numa_stat:

    shmem N0=1092616192 N1=10485760
    shmem_thp N0=1092616192 N1=10485760

  migratepages 9181 0 1:

    shmem N0=0 N1=1103101952
    shmem_thp N0=1092616192 N1=10485760

Fix that by updating shmem_thp counters likewise to shmem counters
on page migration.

Link: https://lkml.kernel.org/r/20230619103351.234837-1-jglauber@digitalocean.com
Signed-off-by: Jan Glauber <jglauber@digitalocean.com>
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
+			if (folio_test_transhuge(folio)) {
+				__mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
+				__mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
+			}
 		}
 #ifdef CONFIG_SWAP
 		if (folio_test_swapcache(folio)) {
_

Patches currently in -mm which might be from jglauber@digitalocean.com are

mm-fix-shmem-thp-counters-on-migration.patch

