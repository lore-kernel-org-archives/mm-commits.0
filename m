Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD68AC63703
	for <mm-commits@archiver.kernel.org>; Wed,  7 Dec 2022 23:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLGXRw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Dec 2022 18:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLGXRu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2022 18:17:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B016A2AC41
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 15:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D920B82190
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 23:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20DEC433D6;
        Wed,  7 Dec 2022 23:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670455063;
        bh=q4TUolIPD1RWZH7wtRYZzayWzrG8UQ4LDT6353qC9QM=;
        h=Date:To:From:Subject:From;
        b=v7pZr4ebokNCSk9pM4zfGGsh81z//nCHnMtMeBXNXU0/KzYG0sCcX6w+4oIAttk/g
         ot20u0nq5/mQG4CA0Kcjm2yF6ozOgsSJmbiLggd+S2vyOS1/SgVYPY/qrYF39cjVQw
         g1DhcXlR1fGbYuJ9u+QPzeL57ylCnJEVgWaOi0GA=
Date:   Wed, 07 Dec 2022 15:17:43 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, rppt@linux.ibm.com,
        ira.weiny@intel.com, corbet@lwn.net, bigeasy@linutronix.de,
        a.p.zijlstra@chello.nl, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch added to mm-unstable branch
Message-Id: <20221207231743.D20DEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: add notes about conversions from kmap{,_atomic}()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch

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
Subject: mm/highmem: add notes about conversions from kmap{,_atomic}()
Date: Wed, 7 Dec 2022 23:53:08 +0100

kmap() and kmap_atomic() have been deprecated.  kmap_local_page() should
always be used in new code and the call sites of the two deprecated
functions should be converted.  This latter task can lead to errors if it
is not carried out with the necessary attention to the context around and
between the maps and unmaps.

Therefore, add further information to the Highmem's documentation for the
purpose to make it clearer that (1) kmap() and kmap_atomic() must not any
longer be called in new code and (2) developers doing conversions from
kmap() amd kmap_atomic() are expected to take care of the context around
and between the maps and unmaps, in order to not break the code.

Relevant parts of this patch have been taken from messages exchanged
privately with Ira Weiny (thanks!).

Link: https://lkml.kernel.org/r/20221207225308.8290-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/highmem.rst~mm-highmem-add-notes-about-conversions-from-kmap_atomic
+++ a/Documentation/mm/highmem.rst
@@ -57,7 +57,8 @@ list shows them in order of preference o
   It can be invoked from any context (including interrupts) but the mappings
   can only be used in the context which acquired them.
 
-  This function should be preferred, where feasible, over all the others.
+  This function should always be used. kmap_atomic() and kmap() have been
+  deprecated.
 
   These mappings are thread-local and CPU-local, meaning that the mapping
   can only be accessed from within this thread and the thread is bound to the
@@ -100,10 +101,21 @@ list shows them in order of preference o
   (included in the "Functions" section) for details on how to manage nested
   mappings.
 
-* kmap_atomic().  This permits a very short duration mapping of a single
-  page.  Since the mapping is restricted to the CPU that issued it, it
-  performs well, but the issuing task is therefore required to stay on that
-  CPU until it has finished, lest some other task displace its mappings.
+* kmap_atomic(). This function has been deprecated; use kmap_local_page().
+
+  NOTE: Conversions to kmap_local_page() must take care to follow the mapping
+  restrictions imposed on kmap_local_page(). Furthermore, the code between
+  calls to kmap_atomic() and kunmap_atomic() may implicitly depend on the side
+  effects of atomic mappings, i.e. disabling page faults or preemption, or both.
+  In that case, explicit calls to pagefault_disable() or preempt_disable() or
+  both must be made in conjunction with the use of kmap_local_page().
+
+  [Legacy documentation]
+
+  This permits a very short duration mapping of a single page.  Since the
+  mapping is restricted to the CPU that issued it, it performs well, but
+  the issuing task is therefore required to stay on that CPU until it has
+  finished, lest some other task displace its mappings.
 
   kmap_atomic() may also be used by interrupt contexts, since it does not
   sleep and the callers too may not sleep until after kunmap_atomic() is
@@ -115,11 +127,20 @@ list shows them in order of preference o
 
   It is assumed that k[un]map_atomic() won't fail.
 
-* kmap().  This should be used to make short duration mapping of a single
-  page with no restrictions on preemption or migration. It comes with an
-  overhead as mapping space is restricted and protected by a global lock
-  for synchronization. When mapping is no longer needed, the address that
-  the page was mapped to must be released with kunmap().
+* kmap(). This function has been deprecated; use kmap_local_page().
+
+  NOTE: Conversions to kmap_local_page() must take care to follow the mapping
+  restrictions imposed on kmap_local_page(). In particular, it is necessary to
+  make sure that the kernel virtual memory pointer is only valid in the thread
+  that obtained it.
+
+  [Legacy documentation]
+
+  This should be used to make short duration mapping of a single page with no
+  restrictions on preemption or migration. It comes with an overhead as mapping
+  space is restricted and protected by a global lock for synchronization. When
+  mapping is no longer needed, the address that the page was mapped to must be
+  released with kunmap().
 
   Mapping changes must be propagated across all the CPUs. kmap() also
   requires global TLB invalidation when the kmap's pool wraps and it might
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch

