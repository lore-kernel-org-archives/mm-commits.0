Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EFAC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjASB14 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjASB1d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:27:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8B37178B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:21:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 353C061138
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEC8C433D2;
        Thu, 19 Jan 2023 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091281;
        bh=xHHkvgpW0Ur5eAL+5yT/tkslDeeMYx7mq60G+pBnWnY=;
        h=Date:To:From:Subject:From;
        b=hMWaDgrwugBdUoHXymp3/5AtKJSk8gVNfZbYAShVlCsovN/MDJ+SG94ySuRtN+I2G
         mc4SeGgI1LvpuLKa1x58Ebd8hYmDYWS/4PVXl6Iy+PGRiLd15GLtHFMmDpzuPbGaK4
         UCvD8UlR/R840XmluB6v191ZFlyR/xyWm+hRIDW0=
Date:   Wed, 18 Jan 2023 17:21:20 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com, lkp@intel.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch removed from -mm tree
Message-Id: <20230119012121.8AEC8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: remove __USE_GNU in hugetlb-madvise.c
has been removed from the -mm tree.  Its filename was
     selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/vm: remove __USE_GNU in hugetlb-madvise.c
Date: Mon, 16 Jan 2023 11:33:07 -0500

__USE_GNU should be an internal macro only used inside glibc.  Either
memfd_create() or fallocate() requires _GNU_SOURCE per man page, where
__USE_GNU will further be defined by glibc headers include/features.h:

  #ifdef _GNU_SOURCE
  # define __USE_GNU	1
  #endif

This fixes:

   >> hugetlb-madvise.c:20: warning: "__USE_GNU" redefined
      20 | #define __USE_GNU
         |
   In file included from /usr/include/x86_64-linux-gnu/bits/libc-header-start.h:33,
                    from /usr/include/stdlib.h:26,
                    from hugetlb-madvise.c:16:
   /usr/include/features.h:407: note: this is the location of the previous definition
     407 | # define __USE_GNU      1
         |

Link: https://lkml.kernel.org/r/Y8V9z+z6Tk7NetI3@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugetlb-madvise.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/hugetlb-madvise.c~selftests-vm-remove-__use_gnu-in-hugetlb-madvisec
+++ a/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -17,7 +17,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
-#define __USE_GNU
 #include <fcntl.h>
 
 #define MIN_FREE_PAGES	20
_

Patches currently in -mm which might be from peterx@redhat.com are


