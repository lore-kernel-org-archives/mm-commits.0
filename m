Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA9DC74A5B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Mar 2023 21:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjC2Vx7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Mar 2023 17:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC2Vx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2023 17:53:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9011BCA
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 14:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ECA2B824C1
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3342BC433D2;
        Wed, 29 Mar 2023 21:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680126824;
        bh=c/GC+LNZgCxcVBPe+mJG+0O4/Mnsq9SvPd0d2vHvg14=;
        h=Date:To:From:Subject:From;
        b=c7IgEuVZidYrfPpQxFHzXPDR12hT0L5bshLvuCix9KzYdeKh2qqOvoZEX7wqwhH2j
         FS9wpPjXma0QrUMJHWW8d9XgYX2ynewpLCGjXZOzPRps1DIhOwyTSpe1d0ZAxVPN7E
         /5JJaPIu2wf2I0KKe4P2nJJV9QKiaetlcaF5dkhU=
Date:   Wed, 29 Mar 2023 14:53:43 -0700
To:     mm-commits@vger.kernel.org, songliubraving@fb.com,
        skhan@linuxfoundation.org, riel@surriel.com,
        kirill.shutemov@linux.intel.com, ivan.orlov0322@gmail.com,
        himadrispandya@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230329215344.3342BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix
Date: Wed Mar 29 02:50:56 PM PDT 2023

update include/trace/events/huge_memory.h's SCAN_STATUS

Cc: Himadri Pandya <himadrispandya@gmail.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix
+++ a/include/trace/events/huge_memory.h
@@ -36,7 +36,8 @@
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
 	EM( SCAN_TRUNCATED,		"truncated")			\
-	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EMe(SCAN_STORE_FAILED,		"store_failed")
 
 #undef EM
 #undef EMe
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

