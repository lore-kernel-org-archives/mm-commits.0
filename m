Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6635C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 22:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355868AbiDZWiY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 18:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239922AbiDZWiS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 18:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD86C1D0D1
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 15:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 692AA617AE
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 22:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14E5C385AA;
        Tue, 26 Apr 2022 22:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651012507;
        bh=Mq0FbW9Tw4Dmn786y7BilkougtQwxkrPv5TQT+UP+9k=;
        h=Date:To:From:Subject:From;
        b=oHJUy6yQ5eiMTuuP1kwhzAop5e7xdI43kN8oSfEdCZlavZT2CSfmXy6VRgSYWa+nl
         Y+MsI0OopNBuBVH19z9QQvlj1ZuY04sbISe4+jVkYvcUlSrguStN5RlYomZbs/7NGr
         9S3G1pCepALBW3quUMdrId7wX8CHC6pEXUnMARdI=
Date:   Tue, 26 Apr 2022 15:35:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, rppt@linux.ibm.com, peterz@infradead.org,
        ira.weiny@intel.com, corbet@lwn.net, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] documentation-vm-rework-temporary-virtual-mappings.patch removed from -mm tree
Message-Id: <20220426223507.C14E5C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm: rework "Temporary Virtual Mappings"
has been removed from the -mm tree.  Its filename was
     documentation-vm-rework-temporary-virtual-mappings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Documentation/vm: rework "Temporary Virtual Mappings"

Extend and rework the "Temporary Virtual Mappings" section of the
highmem.rst documentation.

Despite the local kmaps were introduced by Thomas Gleixner in October
2020, documentation was still missing information about them.  These
additions rely largely on Gleixner's patches, Jonathan Corbet's LWN
articles, comments by Ira Weiny and Matthew Wilcox, and in-code comments
from ./include/linux/highmem.h.

1) Add a paragraph to document kmap_local_page().
2) Reorder the list of functions by decreasing order of preference of
   use.
3) Rework part of the kmap() entry in list.

Link: https://lkml.kernel.org/r/20220421180200.16901-5-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/highmem.rst |   73 +++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 12 deletions(-)

--- a/Documentation/vm/highmem.rst~documentation-vm-rework-temporary-virtual-mappings
+++ a/Documentation/vm/highmem.rst
@@ -50,26 +50,75 @@ space when they use mm context tags.
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
+  These mappings are per thread, CPU local (i.e., migration from one CPU to
+  another is disabled - this is why they are called "local"), but they don't
+  disable preemption. It's valid to take pagefaults in a local kmap region,
+  unless the context in which the local mapping is acquired does not allow
+  it for other reasons.
+
+  It is assumed that kmap_local_page() always returns the virtual address
+  of the mapping, therefore they won't ever fail.
+
+  If a task holding local kmaps is preempted, the maps are removed on context
+  switch and restored when the task comes back on the CPU. As the maps are
+  strictly CPU local, it is guaranteed that the task stays on the CPU and
+  that the CPU cannot be unplugged until the local kmaps are released.
+
+  Nesting kmap_local_page() and kmap_atomic() mappings is allowed to a certain
+  extent (up to KMAP_TYPE_NR) but their invocations have to be strictly ordered
+  because the map implementation is stack based.
 
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
+  and disable pagefaults. This could be a source of unwanted latency, so it
+  should be only used if it is absolutely required, otherwise kmap_local_page()
+  should be used where it is feasible.
+
+  It is assumed that k[un]map_atomic() won't fail.
+
+* kmap().  This should be used to make short duration mapping of a single
+  page with no restrictions on preemption or migration. It comes with an
+  overhead as mapping space is restricted and protected by a global lock
+  for synchronization. When mapping is no more needed, the address that
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

mm-highmem-vm_bug_on-if-offset-len-page_size.patch

