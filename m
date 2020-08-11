Return-Path: <SRS0=Ir1+=BV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616BDC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 21:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3711220771
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 21:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597180460;
	bh=LIryRR09hQzlZ0NU8lZJyuJHHaAsXi2EQPhO8efVl6g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dxqrvXYiufPzg1bofoApCBbp0Zl9M+rd2eZebDMDJEQt0HO3bv2qnzVaJQuMRLOoY
	 Gm5894dc8tEUMQmUYpUtEqssiRIHOgew1VAGy56CoQiijJKL3VoZMxowe2lHScNBLA
	 IHH55iU7zrys4J6QnBeUOw8AQqpiHS04FckbWXSk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgHKVOT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 17:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgHKVOT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 17:14:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A4C20756;
        Tue, 11 Aug 2020 21:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597180458;
        bh=LIryRR09hQzlZ0NU8lZJyuJHHaAsXi2EQPhO8efVl6g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jV3ahLsuli4iq+FcOnb2W1HwU17NJkYhzLtP7840NuOlDJEVmbDOdA7D14dBUafFm
         SS5FL926X59ba+l4QmV+dfSIUp2/155PMsA/BHtRIpznCyGxY67HcWWJALs8NE2lIT
         5/uu9Z9YSfwanTzpOr6LfTx6uWrkix3tl8hC/WJs=
Date:   Tue, 11 Aug 2020 14:14:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, david@redhat.com, mm-commits@vger.kernel.org,
        sonnyrao@chromium.org, stable@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-inf?=
 =?US-ASCII?Q?ormation-of-empty-zone.patch?= added to -mm tree
Message-ID: <20200811211418._7_whG2wV%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm/vmstat.c: do not show lowmem reserve protection information of empty zone"
has been added to the -mm tree.  Its filename is
     revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: Revert "mm/vmstat.c: do not show lowmem reserve protection information of empty zone"

This reverts commit 26e7deadaae175.

Sonny reported that one of their tests started failing on the latest
kernel on their Chrome OS platform.  The root cause is that the above
commit removed the protection line of empty zone, while the parser used in
the test relies on the protection line to mark the end of each zone.

Let's revert it to avoid breaking userspace testing or applications.

Link: http://lkml.kernel.org/r/20200811075412.12872-1-bhe@redhat.com
Fixes: 26e7deadaae175 ("mm/vmstat.c: do not show lowmem reserve protection information of empty zone)"
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Sonny Rao <sonnyrao@chromium.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>	[5.8.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmstat.c~revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone
+++ a/mm/vmstat.c
@@ -1618,12 +1618,6 @@ static void zoneinfo_show_print(struct s
 		   zone->present_pages,
 		   zone_managed_pages(zone));
 
-	/* If unpopulated, no other information is useful */
-	if (!populated_zone(zone)) {
-		seq_putc(m, '\n');
-		return;
-	}
-
 	seq_printf(m,
 		   "\n        protection: (%ld",
 		   zone->lowmem_reserve[0]);
@@ -1631,6 +1625,12 @@ static void zoneinfo_show_print(struct s
 		seq_printf(m, ", %ld", zone->lowmem_reserve[i]);
 	seq_putc(m, ')');
 
+	/* If unpopulated, no other information is useful */
+	if (!populated_zone(zone)) {
+		seq_putc(m, '\n');
+		return;
+	}
+
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", zone_stat_name(i),
 			   zone_page_state(zone, i));
_

Patches currently in -mm which might be from bhe@redhat.com are

revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch

