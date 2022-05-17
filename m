Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF086C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 17:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351500AbiEQRgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 13:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351503AbiEQRgi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 13:36:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1E938194
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 10:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58E6F61459
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 17:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A264C34116;
        Tue, 17 May 2022 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652808996;
        bh=MZaijDENrpfAiuKHC/rMPE43daZBAZ7/RX3tuGF3vyc=;
        h=Date:To:From:Subject:From;
        b=cFdIfHZAK9PFnCHo7xUBY6kd+QqksTNQWjzJYwmdLXy44954zuFRH4IPRP0/LIxlR
         pFdX/1vLblr9fxjUaCgbvMBjAtknMBWWEzMilINCvQQPFe04xt7177SKuVNtSOTctJ
         zvV/bgvsGU4WXmij8xHXUvVgsER1qdrKPuN8ICfQ=
Date:   Tue, 17 May 2022 10:36:35 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com,
        linux@roeck-us.net, Liam.Howlett@oracle.com, hca@linux.ibm.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-2.patch added to mm-unstable branch
Message-Id: <20220517173636.9A264C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_next() when already on the last node entry
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_next() when already on the last node entry
Date: Tue, 17 May 2022 14:59:22 +0000

It is possible to return the metadata as the next entry if the last node
entry is already in the maple state and the limit is not reached.  Check
for this condition in mas_next_nentry() where the node end is returned.

Link: https://lkml.kernel.org/r/20220517145913.3480729-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-2
+++ a/lib/maple_tree.c
@@ -4547,6 +4547,9 @@ static inline void *mas_next_nentry(stru
 		return NULL;
 
 	count = ma_data_end(node, type, pivots, mas->max);
+	if (mas->offset > count)
+		return NULL;
+
 	while (mas->offset < count) {
 		pivot = pivots[mas->offset];
 		entry = mas_slot(mas, slots, mas->offset);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-remove-the-vma-linked-list-fix.patch

