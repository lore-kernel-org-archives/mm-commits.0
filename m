Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13294C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 00:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359101AbiAYAeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:34:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59818 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843926AbiAXXHH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 18:07:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16B88B815EB
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 23:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A361AC340E4;
        Mon, 24 Jan 2022 23:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643065620;
        bh=xorlOiWm+e/QQ+UrNMvwLrtZy/mJMCaJ2Asf5bUG04Q=;
        h=Date:From:To:Subject:From;
        b=gCjpS895n1Pi9kgiJdX3ke/UHMoPw7ByZhvlHhSlXPxtG7r343rvOB4MMkxADbayi
         0571lHI2A2G0ggTSYjYp5n7O5THgblOPewxkjYtFt+RerQOm/yMzkZMVbFmcYGYskI
         vEvjROav6kZYifp61KvJ0sZyyPg69WgebzIL453Q=
Date:   Mon, 24 Jan 2022 15:07:00 -0800
From:   akpm@linux-foundation.org
To:     hch@infradead.org, ira.weiny@intel.com, mm-commits@vger.kernel.org
Subject:  + highmem-document-kunmap_local-v2.patch added to -mm
 tree
Message-ID: <20220124230700.lvfbNYcdF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem-document-kunmap_local-v2
has been added to the -mm tree.  Its filename is
     highmem-document-kunmap_local-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/highmem-document-kunmap_local-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/highmem-document-kunmap_local-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: highmem-document-kunmap_local-v2

updates per Christoph

Link: https://lkml.kernel.org/r/20220124182138.816693-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/highmem-internal.h~highmem-document-kunmap_local-v2
+++ a/include/linux/highmem-internal.h
@@ -250,9 +250,8 @@ do {								\
  * kunmap_local - Unmap a page mapped via kmap_local_page().
  * @__addr: An address within the page mapped
  *
- * __addr is often an address returned from kmap_local_page().  However,
- * this address can be any address within the mapped page.  It does not need to
- * be the exact address returned from kmap_local_page()
+ * @__addr can be any address within the mapped page.  Commonly it is the
+ * address return from kmap_local_page(), but it can also include offsets.
  *
  * Unmapping should be done in the reverse order of the mapping.  See
  * kmap_local_page() for details.
_

Patches currently in -mm which might be from ira.weiny@intel.com are

highmem-document-kunmap_local.patch
highmem-document-kunmap_local-v2.patch

