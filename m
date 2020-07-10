Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9335EC433E4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 23:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6533C2065F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 23:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594423976;
	bh=1FKW76ZyW89DtXaxbkTaGYHHAkFdcCJ2bC4X1vTJjdg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mJg83JmswpsoNvHwo56FVe+Op09mQPFjOz6n3mrH+fykXHj9ENyifA/GsZcl0+Y6V
	 Ah9ywHEBYxCX8Ym0qLRBfwXl4UEhWs5gePMTX98ynbTqME15GfbvZmNp2bWIAmfJZR
	 iPA1qa65lEZNXURn9AQiEc4nROKgxLrQrebNrFU4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgGJXc4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 19:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgGJXc4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 19:32:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C3C220786;
        Fri, 10 Jul 2020 23:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594423975;
        bh=1FKW76ZyW89DtXaxbkTaGYHHAkFdcCJ2bC4X1vTJjdg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OaxyrJOK72k0jyWx2EmjxHTD3SHeANPTueCW0qJsiLJm95YXsCfrjuQ1V9EI19QRK
         2QUPvHpJhqnQyFNwkU1Qn8pJRcBo9vAlZFIGwqNx/r/Dfonk6l56ytfylbJnkLD1LD
         zqa1XIdlF1v1fqmnA3IgzYl+55NPyIOC//cqKbqA=
Date:   Fri, 10 Jul 2020 16:32:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  [to-be-updated]
 mm-vmallocc-add-an-error-message-if-two-areas-overlap.patch removed from
 -mm tree
Message-ID: <20200710233254.sehg7DwEX%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: add an error message if two areas overlap
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-add-an-error-message-if-two-areas-overlap.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc.c: add an error message if two areas overlap

Before triggering a BUG() it would be useful to understand how two areas
overlap between each other.  Print information about start/end addresses
of both VAs and their addresses.

For example if both are identical it could mean double free.

Link: http://lkml.kernel.org/r/20200710194443.2984-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-add-an-error-message-if-two-areas-overlap
+++ a/mm/vmalloc.c
@@ -550,8 +550,13 @@ find_va_links(struct vmap_area *va,
 		else if (va->va_end > tmp_va->va_start &&
 				va->va_start >= tmp_va->va_end)
 			link = &(*link)->rb_right;
-		else
+		else {
+			pr_err("Overlaps: 0x%px(0x%lx-0x%lx), 0x%px(0x%lx-0x%lx)\n",
+				va, va->va_start, va->va_end, tmp_va,
+				tmp_va->va_start, tmp_va->va_end);
+
 			BUG();
+		}
 	} while (*link);
 
 	*parent = &tmp_va->rb_node;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch
mm-vmalloc-simplify-augment_tree_propagate_check-func.patch
mm-vmalloc-switch-to-propagate-callback.patch
mm-vmalloc-update-the-header-about-kva-rework.patch

