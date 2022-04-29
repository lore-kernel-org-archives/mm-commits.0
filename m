Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C940C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 19:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237546AbiD2TM4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 15:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237246AbiD2TM4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 15:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9AFBCB7E
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 12:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8358B83794
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 19:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6102FC385A7;
        Fri, 29 Apr 2022 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651259374;
        bh=Jj1ZDIp6NHsBFq6gPEBziNGiqEZTgXfaaGxj8hMSXfo=;
        h=Date:To:From:Subject:From;
        b=vkqqeEWxfYkDF0fKmX4yltgZv5ljTju794amS/3ODqFpJV7R3bAEmX9Ae1OcDoZdL
         CX5HxqV+o/sFYQqIp62D+rqEETFsnuwoP+M/6in1W0Z/T0hoYzJzFQzyv2SGn//cNW
         Uz+QWgoMh7x9uDF77kdFM2ygsEVf+efGl1JB4LVk=
Date:   Fri, 29 Apr 2022 12:09:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, dietschc@csp.edu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + add-missing-parameter-descriptions-in-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20220429190934.6102FC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm_types.h: add missing parameter descriptions in folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     add-missing-parameter-descriptions-in-folio.patch

This patch should soon appear in the mm-hotfixes-unstable branch at
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
From: Coleman Dietsch <dietschc@csp.edu>
Subject: include/linux/mm_types.h: add missing parameter descriptions in folio

This resolves a warning when running make htmldocs.

./include/linux/mm_types.h:275: warning: Function parameter or member '__filler' not described in 'folio'
./include/linux/mm_types.h:275: warning: Function parameter or member 'mlock_count' not described in 'folio'

Link: https://lkml.kernel.org/r/CABvydf+Y_ybtLSf2o_tCY-qxe-BOch299zCOC-Y+i_UovdY75A@mail.gmail.com
Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mm_types.h~add-missing-parameter-descriptions-in-folio
+++ a/include/linux/mm_types.h
@@ -227,6 +227,8 @@ struct page {
  * struct folio - Represents a contiguous set of bytes.
  * @flags: Identical to the page flags.
  * @lru: Least Recently Used list; tracks how recently this folio was used.
+ * @__filler: Always even, identical to page __filler.
+ * @mlock_count: Count folio's mlocks.
  * @mapping: The file this page belongs to, or refers to the anon_vma for
  *    anonymous memory.
  * @index: Offset within the file, in units of pages.  For anonymous memory,
_

Patches currently in -mm which might be from dietschc@csp.edu are

add-missing-parameter-descriptions-in-folio.patch

