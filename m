Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926CAC433F5
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 22:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiCFWJt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 17:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiCFWJs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 17:09:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAB122BF1
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 14:08:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9067FB80EC2
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 22:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA03C340EC;
        Sun,  6 Mar 2022 22:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646604532;
        bh=9pNS6u1IHHlIq7wXym0CP1OmQd2xDRnGTjdjXGKEHNI=;
        h=Date:To:From:Subject:From;
        b=rEjyl+8iPqb8BZa8L+s6fa+mnLH7xrc3CbzPKR0cPhaUFRUI5xuzPr/XHnmmXciiW
         VTK+J3H3Ex1DmQmUM/627vbfa9GbImQd2tokgxyW2hgvyU2hUNk0XHoeBrSuPfa++a
         0+1CKvq7bKU6XNby2HYGYlV9GGBx4V3pNjKukNRU=
Date:   Sun, 06 Mar 2022 14:08:51 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sumit.semwal@linaro.org, sashal@kernel.org, pcc@google.com,
        mhocko@suse.com, legion@kernel.org,
        kirill.shutemov@linux.intel.com, keescook@chromium.org,
        hannes@cmpxchg.org, gorcunov@gmail.com, ebiederm@xmission.com,
        david@redhat.com, dave@stgolabs.net, dave.hansen@intel.com,
        chris.hyser@oracle.com, ccross@google.com, caoxiaofeng@yulong.com,
        brauner@kernel.org, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch removed from -mm tree
Message-Id: <20220306220852.4AA03C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prevent vm_area_struct::anon_name refcount saturation
has been removed from the -mm tree.  Its filename was
     mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
generate a warning and freeze the ref counter.  This would lead to the
refcounted object never being freed.  A determined attacker could leak
memory like that but it would be rather expensive and inefficient way to
do so.

To ensure anon_vma_name refcount does not overflow, stop anon_vma_name
sharing when the refcount reaches REFCOUNT_MAX (2147483647), which still
leaves INT_MAX/2 (1073741823) values before the counter reaches
REFCOUNT_SATURATED.  This should provide enough headroom for raising the
refcounts temporarily.

Link: https://lkml.kernel.org/r/20220223153613.835563-2-surenb@google.com
Link: https://lkml.kernel.org/r/20220223153613.835563-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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

mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

