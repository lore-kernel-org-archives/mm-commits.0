Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F160BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345766AbiCYBgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357425AbiCYBfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830AC12FD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 971E8B8272A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C93CC340EC;
        Fri, 25 Mar 2022 01:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171977;
        bh=6BU38s+zX1iyc5pfYkkqvllBaMOSid1UhhLNtpH4xeY=;
        h=Date:To:From:Subject:From;
        b=e4dc0UwGckEDDZA5fCuwwPqUhvvcB6CExMAWSuR5FSHairiEWHRPeN1RLjOppWvJS
         Mp3//4lfbTh8QGX1WpdMB1kLVGmtXEJWmSRLBfiCoPOy0g1cg2m5SKI3FtNHY8jalC
         Rmz7WxAcAruyCVqtWAuhfBJyD39J2jdnE+Nfj9lw=
Date:   Thu, 24 Mar 2022 18:32:56 -0700
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] highmem-document-kunmap_local.patch removed from -mm tree
Message-Id: <20220325013257.2C93CC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: document kunmap_local()
has been removed from the -mm tree.  Its filename was
     highmem-document-kunmap_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: highmem: document kunmap_local()

Some users of kmap() add an offset to the kmap() address to be used
during the mapping.

When converting to kmap_local_page() the base address does not
need to be stored because any address within the page can be used in
kunmap_local().  However, this was not clear from the documentation and
cause some questions.[1]

Document that any address in the page can be used in kunmap_local() to
clarify this for future users.

[1] https://lore.kernel.org/lkml/20211213154543.GM3538886@iweiny-DESK2.sc.intel.com/

[ira.weiny@intel.com: updates per Christoph]
  Link: https://lkml.kernel.org/r/20220124182138.816693-1-ira.weiny@intel.com
Link: https://lkml.kernel.org/r/20220124013045.806718-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/highmem-internal.h~highmem-document-kunmap_local
+++ a/include/linux/highmem-internal.h
@@ -246,6 +246,16 @@ do {								\
 	__kunmap_atomic(__addr);				\
 } while (0)
 
+/**
+ * kunmap_local - Unmap a page mapped via kmap_local_page().
+ * @__addr: An address within the page mapped
+ *
+ * @__addr can be any address within the mapped page.  Commonly it is the
+ * address return from kmap_local_page(), but it can also include offsets.
+ *
+ * Unmapping should be done in the reverse order of the mapping.  See
+ * kmap_local_page() for details.
+ */
 #define kunmap_local(__addr)					\
 do {								\
 	BUILD_BUG_ON(__same_type((__addr), struct page *));	\
_

Patches currently in -mm which might be from ira.weiny@intel.com are


