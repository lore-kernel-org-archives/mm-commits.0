Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05C1C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C725361482
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3GAW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230119AbhD3GAW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9A6161481;
        Fri, 30 Apr 2021 05:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762374;
        bh=hsoa51XYDSwUtxsyJ3Vz6zcrxgEcEMab2XEwzVFQa+Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Oczvuav/F0QLCoh9IKxJNB7JDAIdteZ5BlRMbxn3U9NgWXSMCqTDbvRUoVf2zeJ6p
         5oCefMhY4e+5JJlNzvX99D/AyMNh0sAjQZ0BMnPHwEkNJhw98uKLLKemq5duP5ACfP
         5VAtbqaG/Qj774WgVasT9VeIv7A2VduZPqjU09R0=
Date:   Thu, 29 Apr 2021 22:59:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 124/178] mm/doc: add mm.h and mm_types.h to the
 mm-api document
Message-ID: <20210430055934.K7weqh4PW%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: add mm.h and mm_types.h to the mm-api document

kerneldoc in include/linux/mm.h and include/linux/mm_types.h wasn't being
included in the html build.

Link: https://lkml.kernel.org/r/20210322195022.2143603-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/core-api/mm-api.rst~mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document
+++ a/Documentation/core-api/mm-api.rst
@@ -92,3 +92,7 @@ More Memory Management Functions
    :export:
 
 .. kernel-doc:: mm/page_alloc.c
+.. kernel-doc:: include/linux/mm_types.h
+   :internal:
+.. kernel-doc:: include/linux/mm.h
+   :internal:
_
