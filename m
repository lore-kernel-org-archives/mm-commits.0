Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4D8C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiBOUje (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:39:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiBOUjd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:39:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A08D76EC
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:39:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85C83B81CD6
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D09C340EB;
        Tue, 15 Feb 2022 20:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644957560;
        bh=B4uANN2FL3luWc9dUTI5/bWa0P1Hwt38Q+BFgbmkGto=;
        h=Date:To:From:Subject:From;
        b=Pa+e8vsfr3vZ+4jNCwFwEM7KUXq/MpQFNLs0qQStWJujjiYQu4oTliB/JI+rrWTfy
         EVMfsu3Lout22Pihgqhsm/YfZ9gMRGuVqR7JDxGGVa5b9KyE+RS5+T0gB4X7LAJN1v
         8S4InZYSKCLJJuJa1I3zZbus/y9vdT5Mqnp3UrYY=
Date:   Tue, 15 Feb 2022 12:39:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        timmurray@google.com, shy828301@gmail.com, shakeelb@google.com,
        rientjes@google.com, riel@surriel.com, oleg@redhat.com,
        minchan@kernel.org, mhocko@suse.com, luto@kernel.org,
        kirill@shutemov.name, jengelh@inai.de, jannh@google.com,
        hch@infradead.org, hannes@cmpxchg.org, guro@fb.com,
        fweimer@redhat.com, david@redhat.com, christian.brauner@ubuntu.com,
        brauner@kernel.org, aarcange@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch added to -mm tree
Message-Id: <20220215203919.D3D09C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix use-after-free bug when mm->mmap is reused after being freed
has been added to the -mm tree.  Its filename is
     mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch

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
Subject: mm: fix use-after-free bug when mm->mmap is reused after being freed

After exit_mmap frees all vmas in the mm, mm->mmap needs to be reset,
otherwise it points to a vma that was freed and when reused leads to a
use-after-free bug.

Link: https://lore.kernel.org/all/00000000000072ef2c05d7f81950@google.com/
Link: https://lkml.kernel.org/r/20220215201922.1908156-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+2ccf63a4bd07cf39cab0@syzkaller.appspotmail.com
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed
+++ a/mm/mmap.c
@@ -3186,6 +3186,7 @@ void exit_mmap(struct mm_struct *mm)
 		vma = remove_vma(vma);
 		cond_resched();
 	}
+	mm->mmap = NULL;
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch

