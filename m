Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D48C32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjARV5x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjARV5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:57:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8213FF20
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BECD5B81D79
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C794C433D2;
        Wed, 18 Jan 2023 21:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674079069;
        bh=d6LZmSEfSF4MsH4RutUkC39Ao0LKi3Mo6ks2YM7HLSI=;
        h=Date:To:From:Subject:From;
        b=ua4h6B+Ypq3N8RmXWaWLLiN5Y8MvrO9GrQYVdyHfLOuHpOL7ehu9NY8/vouPSWvRU
         iHIWfErxgHPjulwSP/kgYmwcmTmfzJGR6rISlOS8E45mUjhtk1uit384VXPuMvn7Pi
         DwX5q+kHlxQUCYgp8YRjRXRxcA/pE+aaauGaQRBM=
Date:   Wed, 18 Jan 2023 13:57:48 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, ira.weiny@intel.com,
        fmdefrancesco@gmail.com, corbet@lwn.net, bigeasy@linutronix.de,
        wangdeming@inspur.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-use-s-higmem-highmem-fix-typo-for-highmem.patch added to mm-unstable branch
Message-Id: <20230118215749.4C794C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: mm: use `s/higmem/highmem/` fix typo for highmem
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-use-s-higmem-highmem-fix-typo-for-highmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-use-s-higmem-highmem-fix-typo-for-highmem.patch

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
From: Deming Wang <wangdeming@inspur.com>
Subject: Documentation: mm: use `s/higmem/highmem/` fix typo for highmem
Date: Tue, 17 Jan 2023 21:54:03 -0500

We should use highmem replace higmem.

Link: https://lkml.kernel.org/r/20230118025403.1531-1-wangdeming@inspur.com
Signed-off-by: Deming Wang <wangdeming@inspur.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/highmem.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/highmem.rst~documentation-mm-use-s-higmem-highmem-fix-typo-for-highmem
+++ a/Documentation/mm/highmem.rst
@@ -83,7 +83,7 @@ list shows them in order of preference o
   for pages which are known to not come from ZONE_HIGHMEM. However, it is
   always safe to use kmap_local_page() / kunmap_local().
 
-  While it is significantly faster than kmap(), for the higmem case it
+  While it is significantly faster than kmap(), for the highmem case it
   comes with restrictions about the pointers validity. Contrary to kmap()
   mappings, the local mappings are only valid in the context of the caller
   and cannot be handed to other contexts. This implies that users must
_

Patches currently in -mm which might be from wangdeming@inspur.com are

documentation-mm-use-s-higmem-highmem-fix-typo-for-highmem.patch

