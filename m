Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8105EC6FD1A
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 21:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjCFVgH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjCFVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 16:36:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CAA366AA
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 13:36:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D71A5B81128
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 21:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAB5C433D2;
        Mon,  6 Mar 2023 21:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678138562;
        bh=QBAKUAV3qZ2YsM+IW391LirwZTYG3jjdl4ut0RWY5cs=;
        h=Date:To:From:Subject:From;
        b=nm6bDpRYxHpuxSua+tPtqkKv+ahcVHZFGo7lXhE9Is3g53wpVGDolqJ18Bgi0BBvw
         lcRnsP6zMMY0JuhRxycUme/YaJk6Ellmyc7pxsvh+XkjQzLsoh2D8LQvLXdhvhqwLA
         q0xsZHQkAGFj2rbABeFzdyb7owomVgdiZnVOX+RM=
Date:   Mon, 06 Mar 2023 13:36:01 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-link-vmlinuxsh-fix-error-message-presentation.patch added to mm-nonmm-unstable branch
Message-Id: <20230306213602.7AAB5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/link-vmlinux.sh: fix error message presentation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-link-vmlinuxsh-fix-error-message-presentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-link-vmlinuxsh-fix-error-message-presentation.patch

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
Subject: scripts/link-vmlinux.sh: fix error message presentation
Date: Mon Mar  6 01:32:53 PM PST 2023

This comes out as

   Try make KALLSYMS_EXTRA_PASS=1 as a workaround

but we want quotes:

   Try "make KALLSYMS_EXTRA_PASS=1" as a workaround

Link: https://lkml.kernel.org/r/202303042034.Cjc7JTd0-lkp@intel.com
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/link-vmlinux.sh~scripts-link-vmlinuxsh-fix-error-message-presentation
+++ a/scripts/link-vmlinux.sh
@@ -291,7 +291,7 @@ fi
 if is_enabled CONFIG_KALLSYMS; then
 	if ! cmp -s System.map ${kallsyms_vmlinux}.syms; then
 		echo >&2 Inconsistent kallsyms data
-		echo >&2 Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
+		echo >&2 'Try "make KALLSYMS_EXTRA_PASS=1" as a workaround'
 		exit 1
 	fi
 fi
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch

