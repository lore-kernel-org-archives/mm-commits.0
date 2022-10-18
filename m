Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB77EC43219
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 23:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJRXOe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJRXOc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 19:14:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D87D10061
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 16:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD586616FF
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 23:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A829C433D6;
        Tue, 18 Oct 2022 23:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666134869;
        bh=K8pIEANKuD/9LrMXGxcp0pBpiaOH3yKelbxd7DWmETs=;
        h=Date:To:From:Subject:From;
        b=sGeC3vh73e/y318CStTuTjgCsHhRYAckV7tOkZ3ww2KC6ZZGtX17tQeIrz/GEwqk4
         NPHldMfav1tS/cZTsUdaHPnUuwqf0VjVM+wmGk+1iwV2JCdzTd1UokZ0hY9F5gmUCO
         DYdHII7V3D3iH+ZWcUM9Wm3Bjyj3tgnqQxylrPos=
Date:   Tue, 18 Oct 2022 16:14:28 -0700
To:     mm-commits@vger.kernel.org, ivan@cloudflare.com,
        adobriyan@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221018231429.3A829C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix
Date: Tue Oct 18 04:09:23 PM PDT 2022

include linux/bitmap.h for bitmap_weight()

Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/fd.c~proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix
+++ a/fs/proc/fd.c
@@ -7,6 +7,7 @@
 #include <linux/namei.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
+#include <linux/bitmap.h>
 #include <linux/security.h>
 #include <linux/file.h>
 #include <linux/seq_file.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

