Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A67DC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12A702177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779736;
	bh=0lxWvYZvR0c7eqPHbKxd/vbHwRr21lBX0thzWUXoBvM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=F8nqswsRfAFAh/lYZaE/Os/ncICKSCZSjzbTa6AQV4bGzhbGtJ5rU/L8OpCwq0LQR
	 7JctguGIMHS1Psz83XMm+8iEehi4ZBBIpgW6N/h5ERWzZIMncwr5lLxDgLH4iUdI79
	 uOr0NHnEnOgBOaNw6sUCAhTihTpc2qjM3nJMcEpM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGFzf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGFzf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:55:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2720B21744;
        Fri,  7 Aug 2020 05:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779735;
        bh=0lxWvYZvR0c7eqPHbKxd/vbHwRr21lBX0thzWUXoBvM=;
        h=Date:From:To:Subject:From;
        b=hdQw3ms7EwkTljn9j6V0mCVsK1lzGWAUjfJ09l7swRDdunWWNya+ar25gYqvBE3QK
         oZuAtTkomihF+Q07S3cKP6lK107UZf2mHKrBZrenMUFuyAVyVHHiu5vZop39eFKVU0
         nc1qaTCqByQnCFWGhSAAQtN9TFKcsYrgAr1+tOLw=
Date:   Thu, 06 Aug 2020 22:55:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com
Subject:  [folded-merged]
 rcu-kasan-record-and-print-call_rcu-call-stack-v8.patch removed from -mm
 tree
Message-ID: <20200807055534.Ti9Ksb4Lr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rcu-kasan-record-and-print-call_rcu-call-stack-v8
has been removed from the -mm tree.  Its filename was
     rcu-kasan-record-and-print-call_rcu-call-stack-v8.patch

This patch was dropped because it was folded into rcu-kasan-record-and-print-call_rcu-call-stack.patch

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: rcu-kasan-record-and-print-call_rcu-call-stack-v8

build fix

Link: http://lkml.kernel.org/r/20200710162401.23816-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/kasan/kasan.h~rcu-kasan-record-and-print-call_rcu-call-stack-v8
+++ a/mm/kasan/kasan.h
@@ -110,9 +110,8 @@ struct kasan_alloc_meta {
 	 * The free stack is stored into struct kasan_free_meta.
 	 */
 	depot_stack_handle_t aux_stack[2];
-#else
-	struct kasan_track free_track[KASAN_NR_FREE_STACKS];
 #endif
+	struct kasan_track free_track[KASAN_NR_FREE_STACKS];
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	u8 free_pointer_tag[KASAN_NR_FREE_STACKS];
 	u8 free_track_idx;
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

rcu-kasan-record-and-print-call_rcu-call-stack.patch
kasan-record-and-print-the-free-track.patch
kasan-record-and-print-the-free-track-v8.patch
kasan-add-tests-for-call_rcu-stack-recording.patch
kasan-update-documentation-for-generic-kasan.patch
kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch
kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch

