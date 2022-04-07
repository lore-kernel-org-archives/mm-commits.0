Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35616C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 22:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiDGWmu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 18:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiDGWmq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 18:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F463EF31
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 15:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20B4160AEA
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 22:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676FAC385A0;
        Thu,  7 Apr 2022 22:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649371243;
        bh=Y+REsdVlL8oDKqwCWUy0e7ajrAyJf6vy2k+bD66wTQ8=;
        h=Date:To:From:Subject:From;
        b=FMIkBZJdgsXLBuqPwEGOCmuWU2VvnEkbFAekil3YwwnDLep8KxdB1M8ooe/P5VjoJ
         J0EoeR9ZvlEdG4TI+YfMg3Fws0I1F/sx8ibIWPWewPoiQShoM5Vx8+7VJYxFu4sOOD
         ArkESSJJaE5wiT6/B96PbxJWY+Ah57RNBGOld3O4=
Date:   Thu, 07 Apr 2022 15:40:42 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        skhan@linuxfoundation.org, guozhengkui@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-selftests-use-swap-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220407224043.676FAC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: use swap() instead of open coding it
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-use-swap-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-use-swap-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-use-swap-instead-of-open-coding-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

userfaultfd-selftests-use-swap-instead-of-open-coding-it.patch

