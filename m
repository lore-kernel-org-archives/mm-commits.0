Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFC5C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A9B20772
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594416650;
	bh=hwk0y2iv5/F7ki4hEGcHwgok9t3JIONxgEtjhTKEwB8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=r+ilxXxorUiO2n7/gojMzEXsn16DLYdpjyNGt5B+T4Z7Y0L0lPJKrA0Za4POdLRzk
	 9Wz1POAPLr2w6Syo6aaBwKVIffULjdf9sbWDq9zf8EVlMn2PyZIyX7V6jd8/5vG4SK
	 Piq2a0z7+RWXnLxKSF5cg2D43xdYPTHLpsgITQRY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgGJVat (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGJVat (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:30:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21DA2068F;
        Fri, 10 Jul 2020 21:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594416648;
        bh=hwk0y2iv5/F7ki4hEGcHwgok9t3JIONxgEtjhTKEwB8=;
        h=Date:From:To:Subject:From;
        b=BbBy6RULtCc/seOCVs/tMxAdxtOFUG0rqcFXP8ndaREOi+pIHcx1HQ+gHPagDNMHi
         sMSMtNhdSB4VZ7/3cHMI/XPF+43hy+0sPpLu66YRb0rOh9ewAaAAne7+9BVp8y+TC7
         7OwI59A/JeEwedBNve/puoG0AMilkYBlPNmt4C0o=
Date:   Fri, 10 Jul 2020 14:30:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com
Subject:  + rcu-kasan-record-and-print-call_rcu-call-stack-v8.patch
 added to -mm tree
Message-ID: <20200710213048.0jmd_t5zE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rcu-kasan-record-and-print-call_rcu-call-stack-v8
has been added to the -mm tree.  Its filename is
     rcu-kasan-record-and-print-call_rcu-call-stack-v8.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rcu-kasan-record-and-print-call_rcu-call-stack-v8.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rcu-kasan-record-and-print-call_rcu-call-stack-v8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rcu-kasan-record-and-print-call_rcu-call-stack-v8.patch
kasan-record-and-print-the-free-track.patch
kasan-record-and-print-the-free-track-v8.patch
kasan-add-tests-for-call_rcu-stack-recording.patch
kasan-update-documentation-for-generic-kasan.patch
kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch
kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch

