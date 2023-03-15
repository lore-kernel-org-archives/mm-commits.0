Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B573BC76195
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjCOU6A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjCOU56 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:57:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB09898E93
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BB1C61E7B
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C415C4339B;
        Wed, 15 Mar 2023 20:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678913872;
        bh=HdqTiUmfQPGrQ0Z+pL7vHuxrPPzTYD1Le4uSZRyH9G8=;
        h=Date:To:From:Subject:From;
        b=DuzqzeTV3r5+7qrUK7mI6tJOBwDLc2dBZFNMeJ22BHUcg3xSjFk2JeRRnxi8r7Bik
         0GxXDHEhL9DQkeYV/RTOu1cVdwtiN2bO0Um+/ZrG/chNCR5eEjroEKkdsUH58oB70Q
         C7H+4vSmbloe1PtRNAEeqAwg/M9/aM5DJIAzrLnQ=
Date:   Wed, 15 Mar 2023 13:57:51 -0700
To:     mm-commits@vger.kernel.org, kirill@shutemov.name,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-redefine-max_order-sanely-fix-2.patch added to mm-unstable branch
Message-Id: <20230315205752.8C415C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-redefine-max_order-sanely-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-redefine-max_order-sanely-fix-2.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-treewide-redefine-max_order-sanely-fix-2
Date: Wed Mar 15 01:54:45 PM PDT 2023

fix another min_t warning

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory_hotplug.c~mm-treewide-redefine-max_order-sanely-fix-2
+++ a/mm/memory_hotplug.c
@@ -605,7 +605,7 @@ static void online_pages_range(unsigned
 	 * this and the first chunk to online will be pageblock_nr_pages.
 	 */
 	for (pfn = start_pfn; pfn < end_pfn;) {
-		int order = min(MAX_ORDER, __ffs(pfn));
+		int order = min_t(int, MAX_ORDER, __ffs(pfn));
 
 		(*online_page_callback)(pfn_to_page(pfn), order);
 		pfn += (1UL << order);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

