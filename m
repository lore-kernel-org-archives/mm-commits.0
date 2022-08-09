Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6034C25B0D
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244805AbiHIBP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244822AbiHIBO5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF621DA7B
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E23A6116D
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4519C433C1;
        Tue,  9 Aug 2022 01:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007680;
        bh=pOd4jAI2gMUgjP7hlYA314ErRIPbUYf/TX77jBdlbUQ=;
        h=Date:To:From:Subject:From;
        b=FVj1vLLUdkMLvCn6e1ZZO33sf5Ezux9PvfX3AMScKzdQbBDT7vdQzEkS9zBNVttZq
         Vfc77BzLsCVn6XnlL78Lf/efGwpACezkoJcSbIOoJgPPDKLrZkLPjPrfIYzg+cZAyp
         Og2jfanK3TBlmsEovBea+k+laVOM883DFI5eTvb0=
Date:   Mon, 08 Aug 2022 18:14:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch removed from -mm tree
Message-Id: <20220809011440.A4519C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation/mm: rrefer kmap_local_page() and avoid kmap()
has been removed from the -mm tree.  Its filename was
     documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Documentation/mm: rrefer kmap_local_page() and avoid kmap()
Date: Thu, 28 Jul 2022 17:48:42 +0200

The reasoning for converting kmap() to kmap_local_page() was questioned
recently.[1]

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) kmap() also requires global TLB invalidation when
its pool wraps and it might block when the mapping space is fully utilized
until a slot becomes available.

Warn users to avoid the use of kmap() and instead use kmap_local_page(),
by designing their code to map pages in the same context the mapping will
be used.

[1] https://lore.kernel.org/lkml/1891319.taCxCBeP46@opensuse/

Link: https://lkml.kernel.org/r/20220728154844.10874-6-fmdefrancesco@gmail.com
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

 Documentation/mm/highmem.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/mm/highmem.rst~documentation-mm-prefer-kmap_local_page-and-avoid-kmap
+++ a/Documentation/mm/highmem.rst
@@ -84,6 +84,11 @@ list shows them in order of preference o
   be absolutely sure to keep the use of the return address local to the
   thread which mapped it.
 
+  Most code can be designed to use thread local mappings. User should
+  therefore try to design their code to avoid the use of kmap() by mapping
+  pages in the same thread the address will be used and prefer
+  kmap_local_page().
+
   Nesting kmap_local_page() and kmap_atomic() mappings is allowed to a certain
   extent (up to KMAP_TYPE_NR) but their invocations have to be strictly ordered
   because the map implementation is stack based. See kmap_local_page() kdocs
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


