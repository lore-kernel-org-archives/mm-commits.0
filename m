Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BD7C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 19:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348674AbiEJTXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 15:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241644AbiEJTW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 15:22:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8E61D8100
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 12:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 550BEB81F9A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 19:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE14C385C2;
        Tue, 10 May 2022 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652210558;
        bh=wqCGRmcNqhGpe8fqUf25NqoRrTKAyJ9W9bdQBGDrA7E=;
        h=Date:To:From:Subject:From;
        b=NN6TRZZHwgcoJxJ0RvJXVWPdCHLC88xADEp2G8TxBHQsjIHNFEufvP9Na5xOm8vPl
         rTcIEW8H5ZsNNDzGI4R9Qh5rP6N3xU8Vol2KFmEI0By6zeDhC0FwBnBwuiSCJej9LS
         EqI5xkMINczjkfcjzhLQ8Hc34iAXo4y86I2rm9Rk=
Date:   Tue, 10 May 2022 12:22:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        peterz@infradead.org, pcc@google.com, ira.weiny@intel.com,
        corbet@lwn.net, catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-vm-rework-temporary-virtual-mappings-section.patch added to mm-unstable branch
Message-Id: <20220510192237.DBE14C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm: rework "Temporary Virtual Mappings" section
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-vm-rework-temporary-virtual-mappings-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-vm-rework-temporary-virtual-mappings-section.patch

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
Subject: Documentation/vm: rework "Temporary Virtual Mappings" section

Extend and rework the "Temporary Virtual Mappings" section of the
highmem.rst documentation.

Despite the local kmaps were introduced by Thomas Gleixner in October
2020, documentation was still missing information about them.  These
additions rely largely on Gleixner's patches, Jonathan Corbet's LWN
articles, comments by Ira Weiny and Matthew Wilcox, and in-code comments
from ./include/linux/highmem.h.

1) Add a paragraph to document kmap_local_page().
2) Reorder the list of functions by decreasing order of preference
   of use.
3) Rework part of the kmap() entry in list.

Link: https://lkml.kernel.org/r/20220428212455.892-5-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/highmem.rst |   72 +++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 12 deletions(-)

--- a/Documentation/vm/highmem.rst~documentation-vm-rework-temporary-virtual-mappings-section
+++ a/Documentation/vm/highmem.rst
@@ -50,26 +50,74 @@ space when they use mm context tags.
 Temporary Virtual Mappings
 ==========================
 
-The kernel contains several ways of creating temporary mappings:
+The kernel contains several ways of creating temporary mappings. The following
+list shows them in order of preference of use.
 
-* vmap().  This can be used to make a long duration mapping of multiple
-  physical pages into a contiguous virtual space.  It needs global
-  synchronization to unmap.
-
-* kmap().  This permits a short duration mapping of a single page.  It needs
-  global synchronization, but is amortized somewhat.  It is also prone to
-  deadlocks when using in a nested fashion, and so it is not recommended for
-  new code.
+* kmap_local_page().  This function is used to require short term mappings.
+  It can be invoked from any context (including interrupts) but the mappings
+  can only be used in the context which acquired them.
+
+  This function should be preferred, where feasible, over all the others.
+
+  These mappings are thread-local and CPU-local, meaning that the mapping
+  can only be accessed from within this thread and the thread is bound the
+  CPU while the mapping is active. Even if the thread is preempted (since
+  preemption is never disabled by the function) the CPU can not be
+  unplugged from the system via CPU-hotplug until the mapping is disposed.
+
+  It's valid to take pagefaults in a local kmap region, unless the context
+  in which the local mapping is acquired does not allow it for other reasons.
+
+  kmap_local_page() always returns a valid virtual address and it is assumed
+  that kunmap_local() will never fail.
+
+  Nesting kmap_local_page() and kmap_atomic() mappings is allowed to a certain
+  extent (up to KMAP_TYPE_NR) but their invocations have to be strictly ordered
+  because the map implementation is stack based. See kmap_local_page() kdocs
+  (included in the "Functions" section) for details on how to manage nested
+  mappings.
 
 * kmap_atomic().  This permits a very short duration mapping of a single
   page.  Since the mapping is restricted to the CPU that issued it, it
   performs well, but the issuing task is therefore required to stay on that
   CPU until it has finished, lest some other task displace its mappings.
 
-  kmap_atomic() may also be used by interrupt contexts, since it is does not
-  sleep and the caller may not sleep until after kunmap_atomic() is called.
+  kmap_atomic() may also be used by interrupt contexts, since it does not
+  sleep and the callers too may not sleep until after kunmap_atomic() is
+  called.
+
+  Each call of kmap_atomic() in the kernel creates a non-preemptible section
+  and disable pagefaults. This could be a source of unwanted latency. Therefore
+  users should prefer kmap_local_page() instead of kmap_atomic().
+
+  It is assumed that k[un]map_atomic() won't fail.
+
+* kmap().  This should be used to make short duration mapping of a single
+  page with no restrictions on preemption or migration. It comes with an
+  overhead as mapping space is restricted and protected by a global lock
+  for synchronization. When mapping is no longer needed, the address that
+  the page was mapped to must be released with kunmap().
+
+  Mapping changes must be propagated across all the CPUs. kmap() also
+  requires global TLB invalidation when the kmap's pool wraps and it might
+  block when the mapping space is fully utilized until a slot becomes
+  available. Therefore, kmap() is only callable from preemptible context.
+
+  All the above work is necessary if a mapping must last for a relatively
+  long time but the bulk of high-memory mappings in the kernel are
+  short-lived and only used in one place. This means that the cost of
+  kmap() is mostly wasted in such cases. kmap() was not intended for long
+  term mappings but it has morphed in that direction and its use is
+  strongly discouraged in newer code and the set of the preceding functions
+  should be preferred.
+
+  On 64-bit systems, calls to kmap_local_page(), kmap_atomic() and kmap() have
+  no real work to do because a 64-bit address space is more than sufficient to
+  address all the physical memory whose pages are permanently mapped.
 
-  It may be assumed that k[un]map_atomic() won't fail.
+* vmap().  This can be used to make a long duration mapping of multiple
+  physical pages into a contiguous virtual space.  It needs global
+  synchronization to unmap.
 
 
 Cost of Temporary Mappings
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch
documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch
documentation-vm-move-using-kmap-atomic-to-highmemh.patch
documentation-vm-rework-temporary-virtual-mappings-section.patch

