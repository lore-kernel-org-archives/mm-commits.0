Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA6CC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC06220657
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529498;
	bh=y2VUVNDwoGqhNXGbRUEQDJ4Owe3cIdg/dozECnXd5bo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dy8JSM9P4Qf+jZEi6t1LTQ3Gg3mvEodStzSw93QuP5kfkp7AxqRi3oWUD7ZhaowQg
	 KEvbQ0yLEbNSkqlYMjqCjShtnU3p+JiXiMZMgC+9PLJbvZRFXuuZwJof0ncOaypDNX
	 KQiw2HuBBJrJajqDsQkroGi6R4lYIqP/VJ3+yh7U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgHOWLh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729453AbgHOWKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4122E22B49;
        Sat, 15 Aug 2020 00:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451427;
        bh=y2VUVNDwoGqhNXGbRUEQDJ4Owe3cIdg/dozECnXd5bo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gEAUPszXOqNcs88E9Al/A0z+LmXID8cya2IaWgwkRYhDVrt4R89q0PnBWPYZ69Pb7
         ucYdiImRm6AelkjMkgSxTNHyES2iaA8qQ06l/t+uNBJ9SNunlvIKGoqvFC3HZVvVqC
         5Y7nc/z5T6EY2mPxdPqIc6l5O7Rmrn9vM7LSHx0A=
Date:   Fri, 14 Aug 2020 17:30:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 08/39] mm: move page-flags include to top of file
Message-ID: <20200815003026.gyKsFWpIm%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move page-flags include to top of file

Give up on the notion that we can remove page-flags.h from mm.h.  There
are currently 14 inline functions which use a PageFoo function.  Also, two
of the files directly included by mm.h include page-flags.h themselves,
and there are probably more indirect inclusions.  So just include it at
the top like any other header file.

Link: http://lkml.kernel.org/r/20200629151959.15779-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-move-page-flags-include-to-top-of-file
+++ a/include/linux/mm.h
@@ -24,6 +24,7 @@
 #include <linux/resource.h>
 #include <linux/page_ext.h>
 #include <linux/err.h>
+#include <linux/page-flags.h>
 #include <linux/page_ref.h>
 #include <linux/memremap.h>
 #include <linux/overflow.h>
@@ -668,11 +669,6 @@ int vma_is_stack_for_current(struct vm_a
 struct mmu_gather;
 struct inode;
 
-/*
- * FIXME: take this include out, include page-flags.h in
- * files which need it (119 of them)
- */
-#include <linux/page-flags.h>
 #include <linux/huge_mm.h>
 
 /*
_
