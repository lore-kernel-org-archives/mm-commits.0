Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C894C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A68E61481
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhD3F6s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhD3F6r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB65E613A9;
        Fri, 30 Apr 2021 05:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762279;
        bh=+63pArmfZ59pqjsG2FlN+9HwVjY/3PGwaV7iaIXi+II=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sl5HiMZmib0knTSqf6Xgbv0dJNoHugHvbo2pc9wy2wJiSHpmGIzyS4RpM715AekEq
         RsmH0TqSGG7GbFRrSyfJYwefsqG1iLwC6IrXf725JtwfIB2abgp7YoMNCzoud3WpNR
         8nLESFAzDb06TlxBQWQl61mbWvJi6p9BB/RX9PIs=
Date:   Thu, 29 Apr 2021 22:57:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@oracle.com, torvalds@linux-foundation.org,
        wangwensheng4@huawei.com
Subject:  [patch 093/178] mm/sparse: add the missing
 sparse_buffer_fini() in error branch
Message-ID: <20210430055758.W65xOAela%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wang Wensheng <wangwensheng4@huawei.com>
Subject: mm/sparse: add the missing sparse_buffer_fini() in error branch

sparse_buffer_init() and sparse_buffer_fini() should appear in pair, or a
WARN issue would be through the next time sparse_buffer_init() runs.

Add the missing sparse_buffer_fini() in error branch.

Link: https://lkml.kernel.org/r/20210325113155.118574-1-wangwensheng4@huawei.com
Fixes: 85c77f791390 ("mm/sparse: add new sparse_init_nid() and sparse_init()")
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/sparse.c~mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch
+++ a/mm/sparse.c
@@ -547,6 +547,7 @@ static void __init sparse_init_nid(int n
 			pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
 			       __func__, nid);
 			pnum_begin = pnum;
+			sparse_buffer_fini();
 			goto failed;
 		}
 		check_usemap_section_nr(nid, usage);
_
