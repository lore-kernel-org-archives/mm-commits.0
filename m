Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA87C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 19:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbiEJTW6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 15:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241186AbiEJTWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 15:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F3A18A696
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 12:22:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADC6DB81F98
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 19:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD55C385CE;
        Tue, 10 May 2022 19:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652210553;
        bh=3JkI3rR0XZNmZVygoGEbGjx40G2CKF+trIrhdL2PAhI=;
        h=Date:To:From:Subject:From;
        b=hXI+QlwYEGixluPaBwX5PMc2mfzR2ws3CjK49NHsEsJubZuPKOI15cbnY2kQL+NxV
         vDCAfpIU4vynvWlCzMyhEDAv+eeoCoG4PVRbBWLjFtw5CwcZaZBuueNe/+2uXKUAzd
         X7AfNTQOWeWEtBAjk2dirUOsFOZlP15e5RYMAmgI=
Date:   Tue, 10 May 2022 12:22:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        peterz@infradead.org, pcc@google.com, ira.weiny@intel.com,
        corbet@lwn.net, catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch added to mm-unstable branch
Message-Id: <20220510192233.6DD55C385CE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm: include kdocs from highmem*.h into highmem.rst
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch

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
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Documentation/vm: include kdocs from highmem*.h into highmem.rst

kernel-docs that are in include/linux/highmem.h and in
include/linux/highmem-internal.h should be included in highmem.rst.

Use kdocs directives to include the above-mentioned comments into
highmem.rst.

Link: https://lkml.kernel.org/r/20220428212455.892-3-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/highmem.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/vm/highmem.rst~documentation-vm-include-kdocs-from-highmemh-into-highmemrst
+++ a/Documentation/vm/highmem.rst
@@ -145,3 +145,10 @@ The general recommendation is that you d
 machine - although more might work for you and your workload, you're pretty
 much on your own - don't expect kernel developers to really care much if things
 come apart.
+
+
+Functions
+=========
+
+.. kernel-doc:: include/linux/highmem.h
+.. kernel-doc:: include/linux/highmem-internal.h
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch
documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch
documentation-vm-move-using-kmap-atomic-to-highmemh.patch
documentation-vm-rework-temporary-virtual-mappings-section.patch

