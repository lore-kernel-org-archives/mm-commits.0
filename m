Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B99C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 18:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391390AbiDUSpq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391503AbiDUSpn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 14:45:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AB54BFE8
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 11:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC0D56165E
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 18:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B615C385A1;
        Thu, 21 Apr 2022 18:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650566570;
        bh=C0yUsGydELTajdYjratEqSgD1YltL1miWxt99XQnuMU=;
        h=Date:To:From:Subject:From;
        b=KJCcTtZuIZ/FeZSQukGfQMjGxU+HA1ytTN5NWN+h2T5AeIcAya8nHIQZB9jS/ies2
         Wyiuzxjpc9u/IkSp+j8fOIJySvHOseKeka9bdMBEy/fwIP22NiSH+wJDv8lCEmoSxQ
         vKQb8aAbRxiy/EQjn/1W8QT0E/dRwAR1acnEecnQ=
Date:   Thu, 21 Apr 2022 11:42:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, rppt@linux.ibm.com, peterz@infradead.org,
        ira.weiny@intel.com, corbet@lwn.net, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch added to -mm tree
Message-Id: <20220421184250.3B615C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm: include kdocs from highmem*.h into highmem.rst
has been added to the -mm tree.  Its filename is
     documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Documentation/vm: include kdocs from highmem*.h into highmem.rst

kernel-docs that are in include/linux/highmem.h and in
include/linux/highmem-internal.h should be included in highmem.rst.

Use kdocs directives to include the above-mentioned comments into
highmem.rst.

Link: https://lkml.kernel.org/r/20220421180200.16901-3-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
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
documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch
documentation-vm-rework-temporary-virtual-mappings.patch

