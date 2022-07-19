Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA62FC43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 23:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiGSXUO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 19:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbiGSXUM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 19:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A593DA1A6
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 16:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4538761207
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 23:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980D3C341CA;
        Tue, 19 Jul 2022 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658272809;
        bh=x6pUxLfzQa2nsi1iVyfkRG9JzTBbbQCeMX9szdZRn7I=;
        h=Date:To:From:Subject:From;
        b=xZeEikJqyUFimRxGVHwMFrwAlMieu0EP2MF4cANjSSZy+iO9xvujqTEaZmxHWBIeS
         7IVbgR2S3obbhy6XiLTm1v2H9MbD6HbSDagkcjwaSIrQhCmLRRuFkEadtMyYkDhO3s
         ITun+4rDCpqQJjYRJ60AbgXRgwOnR3F0N2FhV2C4=
Date:   Tue, 19 Jul 2022 16:20:08 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shuah@kernel.org, mike.kravetz@oracle.com, almasrymina@google.com,
        dan.carpenter@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-uninitialized-variable-in-main.patch added to mm-unstable branch
Message-Id: <20220719232009.980D3C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: uninitialized variable in main()
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-vm-uninitialized-variable-in-main.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-vm-uninitialized-variable-in-main.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: selftest/vm: uninitialized variable in main()
Date: Tue, 19 Jul 2022 12:04:14 +0300

Initialize "length" to zero by default.

Link: https://lkml.kernel.org/r/YtZzjvHXVXMXxpXO@kili
Fixes: ff712a627f72 ("selftests/vm: cleanup hugetlb file after mremap test")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~selftest-vm-uninitialized-variable-in-main
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -107,7 +107,7 @@ static void register_region_with_uffd(ch
 
 int main(int argc, char *argv[])
 {
-	size_t length;
+	size_t length = 0;
 
 	if (argc != 2 && argc != 3) {
 		printf("Usage: %s [length_in_MB] <hugetlb_file>\n", argv[0]);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

selftests-vm-silence-uninitialized-variable-warning.patch
selftest-vm-uninitialized-variable-in-main.patch

