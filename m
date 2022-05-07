Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13095C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 18:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377138AbiEGSob (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 14:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiEGSob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 14:44:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6445617A97
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 11:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF45B8015B
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 18:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD82DC385A6;
        Sat,  7 May 2022 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651948840;
        bh=CbDteI7FsY34az1lC3nOH4h57eJ2lpkXI4Uxl8P8MeY=;
        h=Date:To:From:Subject:From;
        b=lUw72FBX+XhDFn1yqypCNJhhP3/3O+5TrkqKZveBVPS2f7j6+taNARMc3Q5xzc0a+
         tbmyOha2Uwg8aPT68ncmKFTi0iqICVofwBKKvleldh5ncbhPcZTDgmWZatAG7OyYg/
         KhWsM92svPKhrKkPMlf5540u2dvgfe6ddAspNdUE=
Date:   Sat, 07 May 2022 11:40:40 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, prudo@redhat.com,
        dyoung@redhat.com, bhe@redhat.com, sensor1010@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-crash_corec-remove-redundant-check-of-ck_cmdline.patch added to mm-nonmm-unstable branch
Message-Id: <20220507184040.BD82DC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/crash_core.c: remove redundant check of ck_cmdline
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-crash_corec-remove-redundant-check-of-ck_cmdline.patch

This patch should soon appear in the mm-nonmm-unstable branch at
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
From: lizhe <sensor1010@163.com>
Subject: kernel/crash_core.c: remove redundant check of ck_cmdline

At the end of get_last_crashkernel(), the judgement of ck_cmdline is
obviously unnecessary and causes redundance, let's clean it up.

Link: https://lkml.kernel.org/r/20220506104116.259323-1-sensor1010@163.com
Signed-off-by: lizhe <sensor1010@163.com>
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: Philipp Rudo <prudo@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/crash_core.c~kernel-crash_corec-remove-redundant-check-of-ck_cmdline
+++ a/kernel/crash_core.c
@@ -222,9 +222,6 @@ next:
 		p = strstr(p+1, name);
 	}
 
-	if (!ck_cmdline)
-		return NULL;
-
 	return ck_cmdline;
 }
 
_

Patches currently in -mm which might be from sensor1010@163.com are

kernel-crash_corec-remove-redundant-check-of-ck_cmdline.patch

