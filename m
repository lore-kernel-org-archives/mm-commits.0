Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C93EB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 05:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjGDFjY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 01:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjGDFjR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 01:39:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79B3E52
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 22:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3408261122
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 05:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890F9C433C8;
        Tue,  4 Jul 2023 05:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688449155;
        bh=RtXKiKSsxVGC3enUpR7ryoAV/ZOfWBQUhtEuQyOqrEQ=;
        h=Date:To:From:Subject:From;
        b=rK6e3WNKLCJfwvul2lUwXE8WEcpbIClxtPRXjoSdbiyJJArE9Vu5PcaWgCtuvVkLR
         c/4fikZfVvxrE7Xi1+ETTlaiyAK5OUQ+UFKjUdj1Q+Cjx+NjftP/Eu/Dm+VDZkFlRt
         jYqV6ZeHwWLI2goXEmRzdH/qK2OBXn4U1CJt8elw=
Date:   Mon, 03 Jul 2023 22:39:14 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-convert-do_read_fault-to-use-folios.patch removed from -mm tree
Message-Id: <20230704053915.890F9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: convert do_read_fault() to use folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-do_read_fault-to-use-folios.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert do_read_fault() to use folios
Date: Sun, 2 Jul 2023 22:58:50 -0700

Saves one implicit call to compound_head()

Link: https://lkml.kernel.org/r/20230703055850.227169-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-convert-do_read_fault-to-use-folios
+++ a/mm/memory.c
@@ -4539,6 +4539,7 @@ static inline bool should_fault_around(s
 static vm_fault_t do_read_fault(struct vm_fault *vmf)
 {
 	vm_fault_t ret = 0;
+	struct folio *folio = page_folio(vmf->page);
 
 	/*
 	 * Let's call ->map_pages() first and use ->fault() as fallback
@@ -4556,9 +4557,9 @@ static vm_fault_t do_read_fault(struct v
 		return ret;
 
 	ret |= finish_fault(vmf);
-	unlock_page(vmf->page);
+	folio_unlock(folio);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
-		put_page(vmf->page);
+		folio_put(folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-increase-usage-of-folio_next_index-helper.patch

