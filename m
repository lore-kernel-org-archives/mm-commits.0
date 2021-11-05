Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459FDC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30668611C4
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhKEUmP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233429AbhKEUmI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94C986056B;
        Fri,  5 Nov 2021 20:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144768;
        bh=195WpJFUXCAzHcNg6yr8SaCAS75bTx0VLBndn3JQVuA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DoU5EyvSPtmibve1UJHVhmbEKohWk+ViF20gplNgqiwKcRTm28YrSIH4hKzl6Ng/N
         798WwQD88VBANkrJccoGDZ11LkSLPFao6S/VnJMlozmsxzj+QTSrZfXci4b1mQ53G1
         tbTRWgAdyG6SFYU7aPglxzXcvJFhwOBUbXJhSI/g=
Date:   Fri, 05 Nov 2021 13:39:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com, linux-mm@kvack.org,
        lpf.vector@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 092/262] mm/vmalloc: make sure to dump unpurged
 areas in /proc/vmallocinfo
Message-ID: <20211105203928.VUhnNzshg%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
