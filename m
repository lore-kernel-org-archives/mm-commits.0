Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786F7C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 22:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243725AbiDZWiR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 18:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239922AbiDZWiQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 18:38:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4619BC3A
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 15:35:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 537F161927
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 22:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD43C385A0;
        Tue, 26 Apr 2022 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651012505;
        bh=x2dqs/NLmCUbyxIHx0A4KmZj1xs8lYcG4dTALfgR2Jc=;
        h=Date:To:From:Subject:From;
        b=pLROIMkc2CKZyzRzhnPaneY6JwRAVij0Io4dSR7sIrvAzImxLpuXoTSUwmEW+ul83
         wwM9oo2Q2w4WTI7x3tu4N1W3WCaYIfXd3Yc7bBbbbHWOdWe0env7HhMfCDVOgWrDVj
         m6mJK0RlAE+chqW353VTSBVkj673SHeDdvOTTIfc=
Date:   Tue, 26 Apr 2022 15:35:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, rppt@linux.ibm.com, peterz@infradead.org,
        ira.weiny@intel.com, corbet@lwn.net, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch removed from -mm tree
Message-Id: <20220426223505.9BD43C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm: include kdocs from highmem*.h into highmem.rst
has been removed from the -mm tree.  Its filename was
     documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Documentation/vm: include kdocs from highmem*.h into highmem.rst

kernel-docs that are in include/linux/highmem.h and in
include/linux/highmem-internal.h should be included in highmem.rst.

Use kdocs directives to include the above-mentioned comments into
highmem.rst.

Link: https://lkml.kernel.org/r/20220421180200.16901-3-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
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

documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch
documentation-vm-rework-temporary-virtual-mappings.patch
mm-highmem-vm_bug_on-if-offset-len-page_size.patch

