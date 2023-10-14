Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61EDCDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjJNWkv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjJNWkv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:40:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB76DE;
        Sat, 14 Oct 2023 15:40:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E28C433C7;
        Sat, 14 Oct 2023 22:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697323248;
        bh=1jHEIhzl9SooOUTj6MODzbWFgglfOtNFXvhcAVU/XsM=;
        h=Date:To:From:Subject:From;
        b=e2GFnigZsNujvOp2FRBwluyQQUuRMZ1f/fsW30cwvZ8EUGeADAAaV+ya5y6ANksbx
         gUwg4XYKYxIGneMg+/jMz4B3fwO7S1BAxVoIRzvnrnW9SGUF6nSX3ssm4wVWd12I5E
         WegFbDz69rJdg/ERI4zzl5yRIXUNJvhmMqjN5sGE=
Date:   Sat, 14 Oct 2023 15:40:46 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        stable@vger.kernel.org, shuah@kernel.org, lkft@linaro.org,
        samasth.norway.ananda@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-include-mman-header-to-access-mremap_dontunmap-identifier.patch added to mm-hotfixes-unstable branch
Message-Id: <20231014224048.98E28C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: include mman header to access MREMAP_DONTUNMAP identifier
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-include-mman-header-to-access-mremap_dontunmap-identifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-include-mman-header-to-access-mremap_dontunmap-identifier.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Subject: selftests/mm: include mman header to access MREMAP_DONTUNMAP identifier
Date: Thu, 12 Oct 2023 08:52:57 -0700

Definition for MREMAP_DONTUNMAP is not present in glibc older than 2.32
thus throwing an undeclared error when running make on mm.  Including
linux/mman.h solves the build error for people having older glibc.

Link: https://lkml.kernel.org/r/20231012155257.891776-1-samasth.norway.ananda@oracle.com
Fixes: 0183d777c29a ("selftests: mm: remove duplicate unneeded defines")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/linux-mm/CA+G9fYvV-71XqpCr_jhdDfEtN701fBdG3q+=bafaZiGwUXy_aA@mail.gmail.com/
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_dontunmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/mremap_dontunmap.c~selftests-mm-include-mman-header-to-access-mremap_dontunmap-identifier
+++ a/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -7,6 +7,7 @@
  */
 #define _GNU_SOURCE
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
_

Patches currently in -mm which might be from samasth.norway.ananda@oracle.com are

selftests-mm-include-mman-header-to-access-mremap_dontunmap-identifier.patch

