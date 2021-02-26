Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7353AC43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 343A264F35
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBZBTH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBZBTG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D115D64EE4;
        Fri, 26 Feb 2021 01:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302305;
        bh=CJDIAAZjkJlq5Wiy4fH32o5uNdasFlYIH1qfui0LexY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KbQ1iWFgc3AtOXkmckLHlGS+rXN+4CnkVmA5HGbdOgv1/vzAR83iNTegg1r+7XTC+
         M0X0mM0RrMGXWgLkAubM1bWYxtnmOOAXB82SqVpueBIZUgMgxNcLi7130Kqq+30Rwk
         HdzzJCkTpEQdTgsfJ5vQ9LPwKECu25aqZW4ea/ig=
Date:   Thu, 25 Feb 2021 17:18:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        ddstreet@ieee.org, efault@gmx.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        song.bao.hua@hisilicon.com, tiantao6@hisilicon.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 048/118] mm: set the sleep_mapped to true for zbud
 and z3fold
Message-ID: <20210226011822.2r2QuMqVR%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
