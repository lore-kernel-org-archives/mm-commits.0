Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA20C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D78062075D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594416149;
	bh=hrZFHGfMNQ1p2d6zDtqR8zci0wrVVqn/hAsbHQ9RnzQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Hm48pOO8UpGBGrtYlPnnkSXcTwh5S9ds7nYtFnvF+c4vrurHvjfkZNcEprvFK/lKn
	 g0JdLmtIEVJ/tltuQPW4skEij/d+Nsvw2p6cnZ0R9SSjSXMqj+iDomyMlTiKq0RuRS
	 2K6QQ0+y/SzugLsE/9YjtEY/S5ktFZHNc7Weu/Ac=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgGJVW3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgGJVW3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:22:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1ED320725;
        Fri, 10 Jul 2020 21:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594416148;
        bh=hrZFHGfMNQ1p2d6zDtqR8zci0wrVVqn/hAsbHQ9RnzQ=;
        h=Date:From:To:Subject:From;
        b=m7a1Jf5YMi0rDEmNIL0ygUkvrKH5Tu8RjbZ483/BpthorXyLVSVfQ8VfyaeVqGWJp
         rSHRDhkqjx8wUDCbbArMjZzG4yFQaCFIUPBhtKa9SVL7yC+lXPffMK6efc6fljovf6
         xiteTqJW7S/57/n7h8ktWXOdfgGDtDMvskLIy+xs=
Date:   Fri, 10 Jul 2020 14:22:28 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  +
 mm-vmallocc-add-an-error-message-if-two-areas-overlap.patch added to -mm
 tree
Message-ID: <20200710212228.ECH9vbOW_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: add an error message if two areas overlap
has been added to the -mm tree.  Its filename is
     mm-vmallocc-add-an-error-message-if-two-areas-overlap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-add-an-error-message-if-two-areas-overlap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-add-an-error-message-if-two-areas-overlap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-vmallocc-add-an-error-message-if-two-areas-overlap.patch

