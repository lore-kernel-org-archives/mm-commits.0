Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E4FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E67F61260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhKKCqJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234204AbhKKCqJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 945C460F46;
        Thu, 11 Nov 2021 02:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598600;
        bh=5hltyBoLOdDp+DP2K2KkMi33OxOvd0O7wPbadffWaUI=;
        h=Date:From:To:Subject:From;
        b=YFXaAwATyhIRQ5Ue269HMSxNV1/bo8+b2VlGZ2zZ70iGe9NyEtpwUwoWXWNXU71tU
         /uxEhxMTtkN8/LDJRwUGh0gY/Q1kE1dyHVtBweOTa3qGB+tJS4uK62CqmciESXIBwp
         IE31mVP/fdxIQFl4Kt4SF9ehFqM9nSXCo6M7dQq0=
Date:   Wed, 10 Nov 2021 18:43:20 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, lpf.vector@gmail.com,
        mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  [merged]
 mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo.patch
 removed from -mm tree
Message-ID: <20211111024320._2Yj3t5CX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: make sure to dump unpurged areas in /proc/vmallocinfo
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/vmalloc: make sure to dump unpurged areas in /proc/vmallocinfo

If last va found in vmap_area_list does not have a vm pointer,
vmallocinfo.s_show() returns 0, and show_purge_info() is not called as it
should.

Link: https://lkml.kernel.org/r/20211001170815.73321-1-eric.dumazet@gmail.com
Fixes: dd3b8353bae7 ("mm/vmalloc: do not keep unpurged areas in the busy tree")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Pengfei Li <lpf.vector@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo
+++ a/mm/vmalloc.c
@@ -3913,7 +3913,7 @@ static int s_show(struct seq_file *m, vo
 			(void *)va->va_start, (void *)va->va_end,
 			va->va_end - va->va_start);
 
-		return 0;
+		goto final;
 	}
 
 	v = va->vm;
@@ -3954,6 +3954,7 @@ static int s_show(struct seq_file *m, vo
 	/*
 	 * As a final step, dump "unpurged" areas.
 	 */
+final:
 	if (list_is_last(&va->list, &vmap_area_list))
 		show_purge_info(m);
 
_

Patches currently in -mm which might be from edumazet@google.com are


