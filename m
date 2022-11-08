Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972BEC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 21:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKHVru (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 16:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKHVru (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 16:47:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F552019F
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 13:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB487B81C1C
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 21:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E69C433C1;
        Tue,  8 Nov 2022 21:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667944066;
        bh=Vb0RmOkLJVN7uVRq6IqHJgSDNFVOnqk80GxeWbG4v+Q=;
        h=Date:To:From:Subject:From;
        b=u+Q0qJQ4ycFk+ErJTrpYSHbp3rI9/4zmUrAPR6iRKDUBea/Tiqnivu8eumgMtNX0P
         Xp+yyHHuy+ieolw4tT2EPd/mchME+7E8a2eZTIZX5jEu+y+ZZIaDkr745H0hE5kI0x
         /hqM0vQPjNFsYMz1H9068qGZODr3gORS362VSIK8=
Date:   Tue, 08 Nov 2022 13:47:45 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-compiler-warning-with-make-w=1.patch added to mm-hotfixes-unstable branch
Message-Id: <20221108214746.44E69C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_exit: fix kernel doc warning in page_ext_put()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-compiler-warning-with-make-w=1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-compiler-warning-with-make-w=1.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-fix-compiler-warning-with-make-w=1.patch

