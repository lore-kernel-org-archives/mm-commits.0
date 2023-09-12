Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE8FEE3F06
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 17:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjILRfs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjILRfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 13:35:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAC710EB
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 10:35:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC446C433C7;
        Tue, 12 Sep 2023 17:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694540143;
        bh=VAQ/PtV2mGamWM9fMxbH+BzwwC5af7mezqNh0cJdEBA=;
        h=Date:To:From:Subject:From;
        b=eSTivPCYpOo0tfMiqXBE041n8vj79fdrNTvS/PDyohg4c7XIw2+mKDMn6nxzJ+YdT
         zRScE9lPruU6gnqS43QDLCmSmla7gsy9OA87r8jRvwD84EHSLd7iVrrtTqeY8867ss
         RkxPAffwvvspXICVwoAiDzb0lnvKqx49IetOaiSQ=
Date:   Tue, 12 Sep 2023 10:35:42 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, david@redhat.com,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-smaps_rollup-test-after-ksm-changes.patch added to mm-hotfixes-unstable branch
Message-Id: <20230912173543.BC446C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/proc: fixup proc-empty-vm test after KSM changes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-fix-smaps_rollup-test-after-ksm-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-smaps_rollup-test-after-ksm-changes.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: selftests/proc: fixup proc-empty-vm test after KSM changes
Date: Thu, 7 Sep 2023 14:10:12 +0300

/proc/${pid}/smaps_rollup is not empty file even if process's address
space is empty, update the test.

Link: https://lkml.kernel.org/r/725e041f-e9df-4f3d-b267-d4cd2774a78d@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-fix-smaps_rollup-test-after-ksm-changes
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -267,6 +267,7 @@ static const char g_smaps_rollup[] =
 "Private_Dirty:         0 kB\n"
 "Referenced:            0 kB\n"
 "Anonymous:             0 kB\n"
+"KSM:                   0 kB\n"
 "LazyFree:              0 kB\n"
 "AnonHugePages:         0 kB\n"
 "ShmemPmdMapped:        0 kB\n"
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-fix-smaps_rollup-test-after-ksm-changes.patch

