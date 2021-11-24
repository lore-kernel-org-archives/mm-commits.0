Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356C6C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344500AbhKXW2x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344457AbhKXW2x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF1E060E08;
        Wed, 24 Nov 2021 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637792742;
        bh=f2pzm7J0RJhzj78hzhkRZz0uGWHeBX/95OSOu7/QGaM=;
        h=Date:From:To:Subject:From;
        b=WBwaeGXdPIqKCPom3O/fCwgW3T08DtUb8oAG01/mykPZ/xZVJ0GJdq9o4WwLxKXp7
         WxBcD9GjcJixSZ0mA5K8M7CYbJEfCLjU8c7SRClVZ6h1mMISDbMeViENRXOJvfG91M
         FGgA5URGjX8kA6/CB6kZ4ZR8QsQQhpLUzJGLFQow=
Date:   Wed, 24 Nov 2021 14:25:42 -0800
From:   akpm@linux-foundation.org
To:     chi.minghao@zte.com.cn, mm-commits@vger.kernel.org,
        zealci@zte.com.cn
Subject:  + selftests-vm-use-swap-to-make-code-cleaner.patch added
 to -mm tree
Message-ID: <20211124222542.HV5u1KbiU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner
has been added to the -mm tree.  Its filename is
     selftests-vm-use-swap-to-make-code-cleaner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-use-swap-to-make-code-cleaner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-use-swap-to-make-code-cleaner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chiminghao <chi.minghao@zte.com.cn>
Subject: tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner

Fix the following coccicheck REVIEW:
./tools/testing/selftests/vm/userfaultfd.c:1531:21-22:use swap() to make
code cleaner

Link: https://lkml.kernel.org/r/20211124031632.35317-1-chi.minghao@zte.com.cn
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-vm-use-swap-to-make-code-cleaner
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1413,7 +1413,6 @@ static void userfaultfd_pagemap_test(uns
 static int userfaultfd_stress(void)
 {
 	void *area;
-	char *tmp_area;
 	unsigned long nr;
 	struct uffdio_register uffdio_register;
 	struct uffd_stats uffd_stats[nr_cpus];
@@ -1524,13 +1523,9 @@ static int userfaultfd_stress(void)
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

Patches currently in -mm which might be from chi.minghao@zte.com.cn are

selftests-vm-use-swap-to-make-code-cleaner.patch

