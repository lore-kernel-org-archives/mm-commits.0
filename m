Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FF5C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiCVVtw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbiCVVt2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA391FA45
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A708B6100A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A924C340EC;
        Tue, 22 Mar 2022 21:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985679;
        bh=qpcuFDUcYAmFeBf1F6hEHT80Ur3W5fKvcCX8Qm302zM=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=BUbJS6yP06zf9YHUEVoPSFkEQLtGdmC8ahyLEzvis2338Im/SN59G+vm1x+kx4/9a
         Sw4XXHyIHJXNAZgFtvyYb9QzSW1Dt5tepVWyHWx7wSPW2cLyj0Qh3x0uiPkI5M6Njz
         1GfcwJjmlZKET5gXj/U36CVftmUtHp8rkBDmW31g=
Date:   Tue, 22 Mar 2022 14:47:58 -0700
To:     ira.weiny@intel.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 186/227] highmem: document kunmap_local()
Message-Id: <20220322214759.0A924C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
