Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453E5C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2084D2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781187;
	bh=t93+l4YlV+uP0W6/wlwhRLXpXRg9wB62OX2UFHk/pog=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xUw9vJM2P75QAUqwWcI30roCr6g8j2bfUsTfIsvm12SiBl96fL7Kg22r128VrnF5l
	 gTAcclj44uFbm06KFmqNoAO1RqA9Cf6P892u+tNde8tC9SIqhWp/H1Bkois2Xk6+X7
	 1m15UkFNioqG0TXMXLryX0ZSmNS5jNtQH4sNck5Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGGTq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0166221E5;
        Fri,  7 Aug 2020 06:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781186;
        bh=t93+l4YlV+uP0W6/wlwhRLXpXRg9wB62OX2UFHk/pog=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R5qu9uOwka0Z/XaxmbPb+6V2RutsVCkgDJPSNdcVhnZa3H+nx5DJwhhnqztL/KJcN
         y4xYXHJEzYZKmnm3SCkuYgSvbK4Wvhn9CZdF47uWxXPoyApvAAWJDCdh91mCNI01zp
         EGhkKw0Er6QfbqydVQIr4JEOkXdLdKGCUo/q/doE=
Date:   Thu, 06 Aug 2020 23:19:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        kirill@shutemov.name, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 048/163] mm/debug: print the inode number in
 dump_page
Message-ID: <20200807061945.pbfgaDBnc%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: print the inode number in dump_page

The inode number helps correlate this page with debug messages elsewhere
in the kernel.

Link: http://lkml.kernel.org/r/20200709202117.7216-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/debug.c~mm-print-the-inode-number-in-dump_page
+++ a/mm/debug.c
@@ -143,7 +143,7 @@ void __dump_page(struct page *page, cons
 		}
 
 		if (!dentry_first) {
-			pr_warn("aops:%ps\n", a_ops);
+			pr_warn("aops:%ps ino:%lx\n", a_ops, host->i_ino);
 			goto out_mapping;
 		}
 
@@ -157,8 +157,8 @@ void __dump_page(struct page *page, cons
 			 * crash, but it's unlikely that we reach here with a
 			 * corrupted struct page
 			 */
-			pr_warn("aops:%ps dentry name:\"%pd\"\n", a_ops,
-					&dentry);
+			pr_warn("aops:%ps ino:%lx dentry name:\"%pd\"\n",
+					a_ops, host->i_ino, &dentry);
 		}
 	}
 out_mapping:
_
