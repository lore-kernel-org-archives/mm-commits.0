Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2287C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC63060FC1
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhKEUts (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhKEUtr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:49:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7895A60240;
        Fri,  5 Nov 2021 20:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145227;
        bh=87zvzF9/N7d3ulr8MqQTzSdhjGE1/wQ5xaFcOURjg6M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yhYZLuUGkR0hfixY3Qvz1PsUH2TXx7BNvRn2rpO2Lqj3YR1BXcrfFEg9nQRz+38G7
         RyEKt5uoSzUBd7E3XszwyBTdpr2KKYNNpD9hwd0aQ4MtmDSY2OP2LJRS5lAVSntZBD
         /QQtf/VnII7vk4YOi3XAyn8k/u1tPUDGT9CuwYqc=
Date:   Fri, 05 Nov 2021 13:47:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 237/262] mm/damon/vaddr: constify static
 mm_walk_ops
Message-ID: <20211105204707.YEomvIVb6%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: mm/damon/vaddr: constify static mm_walk_ops

The only usage of these structs is to pass their addresses to
walk_page_range(), which takes a pointer to const mm_walk_ops as argument.
Make them const to allow the compiler to put them in read-only memory.

Link: https://lkml.kernel.org/r/20211014075042.17174-2-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-constify-static-mm_walk_ops
+++ a/mm/damon/vaddr.c
@@ -394,7 +394,7 @@ out:
 	return 0;
 }
 
-static struct mm_walk_ops damon_mkold_ops = {
+static const struct mm_walk_ops damon_mkold_ops = {
 	.pmd_entry = damon_mkold_pmd_entry,
 };
 
@@ -490,7 +490,7 @@ out:
 	return 0;
 }
 
-static struct mm_walk_ops damon_young_ops = {
+static const struct mm_walk_ops damon_young_ops = {
 	.pmd_entry = damon_young_pmd_entry,
 };
 
_
