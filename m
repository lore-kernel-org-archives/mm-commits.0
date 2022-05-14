Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B02C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiENTzR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiENTzQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E039C377E9
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D966C60EB1
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E7CC34100;
        Sat, 14 May 2022 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558114;
        bh=vDj/EBf1tPRDjiSs1VrWP11UPDKvhm1Uah9gHwwOSpk=;
        h=Date:To:From:Subject:From;
        b=bFEwHmK1PweCSZiZ42oiIVT11X7vUkIn0sW+2Bax/liBbjmlSI1AGZuLA6zntZp7m
         L40dVmVnbLy1QVZsgNSV3iq/PHKwdoUAAttPFM+5zh4+Vvhikspf0xerlMnTzebHxm
         PWlewySA4qcHMPdVEISSYi6Ylfy5FP8YRE5pprAc=
Date:   Sat, 14 May 2022 12:55:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        peterz@infradead.org, pcc@google.com, ira.weiny@intel.com,
        corbet@lwn.net, catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch removed from -mm tree
Message-Id: <20220514195514.25E7CC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation/vm: include kdocs from highmem*.h into highmem.rst
has been removed from the -mm tree.  Its filename was
     documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


