Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12E7C5DF62
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 00:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiAZAe3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 19:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiAZAe2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 19:34:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3230AC06161C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 16:34:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDBE4B81B8A
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 00:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93431C340E0;
        Wed, 26 Jan 2022 00:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643157265;
        bh=ZiJf/L6XFcEsLfgjDQqxJ5G5qsc/Aw8Ei36enBRQrbc=;
        h=Date:From:To:Subject:From;
        b=2MaT+xNssz1/qfeUVtMqX9mQQVSIjezccO9bQ3RDptA9qNeZd00uFgJYnyUrigIlJ
         mp7JE110/zGuRq0H4V6rjlk7Db+SPAl7pUbavolCCChlk9+GhyP+sTvkHovv3PCAZv
         ASrvFtx8E1jpVl/zvaC9q/qfO6TqpzklJ3L1yFO8=
Date:   Tue, 25 Jan 2022 16:34:25 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-migration-add-trace-events-for-base-page-and-hugetlb-migr?=
 =?US-ASCII?Q?ations-fix.patch?= added to -mm tree
Message-ID: <20220126003425.ZTgDDdF0d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix
has been added to the -mm tree.  Its filename is
     mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix

fix build

Link: https://lkml.kernel.org/r/53c3d1bb-7085-4947-772c-a3cbf94f02c8@arm.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rmap.c~mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix
+++ a/mm/rmap.c
@@ -76,6 +76,7 @@
 
 #include <asm/tlbflush.h>
 
+#define CREATE_TRACE_POINTS
 #include <trace/events/tlb.h>
 #include <trace/events/migrate.h>
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix.patch

