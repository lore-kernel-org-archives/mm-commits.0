Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB70C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 23:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbhLHXVE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbhLHXVD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2021 18:21:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F52C061746
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 15:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DD05B82325
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 23:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DC5C00446;
        Wed,  8 Dec 2021 23:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639005448;
        bh=wBm4J5gn3whYuTe8p6AG++noqgbBXyoFNtJ2f5heDmU=;
        h=Date:From:To:Subject:From;
        b=wS+uli7TuKqcm2ZiaFVLkD4WnFtAy6p5mojA2gIbyKMR8OxFHd/TSyut4onp4mqtB
         bQFZSNDF04oApza3KyIMU3J+EWHX2nN0OAcCX7FHam499Xlar+TkAwSBYTGzi40QfH
         M5EwIIHaOjhi8buQRsrZjotJat8Ypjxgbf5POOBQ=
Date:   Wed, 08 Dec 2021 15:17:27 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, christian.brauner@ubuntu.com,
        christian@brauner.io, david@redhat.com, fweimer@redhat.com,
        guro@fb.com, hannes@cmpxchg.org, hch@infradead.org,
        jannh@google.com, jengelh@inai.de, kirill@shutemov.name,
        luto@kernel.org, mchehab@kernel.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        riel@surriel.com, rientjes@google.com, shakeelb@google.com,
        surenb@google.com, timmurray@google.com, willy@infradead.org
Subject:  +
 mm-document-locking-restrictions-for-vm_operations_struct-close.patch added
 to -mm tree
Message-ID: <20211208231727.dS-vwANhw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document locking restrictions for vm_operations_struct::close
has been added to the -mm tree.  Its filename is
     mm-document-locking-restrictions-for-vm_operations_struct-close.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-document-locking-restrictions-for-vm_operations_struct-close.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-document-locking-restrictions-for-vm_operations_struct-close.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: document locking restrictions for vm_operations_struct::close

Patch series "mm: protect free_pgtables with mmap_lock write lock in exit_mmap", v4.

oom-reaper and process_mrelease system call should protect against races
with exit_mmap which can destroy page tables while they walk the VMA tree.
oom-reaper protects from that race by setting MMF_OOM_VICTIM and by
relying on exit_mmap to set MMF_OOM_SKIP before taking and releasing
mmap_write_lock.  process_mrelease has to elevate mm->mm_users to prevent
such race.  Both oom-reaper and process_mrelease hold mmap_read_lock when
walking the VMA tree.

The locking rules and mechanisms could be simpler if exit_mmap takes
mmap_write_lock while executing destructive operations such as
free_pgtables.

Change exit_mmap to hold the mmap_write_lock when calling free_pgtables
and remove_vma.  Operations like unmap_vmas and unlock_range are not
destructive and could run under mmap_read_lock but for simplicity we take
one mmap_write_lock during almost the entire operation.  Note also that
because oom-reaper checks VM_LOCKED flag, unlock_range() should not be
allowed to race with it.

Before this patch, remove_vma used to be called with no locks held,
however with fput being executed asynchronously and vm_ops->close not
being allowed to hold mmap_lock (it is called from __split_vma with
mmap_sem held for write), changing that should be fine.

In most cases this lock should be uncontended.  Previously, Kirill
reported ~4% regression caused by a similar change [1].  We reran the same
test and although the individual results are quite noisy, the percentiles
show lower regression with 1.6% being the worst case [2].  The change
allows oom-reaper and process_mrelease to execute safely under
mmap_read_lock without worries that exit_mmap might destroy page tables
from under them.

[1] https://lore.kernel.org/all/20170725141723.ivukwhddk2voyhuc@node.shutemov.name/
[2] https://lore.kernel.org/all/CAJuCfpGC9-c9P40x7oy=jy5SphMcd0o0G_6U1-+JAziGKG6dGA@mail.gmail.com/


This patch (of 2):

Add comments for vm_operations_struct::close documenting locking
requirements for this callback and its callers.

Link: https://lkml.kernel.org/r/20211208212211.2860249-1-surenb@google.com
Link: https://lkml.kernel.org/r/20211208212211.2860249-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Tim Murray <timmurray@google.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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

Patches currently in -mm which might be from surenb@google.com are

mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
mm-add-anonymous-vma-name-refcounting.patch
mm-document-locking-restrictions-for-vm_operations_struct-close.patch
mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch
sysctl-change-watermark_scale_factor-max-limit-to-30%.patch

