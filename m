Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED70C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiANV1Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANV1Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:27:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037B5C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:27:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEC79B82A3C
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BD9C36AE5;
        Fri, 14 Jan 2022 21:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195641;
        bh=rc0svm2rmgBfKYw0eEt6/N6i1tVlvK1es6wLqlTOEO8=;
        h=Date:From:To:Subject:From;
        b=tmYuJIqvlLta7pV8BZWCfBI4c6vUweYoJPmHWg49qP6fZrS1SxLICLuMI9rbQHPq+
         um13zYzfm5tFW1sZoye06hi8ujtixKypAeiglX2QjVPLgasdgEmhdrtmG4W8OHjT7l
         A/as/hrWcNdEe6gQzI5/OB7T21ahmLhbqeAs4ehc=
Date:   Fri, 14 Jan 2022 13:27:20 -0800
From:   akpm@linux-foundation.org
To:     ccross@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, surenb@google.com
Subject:  [folded-merged]
 mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
 removed from -mm tree
Message-ID: <20220114212720.x7jkA3p2L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: proc.rst: /proc/PID/maps: fix malformed table
has been removed from the -mm tree.  Its filename was
     mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch

This patch was dropped because it was folded into mm-add-a-field-to-store-names-for-private-anonymous-memory.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: docs: proc.rst: /proc/PID/maps: fix malformed table

Fix malformed table describing "pathname" values for mappings not
associated with a file.

Link: https://lkml.kernel.org/r/20211123185928.2513763-1-surenb@google.com
Fixes: 2df148be9486 ("mm: add a field to store names for private anonymous memory")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Colin Cross <ccross@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/filesystems/proc.rst~mm-add-a-field-to-store-names-for-private-anonymous-memory-fix
+++ a/Documentation/filesystems/proc.rst
@@ -426,14 +426,14 @@ with the memory region, as the case woul
 The "pathname" shows the name associated file for this mapping.  If the mapping
 is not associated with a file:
 
- =======                    ====================================
+ =============              ====================================
  [heap]                     the heap of the program
  [stack]                    the stack of the main process
  [vdso]                     the "virtual dynamic shared object",
                             the kernel system call handler
-[anon:<name>]               an anonymous mapping that has been
+ [anon:<name>]              an anonymous mapping that has been
                             named by userspace
- =======                    ====================================
+ =============              ====================================
 
  or if empty, the mapping is anonymous.
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
mm-add-anonymous-vma-name-refcounting.patch
mm-protect-free_pgtables-with-mmap_lock-write-lock-in-exit_mmap.patch
mm-document-locking-restrictions-for-vm_operations_struct-close.patch
mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch
sysctl-change-watermark_scale_factor-max-limit-to-30%.patch

