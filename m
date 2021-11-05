Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E020C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AAE961288
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhKEUqo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233709AbhKEUqn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14A836126A;
        Fri,  5 Nov 2021 20:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145043;
        bh=o41G0KB57z8NSrtBDoNXTpJD2BS1KUFIOHIwDviooeg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0NjwxFjRlIC58kkiMgaZmI3kj9325f9q458laeKNJWXzRpW+0ifJvNrxTZ4PvWpe4
         oHdjsUMzZ+afIPA9ZT+0Mo+aqt4M6E1JMrun3y43TOriJx3mUyt/pi77fgYLWmA5rM
         adEMzbuVKIudTM5yjiXdMMr44VIVtz9gVUpbtrdQ=
Date:   Fri, 05 Nov 2021 13:44:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linf@wangsu.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 180/262] mm: vmstat.c: make extfrag_index show
 more pretty
Message-ID: <20211105204402.BiH6mxuKf%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lin Feng <linf@wangsu.com>
Subject: mm: vmstat.c: make extfrag_index show more pretty

fragmentation_index may return -1000 and the corresponding formated value
showed by seq_printf will take a negative signatrue, but other positive
formated values don't take a positive signatrue, so the output becomes
unaligned.

before:
Node 0, zone      DMA -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000
Node 0, zone    DMA32 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000
Node 0, zone   Normal -1.000 -1.000 -1.000 -1.000 0.931 0.966 0.983 0.992 0.996 0.998 0.999

after this patch:
Node 0, zone      DMA -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000
Node 0, zone    DMA32 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000
Node 0, zone   Normal -1.000 -1.000 -1.000 -1.000  0.931  0.966  0.983  0.992  0.996  0.998  0.999

Link: https://lkml.kernel.org/r/20211019103241.134797-1-linf@wangsu.com
Signed-off-by: Lin Feng <linf@wangsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstatc-make-extfrag_index-show-more-pretty
+++ a/mm/vmstat.c
@@ -2191,7 +2191,7 @@ static void extfrag_show_print(struct se
 	for (order = 0; order < MAX_ORDER; ++order) {
 		fill_contig_page_info(zone, order, &info);
 		index = __fragmentation_index(order, &info);
-		seq_printf(m, "%d.%03d ", index / 1000, index % 1000);
+		seq_printf(m, "%2d.%03d ", index / 1000, index % 1000);
 	}
 
 	seq_putc(m, '\n');
_
