Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D751C00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiHRXxX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiHRXxX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:53:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA2B5F65
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCE7EB80E08
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82503C433D6;
        Thu, 18 Aug 2022 23:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866799;
        bh=JKtrOebXVDP1jyahRy6iaSgQOwxUECwuntpBfsJWocg=;
        h=Date:To:From:Subject:From;
        b=SUQdheSikBOilv+/yAfK+QzOTmPCl/RxOYmF+LbluqLIveOW6DyxZqyxY2CDPf6wo
         ovYg9t0qNeStkXHCGylpdM7VcPc8i/uYksfNipUY3VJDx5vLHMeXhWGsy+yWd2e1sQ
         a4JpH6YfcCXBl2iTfztPd65dI7hFEnRA+TaRMluk=
Date:   Thu, 18 Aug 2022 16:53:18 -0700
To:     mm-commits@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-add-support-for-explicit-memory-tiers-fix.patch added to mm-unstable branch
Message-Id: <20220818235319.82503C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-demotion-add-support-for-explicit-memory-tiers-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-add-support-for-explicit-memory-tiers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-add-support-for-explicit-memory-tiers-fix.patch

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
Subject: mm-demotion-add-support-for-explicit-memory-tiers-fix
Date: Thu Aug 18 04:52:00 PM PDT 2022

fix comment, per Aneesh

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memory-tiers.h~mm-demotion-add-support-for-explicit-memory-tiers-fix
+++ a/include/linux/memory-tiers.h
@@ -8,9 +8,9 @@
 #define MEMTIER_CHUNK_BITS	7
 #define MEMTIER_CHUNK_SIZE	(1 << MEMTIER_CHUNK_BITS)
 /*
- * Smaller abstract distance values imply faster(higher) memory tiers. Offset
+ * Smaller abstract distance values imply faster (higher) memory tiers. Offset
  * the DRAM adistance so that we can accommodate devices with a slightly lower
- * adistance value (slightly slower) than default DRAM adistance to be part of
+ * adistance value (slightly faster) than default DRAM adistance to be part of
  * the same memory tier.
  */
 #define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch

