Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E987EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjFSX0K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjFSXYV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A76D19AB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2796460FC1
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC4FC433C0;
        Mon, 19 Jun 2023 23:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216977;
        bh=K5WhTCV/y3/rE4iX4VBPykGV29L//Hlh1cBwF8/mKbQ=;
        h=Date:To:From:Subject:From;
        b=yjuHlurVGxluAI6OyFsjPAp1PBSmbsKv5q86rbGQB+PohIOYGirpm8Y+PTrayDHFC
         hYvMir4eNwAvdAVae5CEoJ1i01V+OOvPyvpaT+XTg8vNW0JXQDGp3HhwUzMmWQ4fTo
         +DVuqxcTQNjtpWCxSqAgdmVmKnD9I6QBkt/eW94U=
Date:   Mon, 19 Jun 2023 16:22:56 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        yuehaibing@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-vma_init_lock.patch removed from -mm tree
Message-Id: <20230619232257.7EC4FC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove unused vma_init_lock()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-vma_init_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm: remove unused vma_init_lock()
Date: Sat, 10 Jun 2023 18:19:56 +0800

commit c7f8f31c00d1 ("mm: separate vma->lock from vm_area_struct")
left this behind.

Link: https://lkml.kernel.org/r/20230610101956.20592-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h~mm-remove-unused-vma_init_lock
+++ a/include/linux/mm.h
@@ -725,7 +725,6 @@ struct vm_area_struct *lock_vma_under_rc
 
 #else /* CONFIG_PER_VMA_LOCK */
 
-static inline void vma_init_lock(struct vm_area_struct *vma) {}
 static inline bool vma_start_read(struct vm_area_struct *vma)
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
_

Patches currently in -mm which might be from yuehaibing@huawei.com are


