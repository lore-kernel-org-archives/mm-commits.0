Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BDDC4167D
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbiKWCxO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbiKWCxJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A4FE3D0E
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3C49B81E56
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0008C433D7;
        Wed, 23 Nov 2022 02:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171986;
        bh=8ZqyXlOLsWywc7oHbRKquuzAp8GvuOrnqJ4av7tGhsM=;
        h=Date:To:From:Subject:From;
        b=r4+d2GIptJXdylKOv2W0azUZvaXTgd9LLV9P7uWORj8hmLV5Kyc0phe+YrPZIXobW
         H9um9/IYP0nMaYTwJRk9n7AhGGuodl+cEPEzGkx1YVzSSYEqsm/dZLEThRwOKP07Ll
         OWr14Otr9F9X/TrnHG8FvWtednr145YEgjktYDlk=
Date:   Tue, 22 Nov 2022 18:53:05 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-compiler-warning-with-make-w=1.patch removed from -mm tree
Message-Id: <20221123025306.A0008C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_exit: fix kernel doc warning in page_ext_put()
has been removed from the -mm tree.  Its filename was
     mm-fix-compiler-warning-with-make-w=1.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm/page_exit: fix kernel doc warning in page_ext_put()
Date: Tue, 8 Nov 2022 10:46:22 +0530

Fix the below compiler warnings reported with 'make W=1 mm/'. 
mm/page_ext.c:178: warning: Function parameter or member 'page_ext' not
described in 'page_ext_put'.

[quic_pkondeti@quicinc.com: better patch title]
Link: https://lkml.kernel.org/r/1667884582-2465-1-git-send-email-quic_charante@quicinc.com
Fixes: b1d5488a252dc9 ("mm: fix use-after free of page_ext after race with memory-offline")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Pavan Kondeti <quic_pkondeti@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_ext.c~mm-fix-compiler-warning-with-make-w=1
+++ a/mm/page_ext.c
@@ -166,7 +166,7 @@ struct page_ext *page_ext_get(struct pag
 
 /**
  * page_ext_put() - Working with page extended information is done.
- * @page_ext - Page extended information received from page_ext_get().
+ * @page_ext: Page extended information received from page_ext_get().
  *
  * The page extended information of the page may not be valid after this
  * function is called.
_

Patches currently in -mm which might be from quic_charante@quicinc.com are


