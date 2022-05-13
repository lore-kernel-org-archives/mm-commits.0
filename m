Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B2B8C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383797AbiEMTVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383850AbiEMTVQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECA42DD1
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447DA62259
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97181C34100;
        Fri, 13 May 2022 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469674;
        bh=mlBtUcjc47+biGPZvoFjBAUfnkeJfv9Emm/OhLDVSU4=;
        h=Date:To:From:Subject:From;
        b=l2YzoePMEd/V36MPqyLIG96HavUqyJFbBAvYiv8CbeoytOSMYwAUeOoxsk4Kk00I1
         xOZlqpwdnBwJpYnFzE3vbQzyuimzwFs/1q6NIZi4gMfsNeRuN1anN2zs8f1HCE25nf
         gaxQUs1Ptl6zTFkNWUaiMD3ewHLUicEWfONDviyo=
Date:   Fri, 13 May 2022 12:21:14 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        skhan@linuxfoundation.org, guozhengkui@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-selftests-use-swap-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220513192114.97181C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd/selftests: use swap() instead of open coding it
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-use-swap-instead-of-open-coding-it.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guo Zhengkui <guozhengkui@vivo.com>
Subject: userfaultfd/selftests: use swap() instead of open coding it

Address the following coccicheck warning:

tools/testing/selftests/vm/userfaultfd.c:1536:21-22: WARNING opportunity
for swap().
tools/testing/selftests/vm/userfaultfd.c:1540:33-34: WARNING opportunity
for swap().

by using swap() for the swapping of variable values and drop
`tmp_area` that is not needed any more.

`swap()` macro in userfaultfd.c is introduced in commit 681696862bc18
("selftests: vm: remove dependecy from internal kernel macros")

It has been tested with gcc (Debian 8.3.0-6) 8.3.0.

Link: https://lkml.kernel.org/r/20220407123141.4998-1-guozhengkui@vivo.com
Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-use-swap-instead-of-open-coding-it
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1422,7 +1422,6 @@ static void userfaultfd_pagemap_test(uns
 static int userfaultfd_stress(void)
 {
 	void *area;
-	char *tmp_area;
 	unsigned long nr;
 	struct uffdio_register uffdio_register;
 	struct uffd_stats uffd_stats[nr_cpus];
@@ -1533,13 +1532,9 @@ static int userfaultfd_stress(void)
 					    count_verify[nr], nr);
 
 		/* prepare next bounce */
-		tmp_area = area_src;
-		area_src = area_dst;
-		area_dst = tmp_area;
-
-		tmp_area = area_src_alias;
-		area_src_alias = area_dst_alias;
-		area_dst_alias = tmp_area;
+		swap(area_src, area_dst);
+
+		swap(area_src_alias, area_dst_alias);
 
 		uffd_stats_report(uffd_stats, nr_cpus);
 	}
_

Patches currently in -mm which might be from guozhengkui@vivo.com are


