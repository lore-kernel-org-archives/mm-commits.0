Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D14C433E3
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BF72193E
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689708;
	bh=IP1i6e0Dy1emzvAZpberqq3O2rmPImSLDeFRCKe1ih0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1FG8EMGeJwRYKVgBRmTlzCyD/0IZiCZXghBnKVnYC6Mjx4Hg+sjlYaW7w0PFsOfgA
	 wKlSGJxsTzN7oqQQCNW9EwJ570BcVaIwy06SSzTSMBz8Q0fPg2EtD5+WKX87TcWNmv
	 /wx9NfhsfdL4BFBa9eEFkIAnoojT3HMf+Y0ugcTI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgGNBVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBVs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:21:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB01A2192A;
        Tue, 14 Jul 2020 01:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689707;
        bh=IP1i6e0Dy1emzvAZpberqq3O2rmPImSLDeFRCKe1ih0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fJlQMZ0Dh1F6mQHF3uyiP5PGQQvKE3Vp5peGphVqA7hmaO75YVe8ON1BKUnr74air
         RtXEeiRALosSqYmEE2x6ybtzH7hl6kFY0YGJO/TCTSOLr+f5vtv6NA5maB4yd2zCgL
         1LLAYlnN4rA+8ZYX+887dGPqZCr+nDfccrJCJNgQ=
Date:   Mon, 13 Jul 2020 18:21:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-migrate-clear-=5F=5Fgfp=5Freclaim-to-make-the-migratio?=
 =?US-ASCII?Q?n-callback-consistent-with-regular-thp-allocations-fix.p?=
 =?US-ASCII?Q?atch?= added to -mm tree
Message-ID: <20200714012147.dY9_yBXIR%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix
has been added to the -mm tree.  Its filename is
     mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix

fix comment typo, per Vlastimil

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix
+++ a/mm/migrate.c
@@ -1551,7 +1551,7 @@ struct page *new_page_nodemask(struct pa
 
 	if (PageTransHuge(page)) {
 		/*
-		 * clear __GFP_RECALIM to make the migration callback
+		 * clear __GFP_RECLAIM to make the migration callback
 		 * consistent with regular THP allocations.
 		 */
 		gfp_mask &= ~__GFP_RECLAIM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

