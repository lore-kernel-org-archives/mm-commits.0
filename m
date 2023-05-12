Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AC8C77B75
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbjELXJf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238617AbjELXJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:09:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317B86A6E
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 16:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B38C563B93
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 23:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ADBC433D2;
        Fri, 12 May 2023 23:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683932972;
        bh=I8RcpixuIdYs2Pc9aSt9SJdWy71x3Vo1GZJKpUxZa9c=;
        h=Date:To:From:Subject:From;
        b=n7e9XithNlp354FQCk3ID3+B3Y04Zf0ounKbW5io6wgf+i2CaMDIpHbPWMiGFmzwV
         2sOe9mMyxglXgfNLP9wXTrUrW7KhNlZ7M3WeA7Psv342OC4H7evyvPesP5rd7Nf+av
         zdvHdKjeIrx8jBaRhd1dnx2F6Q8gRkRGd12NMMCs=
Date:   Fri, 12 May 2023 16:09:31 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20230512230932.16ADBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes
Date: Fri May 12 03:59:53 PM PDT 2023

ERROR: Macros with complex values should be enclosed in parentheses
#58: FILE: include/linux/maple_tree.h:544:
+#define mas_contiguous(__mas, __entry, __max) \
+	while (((__entry) = mas_find_range((__mas), (__max))) != NULL)

WARNING: suspect code indent for conditional statements (8, 12)
#285: FILE: lib/maple_tree.c:6136:
+	if (mas_find_setup(mas, max, &entry))
+	    return entry;

WARNING: Statements should start on a tabstop
#286: FILE: lib/maple_tree.c:6137:
+	    return entry;

total: 1 errors, 2 warnings, 284 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes
+++ a/lib/maple_tree.c
@@ -6134,7 +6134,7 @@ void *mas_find(struct ma_state *mas, uns
 	void *entry = NULL;
 
 	if (mas_find_setup(mas, max, &entry))
-	    return entry;
+		return entry;
 
 	/* Retries on dead nodes handled by mas_next_slot */
 	return mas_next_slot(mas, max, false);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch

