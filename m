Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B37C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbjHKXA6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbjHKXAA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DFC3584
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C47065772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EB9C433C7;
        Fri, 11 Aug 2023 22:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794785;
        bh=PL1VzPGK7mE9iXE0qilBXMXNKOJNRFQ9Sm/KO8spjE8=;
        h=Date:To:From:Subject:From;
        b=ywrvDubhSivq19zg92wyjlIPj6MpdQ7oxfYZUIFfdOPQLAWHpBYduY0IkxaZkb1CM
         JZzJfbFl7Peiqqu96GHAs5bTbem0yzPtpRpwnfzRDJ8hTVDwBM4fxUNUx5UWsYSQBn
         W2KQjPZtRq3189tXDdR6vV0Gx0f9AGUSRMp05Sxg=
Date:   Fri, 11 Aug 2023 15:59:44 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-convert-do_read_fault-to-use-folios.patch removed from -mm tree
Message-Id: <20230811225945.62EB9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: convert do_read_fault() to use folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-do_read_fault-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert do_read_fault() to use folios
Date: Thu, 6 Jul 2023 09:38:47 -0700

Saves one implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230706163847.403202-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-convert-do_read_fault-to-use-folios
+++ a/mm/memory.c
@@ -4536,6 +4536,7 @@ static inline bool should_fault_around(s
 static vm_fault_t do_read_fault(struct vm_fault *vmf)
 {
 	vm_fault_t ret = 0;
+	struct folio *folio;
 
 	/*
 	 * Let's call ->map_pages() first and use ->fault() as fallback
@@ -4553,9 +4554,10 @@ static vm_fault_t do_read_fault(struct v
 		return ret;
 
 	ret |= finish_fault(vmf);
-	unlock_page(vmf->page);
+	folio = page_folio(vmf->page);
+	folio_unlock(folio);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
-		put_page(vmf->page);
+		folio_put(folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


