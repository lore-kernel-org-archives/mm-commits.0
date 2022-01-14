Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8609CC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiANWGX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiANWGW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:06:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2632DC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:06:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB031B82A44
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F25C36AE5;
        Fri, 14 Jan 2022 22:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197979;
        bh=pux9fU/4421rHpB9PuKYNriuo1AkKdCq7YCEgbrVSUA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hxfP21H+1qKYdjfo5Uw+x4FsYc1ZXhxxMp2bYQLXU27mQwxUxHUOiGAFSYk2Aqjwb
         v22Ay++0MTvdyWpBNnep+QVfW2twom8VzrCEZxYjqYkIQ4wiKbrUVoAhyPaOG5lmcN
         pYUUhlgdMU11h8mSrE1FBikda4waFR32fH2n88VY=
Date:   Fri, 14 Jan 2022 14:06:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, christian@brauner.io,
        david@redhat.com, fweimer@redhat.com, guro@fb.com,
        hannes@cmpxchg.org, hch@infradead.org, jannh@google.com,
        jengelh@inai.de, jgg@nvidia.com, kirill@shutemov.name,
        linux-mm@kvack.org, luto@kernel.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        riel@surriel.com, rientjes@google.com, shakeelb@google.com,
        surenb@google.com, timmurray@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 062/146] mm: document locking restrictions for
 vm_operations_struct::close
Message-ID: <20220114220618.Hd0iXILBd%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: document locking restrictions for vm_operations_struct::close

Add comments for vm_operations_struct::close documenting locking
requirements for this callback and its callers.

Link: https://lkml.kernel.org/r/20211209191325.3069345-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian@brauner.io>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/mm.h~mm-document-locking-restrictions-for-vm_operations_struct-close
+++ a/include/linux/mm.h
@@ -532,6 +532,10 @@ enum page_entry_size {
  */
 struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
+	/**
+	 * @close: Called when the VMA is being removed from the MM.
+	 * Context: User context.  May sleep.  Caller holds mmap_lock.
+	 */
 	void (*close)(struct vm_area_struct * area);
 	/* Called any time before splitting to check if it's allowed */
 	int (*may_split)(struct vm_area_struct *area, unsigned long addr);
_
