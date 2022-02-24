Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FD8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiBXEbq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBXEbo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:31:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780D925A94D
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:31:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10ABD6177F
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6577DC340E9;
        Thu, 24 Feb 2022 04:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645677074;
        bh=TQAGTD1cCjsjc6CzJxyEficIlPN+cHhpp7l8WY1nhmo=;
        h=Date:To:From:Subject:From;
        b=IvhnieDdP8bmgYTToNNwy94JwYvpBJ2vgrdMLcaV2akOp4deUZyXPqJm7hjLJFbTf
         fo+e3Wikx5d4i/e1nt0RGDc1YT0AMZwj98Dmxl46EO7t3qeBbI0PSafwtl0sbXBmLB
         QwpOKl62OlwZChj6H+DfK8xhDcrcVx7OhON6d6tQ=
Date:   Wed, 23 Feb 2022 20:31:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sumit.semwal@linaro.org, sashal@kernel.org, pcc@google.com,
        mhocko@suse.com, legion@kernel.org,
        kirill.shutemov@linux.intel.com, keescook@chromium.org,
        hannes@cmpxchg.org, gorcunov@gmail.com, ebiederm@xmission.com,
        david@redhat.com, dave@stgolabs.net, dave.hansen@intel.com,
        chris.hyser@oracle.com, ccross@google.com, caoxiaofeng@yulong.com,
        brauner@kernel.org, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch added to -mm tree
Message-Id: <20220224043114.6577DC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix use-after-free when anon vma name is used after vma is freed
has been added to the -mm tree.  Its filename is
     mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch

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
Subject: mm: fix use-after-free when anon vma name is used after vma is freed

When adjacent vmas are being merged it can result in the vma that was
originally passed to madvise_update_vma being destroyed.  In the current
implementation, the name parameter passed to madvise_update_vma points
directly to vma->anon_name and it is used after the call to vma_merge.  In
the cases when vma_merge merges the original vma and destroys it, this
will result in use-after-free bug as shown below:

madvise_vma_behavior(vma)
  madvise_update_vma(vma, ..., anon_name == vma->anon_name)
    vma_merge(vma)
      __vma_adjust(vma) <-- merges vma with adjacent one
        vm_area_free(vma) <-- frees the original vma
    replace_vma_anon_name(anon_name) <-- UAF of vma->anon_name

Fix this by raising the name refcount and stabilizing it.

Link: https://lkml.kernel.org/r/20220223153613.835563-3-surenb@google.com
Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+aa7b3d4b35f9dc46a366@syzkaller.appspotmail.com
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Chris Hyser <chris.hyser@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xiaofeng Cao <caoxiaofeng@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed
+++ a/mm/madvise.c
@@ -131,6 +131,8 @@ static int replace_anon_vma_name(struct
 /*
  * Update the vm_flags on region of a vma, splitting it or merging it as
  * necessary.  Must be called with mmap_sem held for writing;
+ * Caller should ensure anon_name stability by raising its refcount even when
+ * anon_name belongs to a valid vma because this function might free that vma.
  */
 static int madvise_update_vma(struct vm_area_struct *vma,
 			      struct vm_area_struct **prev, unsigned long start,
@@ -945,6 +947,7 @@ static int madvise_vma_behavior(struct v
 				unsigned long behavior)
 {
 	int error;
+	struct anon_vma_name *anon_name;
 	unsigned long new_flags = vma->vm_flags;
 
 	switch (behavior) {
@@ -1010,8 +1013,11 @@ static int madvise_vma_behavior(struct v
 		break;
 	}
 
+	anon_name = anon_vma_name(vma);
+	anon_vma_name_get(anon_name);
 	error = madvise_update_vma(vma, prev, start, end, new_flags,
-				   anon_vma_name(vma));
+				   anon_name);
+	anon_vma_name_put(anon_name);
 
 out:
 	/*
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch
mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch
mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch
mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

