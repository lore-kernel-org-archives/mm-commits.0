Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDC1C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC17423104
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391760AbhASTil (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391595AbhASTid (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:38:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 921BD23105;
        Tue, 19 Jan 2021 19:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611085073;
        bh=3qOmcqPG1eA0ecD9j0zNObnHKK5hV2eVFgU7PJzsvW8=;
        h=Date:From:To:Subject:From;
        b=lke9X8FbfdSFMSt7+AB9rkOy0Cj5v8FAelhWB16WRBhJj3dHZr4iCfvBbORkl35oC
         h3PvLpZHR8E0E5q8cWekiG56pw4wJREJ0Z74WFef/i45B/uomBKszzhWAMlYL86gXB
         MMViIp4Hcd5X85atPQsXEMGqHB69ClrYTU2mKubo=
Date:   Tue, 19 Jan 2021 11:37:51 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, ddstreet@ieee.org, efault@gmx.de,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        song.bao.hua@hisilicon.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  +
 mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch added to -mm tree
Message-ID: <20210119193751.YTVeb817B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: set the sleep_mapped to true for zbud and z3fold
has been added to the -mm tree.  Its filename is
     mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tian Tao <tiantao6@hisilicon.com>
Subject: mm: set the sleep_mapped to true for zbud and z3fold

zpool driver adds a flag to indicate whether the zpool driver can enter an
atomic context after mapping.  This patch sets it true for z3fold and
zbud.

Link: https://lkml.kernel.org/r/1611035683-12732-3-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Mike Galbraith <efault@gmx.de>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    1 +
 mm/zbud.c   |    1 +
 2 files changed, 2 insertions(+)

--- a/mm/z3fold.c~mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold
+++ a/mm/z3fold.c
@@ -1778,6 +1778,7 @@ static u64 z3fold_zpool_total_size(void
 
 static struct zpool_driver z3fold_zpool_driver = {
 	.type =		"z3fold",
+	.sleep_mapped = true,
 	.owner =	THIS_MODULE,
 	.create =	z3fold_zpool_create,
 	.destroy =	z3fold_zpool_destroy,
--- a/mm/zbud.c~mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold
+++ a/mm/zbud.c
@@ -203,6 +203,7 @@ static u64 zbud_zpool_total_size(void *p
 
 static struct zpool_driver zbud_zpool_driver = {
 	.type =		"zbud",
+	.sleep_mapped = true,
 	.owner =	THIS_MODULE,
 	.create =	zbud_zpool_create,
 	.destroy =	zbud_zpool_destroy,
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are

mm-zswap-add-the-flag-can_sleep_mapped.patch
mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch

