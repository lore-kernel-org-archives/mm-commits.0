Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD45BC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD4021D7A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632923;
	bh=8/PBWQgz3SSTYl6EQciCTEV/iX++FB+zToIPRNXfJj4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DSoRD9VBQmHDsyYq3d+HOIQ9QFvtG1gz/ICwTW6hegEZx4HHpXrE0a6CwXsiD3PU6
	 GcoiE/fxy8N7LqC7jJtBkxKOpqVS4PkUI7E8yOiK0XgVAyvoI45wghq1FUzaJPvlYM
	 HQEltSW8+obMwdx3plYTvHIH5XvQMHsAgw7sYKRw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgJMXsn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgJMXsn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD10F21582;
        Tue, 13 Oct 2020 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632921;
        bh=8/PBWQgz3SSTYl6EQciCTEV/iX++FB+zToIPRNXfJj4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ScSdMgNvvSGYQINmsduZUSwXq2LiCM1DxiVUR+1Sbkrvjm+DRQ1GK3QTC6peL+I/9
         5O+tfOTkJ2Pl6SErZtwU6a3c1IVjS3Qi/hkJGiEUVYFvpvdaxJ9lAO6CYC/VeukqGa
         URai/M8vAvnSs52zcfsvLorQMTB56tvO0aqoD8Xo=
Date:   Tue, 13 Oct 2020 16:48:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, hewenliang4@huawei.com,
        hushiyuan@huawei.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        wuyun.wu@huawei.com
Subject:  [patch 021/181] mm/slub.c: branch optimization in free
 slowpath
Message-ID: <20201013234840.43ZfRzqi3%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Abel Wu <wuyun.wu@huawei.com>
Subject: mm/slub.c: branch optimization in free slowpath

The two conditions are mutually exclusive and gcc compiler will optimise
this into if-else-like pattern.  Given that the majority of free_slowpath
is free_frozen, let's provide some hint to the compilers.

Tests (perf bench sched messaging -g 20 -l 400000, executed 10x
after reboot) are done and the summarized result:

	un-patched	patched
max.	192.316		189.851
min.	187.267		186.252
avg.	189.154		188.086
stdev.	1.37		0.99

Link: http://lkml.kernel.org/r/20200813101812.1617-1-wuyun.wu@huawei.com
Signed-off-by: Abel Wu <wuyun.wu@huawei.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hewenliang <hewenliang4@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/slub.c~mm-slub-branch-optimization-in-free-slowpath
+++ a/mm/slub.c
@@ -3019,20 +3019,21 @@ static void __slab_free(struct kmem_cach
 
 	if (likely(!n)) {
 
-		/*
-		 * If we just froze the page then put it onto the
-		 * per cpu partial list.
-		 */
-		if (new.frozen && !was_frozen) {
+		if (likely(was_frozen)) {
+			/*
+			 * The list lock was not taken therefore no list
+			 * activity can be necessary.
+			 */
+			stat(s, FREE_FROZEN);
+		} else if (new.frozen) {
+			/*
+			 * If we just froze the page then put it onto the
+			 * per cpu partial list.
+			 */
 			put_cpu_partial(s, page, 1);
 			stat(s, CPU_PARTIAL_FREE);
 		}
-		/*
-		 * The list lock was not taken therefore no list
-		 * activity can be necessary.
-		 */
-		if (was_frozen)
-			stat(s, FREE_FROZEN);
+
 		return;
 	}
 
_
