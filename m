Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D99C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 01:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiCGCAW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 21:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiCGCAW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 21:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5562339160
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 17:59:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D785961143
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 01:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35737C340EC;
        Mon,  7 Mar 2022 01:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646618368;
        bh=nuoy8hY4T5b123NlgyWHalzArni/clx3/4OenQYDlbE=;
        h=Date:To:From:Subject:From;
        b=MXFz0f+lhBbzFna5XW3QIg/uE04lYpu2VUVUnekbQ9++F83rKpST6+4M67jTB5QF2
         wHtDf16hTuabKWrMFDrL2ODSlpZFgW+ZZJsMg7qBO9krCG6YANELXt526fBCfFSYLH
         99v0H9Y/p6xbMWx98dIRMs8iwH5I+nmZFW1J+XQo=
Date:   Sun, 06 Mar 2022 17:59:27 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, guozhengkui@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-selftests-fix-uninitialized_varcocci-warning.patch added to -mm tree
Message-Id: <20220307015928.35737C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix uninitialized_var.cocci warning
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-fix-uninitialized_varcocci-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-fix-uninitialized_varcocci-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-fix-uninitialized_varcocci-warning.patch

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
Subject: userfaultfd/selftests: fix uninitialized_var.cocci warning

Fix following coccicheck warning:
tools/testing/selftests/vm/userfaultfd.c:556:23-24:
WARNING this kind of initialization is deprecated

`unsigned long page_nr = *(&page_nr)` has the same form of
uninitialized_var() macro. I remove the redundant assignement. It has
been tested with gcc (Debian 8.3.0-6) 8.3.0.

The patch which removed uninitialized_var() is:
https://lore.kernel.org/all/20121028102007.GA7547@gmail.com/ And there is
very few "/* GCC */" comments in the Linux kernel code now.

Link: https://lkml.kernel.org/r/20220304082333.9252-1-guozhengkui@vivo.com
Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-uninitialized_varcocci-warning
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -540,7 +540,7 @@ static void continue_range(int ufd, __u6
 static void *locking_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
-	unsigned long page_nr = *(&(page_nr)); /* uninitialized warning */
+	unsigned long page_nr;
 	unsigned long long count;
 
 	if (!(bounces & BOUNCE_RANDOM)) {
_

Patches currently in -mm which might be from guozhengkui@vivo.com are

userfaultfd-selftests-fix-uninitialized_varcocci-warning.patch

