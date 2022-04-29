Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D2EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 19:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiD2TmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 15:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239370AbiD2TmV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 15:42:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF7CCE114
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 12:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7DF1B837BB
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 19:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A39C385A7;
        Fri, 29 Apr 2022 19:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651261139;
        bh=ctQQhMLV3+qCYJT6Uoi1zY1SgASFfADRT+4WLp8LGqo=;
        h=Date:To:From:Subject:From;
        b=T5s/hjfFmxYz/8rg0DIA/fad6iMN8Rikbg4xHFmT6ThovuiiYlUsJvFhTnSMlFl2s
         fp1oSitTZvkYZh4ggZoa1UqT1M19xfrQqytztM2OB42oIaKMS2EiZuEuhkm78iqo3c
         +tGaQE3Uis145gnJAasQQztQpz7eHogwSUY3Ztzc=
Date:   Fri, 29 Apr 2022 12:38:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, dietschc@csp.edu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] add-missing-parameter-descriptions-in-folio.patch removed from -mm tree
Message-Id: <20220429193859.70A39C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/mm_types.h: add missing parameter descriptions in folio
has been removed from the -mm tree.  Its filename was
     add-missing-parameter-descriptions-in-folio.patch

This patch was dropped because it is obsolete

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


