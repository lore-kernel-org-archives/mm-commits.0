Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1FEC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbjHKXBB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbjHKXAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7104C35AA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FAA367657
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654A9C433C8;
        Fri, 11 Aug 2023 22:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794789;
        bh=4kTDPbBPUhJkRkNruDS691JeGhyiKqNSuMOpxDvRXs4=;
        h=Date:To:From:Subject:From;
        b=iUZhLZgaC0VhoaevLEDTZHp7pb3q9810OFQ+pNHHnJ75s+rpaLjUjwbXWWonBTsFi
         E2p7+1roIaxV83+UF4QS/7PbKnk9BPQuYjC3fxluPv+67ErHVxHQH9y0oyE0K3t2sA
         lrdplXLMZfRb5jQjyxcFdXb92i69g/6rBszc3z38=
Date:   Fri, 11 Aug 2023 15:59:48 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-pte_marker_swapin_error-more-general-fix.patch removed from -mm tree
Message-Id: <20230811225949.654A9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-make-pte_marker_swapin_error-more-general-fix
has been removed from the -mm tree.  Its filename was
     mm-make-pte_marker_swapin_error-more-general-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-pte_marker_swapin_error-more-general-fix
Date: Sat Jul  8 06:03:23 PM PDT 2023

fix CONFIG_MMU=n build

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mm_inline.h~mm-make-pte_marker_swapin_error-more-general-fix
+++ a/include/linux/mm_inline.h
@@ -523,6 +523,7 @@ static inline bool mm_tlb_flush_nested(s
 	return atomic_read(&mm->tlb_flush_pending) > 1;
 }
 
+#ifdef CONFIG_MMU
 /*
  * Computes the pte marker to copy from the given source entry into dst_vma.
  * If no marker should be copied, returns 0.
@@ -541,6 +542,7 @@ static inline pte_marker copy_pte_marker
 
 	return dstm;
 }
+#endif
 
 /*
  * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

