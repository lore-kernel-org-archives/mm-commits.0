Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77A5C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 961D823118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgLPEN6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:13:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgLPEN6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:13:58 -0500
Date:   Tue, 15 Dec 2020 20:13:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091991;
        bh=Wr5M0iMmvDpIBVoL+cX8Nx3Pj23NzrfCISyYVWXflrI=;
        h=From:To:Subject:From;
        b=y/P4wdkJcOuJ0unl5qoksD9neUciunjzbdolxBKDiqxAW9H9KlEmBAcEkxjRsWH2y
         GYMHb7sf8ZNd9Y+TPT3b48egMaMhYbZczZaatMAELjBizDbZQlvyJeiC2uAsITUYje
         YZ8n+Es0wMMDfx0g6rJFsKDNOek3+PGKAoPHOenA=
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?checkpatch-add-printk=5Fonce-and-printk=5Fratelimit-to-prefe?=
 =?US-ASCII?Q?r-pr=5Flevel-warning-fix.patch?= removed from -mm tree
Message-ID: <20201216041311.30VlFGNgH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix.patch

This patch was dropped because it was folded into checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix

It also needs:

Link: https://lkml.kernel.org/r/32260871d4718ba7f48a8e9e07452bb76de300db.camel@perches.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/checkpatch.pl~checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix
+++ a/scripts/checkpatch.pl
@@ -4548,6 +4548,7 @@ sub process {
 			my $printk = $1;
 			my $modifier = $2;
 			my $orig = $3;
+			$modifier = "" if (!defined($modifier));
 			my $level = lc($orig);
 			$level = "warn" if ($level eq "warning");
 			my $level2 = $level;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch

