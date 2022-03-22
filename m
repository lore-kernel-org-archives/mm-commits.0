Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0823C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiCVTSR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiCVTSR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:18:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E308B87D
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29B6761661
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBE5C340EC;
        Tue, 22 Mar 2022 19:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976608;
        bh=jok8u2GG4MWufqRW7HepmU+uirVFcU8orsY8n98qa5c=;
        h=Date:To:From:Subject:From;
        b=jLeF9GnjMUlb25mL7z/E+nwS/w0CoLsXQLD144xAywegaixuziDmySX91XE+6oFL4
         Q2voYvRoeDo1ZDJpJYqD1vahhuNM2ncyH3F+IQmAig+N4anmOfBKL2T8wi1baDufrM
         e9m5+WkYj0KWRmwwCKW02d0tYlZ1+EbxXuYXG8vI=
Date:   Tue, 22 Mar 2022 12:16:47 -0700
To:     mm-commits@vger.kernel.org, hch@infradead.org, ira.weiny@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] highmem-document-kunmap_local-v2.patch removed from -mm tree
Message-Id: <20220322191648.7FBE5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem-document-kunmap_local-v2
has been removed from the -mm tree.  Its filename was
     highmem-document-kunmap_local-v2.patch

This patch was dropped because it was folded into highmem-document-kunmap_local.patch

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

