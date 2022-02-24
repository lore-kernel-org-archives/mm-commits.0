Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03A1C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiBXEbm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBXEbl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:31:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4546C25A32C
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D453961772
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34421C340E9;
        Thu, 24 Feb 2022 04:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645677071;
        bh=LEgctT3TQrg90pBhLu/wpKRFJOA1icXtlUadTAeKczs=;
        h=Date:To:From:Subject:From;
        b=Pzvm/zpWnONUAZY5tnYsoycKaqsMi8Tqx/LU17L0703rB6x1rU/Kx+MVhsG25TiYX
         OsZ7VnvAhB1lj1dUd1erw+vi/AkYrr1AesieYKqTTt3XGzg/TgYPVwIOVGU7K9hkyo
         cmHthw0Uo64K6GtSEpR/JN4isjI95igfb+jI/bpU=
Date:   Wed, 23 Feb 2022 20:31:10 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sumit.semwal@linaro.org, sashal@kernel.org, pcc@google.com,
        mhocko@suse.com, legion@kernel.org,
        kirill.shutemov@linux.intel.com, keescook@chromium.org,
        hannes@cmpxchg.org, gorcunov@gmail.com, ebiederm@xmission.com,
        david@redhat.com, dave@stgolabs.net, dave.hansen@intel.com,
        chris.hyser@oracle.com, ccross@google.com, caoxiaofeng@yulong.com,
        brauner@kernel.org, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch added to -mm tree
Message-Id: <20220224043111.34421C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prevent vm_area_struct::anon_name refcount saturation
has been added to the -mm tree.  Its filename is
     mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch

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
Subject: mm: prevent vm_area_struct::anon_name refcount saturation

A deep process chain with many vmas could grow really high.  With default
sysctl_max_map_count (64k) and default pid_max (32k) the max number of
vmas in the system is 2147450880 and the refcounter has headroom of
1073774592 before it reaches REFCOUNT_SATURATED (3221225472).

Therefore it's unlikely that an anonymous name refcounter will overflow
with these defaults.  Currently the max for pid_max is PID_MAX_LIMIT
(4194304) and for sysctl_max_map_count it's INT_MAX (2147483647).  In this
configuration anon_vma_name refcount overflow becomes theoretically
possible (that still require heavy sharing of that anon_vma_name between
processes).

kref refcounting interface used in anon_vma_name structure will detect a
counter overflow when it reaches REFCOUNT_SATURATED value but will only
generate a warning about broken refcounter.

To ensure anon_vma_name refcount does not overflow, stop anon_vma_name
sharing when the refcount reaches REFCOUNT_MAX (2147483647), which still
leaves INT_MAX/2 (1073741823) values before the counter reaches
REFCOUNT_SATURATED.  This should provide enough headroom for raising the
refcounts temporarily.

Link: https://lkml.kernel.org/r/20220223153613.835563-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
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
Cc: Peter Collingbourne <pcc@google.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xiaofeng Cao <caoxiaofeng@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   18 ++++++++++++++----
 mm/madvise.c              |    3 +--
 2 files changed, 15 insertions(+), 6 deletions(-)

--- a/include/linux/mm_inline.h~mm-prevent-vm_area_struct-anon_name-refcount-saturation
+++ a/include/linux/mm_inline.h
@@ -161,15 +161,25 @@ static inline void anon_vma_name_put(str
 		kref_put(&anon_name->kref, anon_vma_name_free);
 }
 
+static inline
+struct anon_vma_name *anon_vma_name_reuse(struct anon_vma_name *anon_name)
+{
+	/* Prevent anon_name refcount saturation early on */
+	if (kref_read(&anon_name->kref) < REFCOUNT_MAX) {
+		anon_vma_name_get(anon_name);
+		return anon_name;
+
+	}
+	return anon_vma_name_alloc(anon_name->name);
+}
+
 static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
 				     struct vm_area_struct *new_vma)
 {
 	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
 
-	if (anon_name) {
-		anon_vma_name_get(anon_name);
-		new_vma->anon_name = anon_name;
-	}
+	if (anon_name)
+		new_vma->anon_name = anon_vma_name_reuse(anon_name);
 }
 
 static inline void free_anon_vma_name(struct vm_area_struct *vma)
--- a/mm/madvise.c~mm-prevent-vm_area_struct-anon_name-refcount-saturation
+++ a/mm/madvise.c
@@ -113,8 +113,7 @@ static int replace_anon_vma_name(struct
 	if (anon_vma_name_eq(orig_name, anon_name))
 		return 0;
 
-	anon_vma_name_get(anon_name);
-	vma->anon_name = anon_name;
+	vma->anon_name = anon_vma_name_reuse(anon_name);
 	anon_vma_name_put(orig_name);
 
 	return 0;
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch
mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch
mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch
mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

