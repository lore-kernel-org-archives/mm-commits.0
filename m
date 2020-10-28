Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A34DC61DD8
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC622207CD
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603927754;
	bh=F8dBZu4kjmX0Ex3LmNFeCFwO3wzhxss0ncXhXqi6o+k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KfVidYzznCbMio8XwoORhkS9pY7TmsMqYVrCL2Uz0OfP/5qyZ0ASoZ4kuE/T140rz
	 O+K8S237jfSkD/z604xmRXIMLeGGwQOlTX8GTvTGduRWciu4EktacynY1Gq58smEOT
	 NOTNVJCLBKVQyUR11eSV8G39mPimJOBmoIngANs0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390488AbgJ1X3O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390456AbgJ1X3N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 19:29:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C15207DE;
        Wed, 28 Oct 2020 23:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603927752;
        bh=F8dBZu4kjmX0Ex3LmNFeCFwO3wzhxss0ncXhXqi6o+k=;
        h=Date:From:To:Subject:From;
        b=VZF5JD+Amz/+VO81OjkAsTEK5trfd3dF4qP/28HoNoVNLgWdh3yzQBrbR5n3Uch60
         Vr7/l6YzSyUbOd9a5F2wiByBhmjWIn8LKv8yuJToc+cjZEquTTr0XCvxUFKlvThtXo
         Ffg8q4OHbaMQ/fxBhKqC0khMB22AZE7skGDTTRXk=
Date:   Wed, 28 Oct 2020 16:29:11 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + mm-introduce-page-memcg-flags.patch added to -mm tree
Message-ID: <20201028232911.BTk5W6UGS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce page memcg flags
has been added to the -mm tree.  Its filename is
     mm-introduce-page-memcg-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-page-memcg-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-page-memcg-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: introduce page memcg flags

The lowest bit in page->memcg_data is used to distinguish between struct
memory_cgroup pointer and a pointer to a objcgs array.  All checks and
modifications of this bit are open-coded.

Let's formalize it using page memcg flags, defined in enum
page_memcg_data_flags.

Additional flags might be added later.

Link: https://lkml.kernel.org/r/20201027001657.3398190-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-introduce-page-memcg-flags
+++ a/include/linux/memcontrol.h
@@ -343,6 +343,15 @@ struct mem_cgroup {
 
 extern struct mem_cgroup *root_mem_cgroup;
 
+enum page_memcg_data_flags {
+	/* page->memcg_data is a pointer to an objcgs vector */
+	MEMCG_DATA_OBJCGS = (1UL << 0),
+	/* the next bit after the last actual flag */
+	__NR_MEMCG_DATA_FLAGS  = (1UL << 1),
+};
+
+#define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
+
 /*
  * page_memcg - get the memory cgroup associated with a page
  * @page: a pointer to the page struct
@@ -404,13 +413,7 @@ static inline struct mem_cgroup *page_me
 	 */
 	unsigned long memcg_data = READ_ONCE(page->memcg_data);
 
-	/*
-	 * The lowest bit set means that memcg isn't a valid
-	 * memcg pointer, but a obj_cgroups pointer.
-	 * In this case the page is shared and doesn't belong
-	 * to any specific memory cgroup.
-	 */
-	if (memcg_data & 0x1UL)
+	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
 
 	return (struct mem_cgroup *)memcg_data;
@@ -429,7 +432,11 @@ static inline struct mem_cgroup *page_me
  */
 static inline struct obj_cgroup **page_objcgs(struct page *page)
 {
-	return (struct obj_cgroup **)(READ_ONCE(page->memcg_data) & ~0x1UL);
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+
+	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJCGS), page);
+
+	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -444,10 +451,10 @@ static inline struct obj_cgroup **page_o
 {
 	unsigned long memcg_data = READ_ONCE(page->memcg_data);
 
-	if (memcg_data && (memcg_data & 0x1UL))
-		return (struct obj_cgroup **)(memcg_data & ~0x1UL);
+	if (!memcg_data || !(memcg_data & MEMCG_DATA_OBJCGS))
+		return NULL;
 
-	return NULL;
+	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -460,7 +467,8 @@ static inline struct obj_cgroup **page_o
 static inline bool set_page_objcgs(struct page *page,
 					struct obj_cgroup **objcgs)
 {
-	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs | 0x1UL);
+	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs |
+			MEMCG_DATA_OBJCGS);
 }
 #else
 static inline struct obj_cgroup **page_objcgs(struct page *page)
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

