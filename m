Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1848EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjHUUl7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjHUUkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0214BCD9
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D58CA647D7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346C6C433C7;
        Mon, 21 Aug 2023 20:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650434;
        bh=tpEPjeCGrd6c0JjTVN+RH4sVixCYfODMV5X4bExYA3c=;
        h=Date:To:From:Subject:From;
        b=T6QGi9WnUPYgnOSt7jh3Sovi9atw5l7VoZA/cIxX/GFWNJMbgJScd4c0r+wC4duln
         RkyLRndwUZZTpTTQWvsKIOF7OlJTvJY5I3U6wQKwNHAHBaxcGjplf9YDnHKMYzBc3B
         9qyn45g9Q8rYMs5kdqO04j2JloigdT1b2+gv0xgQ=
Date:   Mon, 21 Aug 2023 13:40:33 -0700
To:     mm-commits@vger.kernel.org, torvalds@linuxfoundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch removed from -mm tree
Message-Id: <20230821204034.346C6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: for !CONFIG_PER_VMA_LOCK equate write lock assertion for vma and mmap
has been removed from the -mm tree.  Its filename was
     mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: for !CONFIG_PER_VMA_LOCK equate write lock assertion for vma and mmap
Date: Fri, 4 Aug 2023 08:27:20 -0700

When CONFIG_PER_VMA_LOCK=n, vma_assert_write_locked() should be equivalent
to mmap_assert_write_locked().

Link: https://lkml.kernel.org/r/20230804152724.3090321-3-surenb@google.com
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap
+++ a/include/linux/mm.h
@@ -738,7 +738,8 @@ static inline bool vma_start_read(struct
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
-static inline void vma_assert_write_locked(struct vm_area_struct *vma) {}
+static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+		{ mmap_assert_write_locked(vma->vm_mm); }
 static inline void vma_mark_detached(struct vm_area_struct *vma,
 				     bool detached) {}
 
_

Patches currently in -mm which might be from surenb@google.com are

swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-handle-userfaults-under-vma-lock-fix.patch

