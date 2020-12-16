Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8983C2BBD4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9933522D04
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgLPEp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725952AbgLPEp5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:57 -0500
Date:   Tue, 15 Dec 2020 20:45:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093941;
        bh=k7/48i9kQjQNDTJLF3whWwBHMMwKEdElIn09d50m18g=;
        h=From:To:Subject:In-Reply-To:From;
        b=q8bLul/pnGCRqtUEzLYGeH5xvzBfRcaEdLG25+dqj+/DBfXph/3ni0IKG6bYU+IqA
         BxtmrzwOAaFBE0X0yRnGvKToTlA5Ll43QNXMI5LUIu4fwr1Evsxa2EnqwNn7QzXV+0
         L+CgOeHs1Vr+KdFbfOcO6cF/f4v2U01204xIxCUo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        oberpar@linux.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 62/95] gcov: fix kernel-doc markup issue
Message-ID: <20201216044540.yJjY61JPR%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: gcov: fix kernel-doc markup issue

Fix the following kernel-doc issue in gcov:
kernel/gcov/gcc_4_7.c:238: warning: Function parameter or member 'dst'
not described in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Function parameter or member 'src'
not described in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Excess function parameter 'dest'
description in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Excess function parameter 'source'
description in 'gcov_info_add'

Link: https://lkml.kernel.org/r/1605252352-63983-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/gcov/gcc_4_7.c~gcov-fix-kernel-doc-markup-issue
+++ a/kernel/gcov/gcc_4_7.c
@@ -227,10 +227,10 @@ int gcov_info_is_compatible(struct gcov_
 
 /**
  * gcov_info_add - add up profiling data
- * @dest: profiling data set to which data is added
- * @source: profiling data set which is added
+ * @dst: profiling data set to which data is added
+ * @src: profiling data set which is added
  *
- * Adds profiling counts of @source to @dest.
+ * Adds profiling counts of @src to @dst.
  */
 void gcov_info_add(struct gcov_info *dst, struct gcov_info *src)
 {
_
