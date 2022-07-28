Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FC5C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 18:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiG1SgD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiG1Sf6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 14:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4EB6E8B4
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 11:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DE0C61D41
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0913C433C1;
        Thu, 28 Jul 2022 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659033356;
        bh=cJvjxh64Kh5coaLKHgbtlNc6uXxFr7cfmNDgLVurqvk=;
        h=Date:To:From:Subject:From;
        b=Tmd+vkMlbh5AXcFXJiaU3kTgw/c6JXqMRxMJpen5Z3dcy69+W9AqF2YoYMKplTTEa
         NGYLE+8C3MOlGyi25/gR17urHJ7t8Rt89BUIOkOqy3c/8WFBw0TR/3GedfT8ltOVsd
         6y620msiNIGVzcEQ1965py5/X2FNtiqcJQrxE7W0=
Date:   Thu, 28 Jul 2022 11:35:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-add-details-about-kmap_local_page-and-preemption.patch added to mm-unstable branch
Message-Id: <20220728183556.B0913C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/mm: add details about kmap_local_page() and preemption
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-add-details-about-kmap_local_page-and-preemption.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-add-details-about-kmap_local_page-and-preemption.patch

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
Subject: Documentation/mm: add details about kmap_local_page() and preemption
Date: Thu, 28 Jul 2022 17:48:44 +0200

What happens if a thread is preempted after mapping pages with
kmap_local_page() was questioned recently.[1]

Commit f3ba3c710ac5 ("mm/highmem: Provide kmap_local*") from Thomas
Gleixner explains clearly that on context switch, the maps of an outgoing
task are removed and the map of the incoming task are restored and that
kmap_local_page() can be invoked from both preemptible and atomic
contexts.[2]

Therefore, for the purpose to make it clearer that users can call
kmap_local_page() from contexts that allow preemption, rework a couple of
sentences and add further information in highmem.rst.

[1] https://lore.kernel.org/lkml/5303077.Sb9uPGUboI@opensuse/
[2] https://lore.kernel.org/all/20201118204007.468533059@linutronix.de/

Link: https://lkml.kernel.org/r/20220728154844.10874-8-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/highmem.rst |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/Documentation/mm/highmem.rst~documentation-mm-add-details-about-kmap_local_page-and-preemption
+++ a/Documentation/mm/highmem.rst
@@ -60,14 +60,19 @@ list shows them in order of preference o
   This function should be preferred, where feasible, over all the others.
 
   These mappings are thread-local and CPU-local, meaning that the mapping
-  can only be accessed from within this thread and the thread is bound the
-  CPU while the mapping is active. Even if the thread is preempted (since
-  preemption is never disabled by the function) the CPU can not be
-  unplugged from the system via CPU-hotplug until the mapping is disposed.
+  can only be accessed from within this thread and the thread is bound to the
+  CPU while the mapping is active. Although preemption is never disabled by
+  this function, the CPU can not be unplugged from the system via
+  CPU-hotplug until the mapping is disposed.
 
   It's valid to take pagefaults in a local kmap region, unless the context
   in which the local mapping is acquired does not allow it for other reasons.
 
+  As said, pagefaults and preemption are never disabled. There is no need to
+  disable preemption because, when context switches to a different task, the
+  maps of the outgoing task are saved and those of the incoming one are
+  restored.
+
   kmap_local_page() always returns a valid virtual address and it is assumed
   that kunmap_local() will never fail.
 
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs.patch
highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch
documentation-mm-dont-kmap-pages-which-cant-come-from-highmem.patch
documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch
documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch
highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch
documentation-mm-add-details-about-kmap_local_page-and-preemption.patch

