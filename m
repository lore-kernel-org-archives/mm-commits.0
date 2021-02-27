Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72721C4332D
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F4564F38
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhB0CbA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhB0Caj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 790DE64F41;
        Sat, 27 Feb 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393009;
        bh=2hqZeaFdvA9msr2BSOFc/2Iia4U8Z9mJqvPZA46j3OM=;
        h=Date:From:To:Subject:From;
        b=oM2qo5/5M7mq4z715wadTQ8yzSF3JqGgC2I6TnymGzcBBdRZiB+sd2VGWFH4Llod0
         BgTI5mCZidEBkwr4oTE+Tk+vlAM0Jy1vySK6pi/z52ShKQYGLj1BdFgRa2odbHFG1v
         FY7+1gFCEMVnnykMrWKvqGWguF2RlWb6M6pFH7ww=
Date:   Fri, 26 Feb 2021 18:30:09 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, ddstreet@ieee.org, efault@gmx.de,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        song.bao.hua@hisilicon.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch removed from -mm
 tree
Message-ID: <20210227023009.4bnF1GtFX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: set the sleep_mapped to true for zbud and z3fold
has been removed from the -mm tree.  Its filename was
     mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1771,6 +1771,7 @@ static u64 z3fold_zpool_total_size(void
 
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


