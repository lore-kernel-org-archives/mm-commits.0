Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1BFC2D0AE
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66841221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633203;
	bh=Q8HLFTATOkI/j2bnsqR01lRU60IVX6GDxAjATU7vDA8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=o/8OnGHvXbzXnR6t3SfNfs8CcKKn24hWlIzAMCjLFpIJKvPnm9fqzcYOb2Crcvlnx
	 AWnrIyuLvI7/9ISC9NV7XXNZOj0aNZMxXG15LSeAzK2zSeIMfmT+2V11TOVJgSuMkS
	 3WBkdt+EBcx+VLSgHX2O9NXnensEvRn80DXErmOo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgJMXxW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbgJMXwn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078CC22202;
        Tue, 13 Oct 2020 23:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633163;
        bh=Q8HLFTATOkI/j2bnsqR01lRU60IVX6GDxAjATU7vDA8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=070k21cq674eaFGn+6G8dJyCdGLINFTJVfodsU60aICo1FTEXMO3P8x766ZTKI1/l
         q6e085SPYNnkeennIA4NUf/6oH/6iR9+uPrDfmo3VZa9hQQVTpukI8o3aIJ4JpvZwt
         6cJWOApWJ7c2ZJY2T1vdjHFQQgN9mAG8Scoqv9/s=
Date:   Tue, 13 Oct 2020 16:52:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 080/181] mm: memcg/slab: fix racy access to
 page->mem_cgroup in mem_cgroup_from_obj()
Message-ID: <20201013235242.2aU4e1EVF%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: fix racy access to page->mem_cgroup in mem_cgroup_from_obj()

mem_cgroup_from_obj() checks the lowest bit of the page->mem_cgroup
pointer to determine if the page has an attached obj_cgroup vector instead
of a regular memcg pointer.  If it's not set, it simple returns the
page->mem_cgroup value as a struct mem_cgroup pointer.

The commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
for all allocations") changed the moment when this bit is set: if
previously it was set on the allocation of the slab page, now it can be
set well after, when the first accounted object is allocated on this page.

It opened a race: if page->mem_cgroup is set concurrently after the first
page_has_obj_cgroups(page) check, a pointer to the obj_cgroups array can
be returned as a memory cgroup pointer.

A simple check for page->mem_cgroup pointer for NULL before the
page_has_obj_cgroups() check fixes the race.  Indeed, if the pointer is
not NULL, it's either a simple mem_cgroup pointer or a pointer to
obj_cgroup vector.  The pointer can be asynchronously changed from NULL to
(obj_cgroup_vec | 0x1UL), but can't be changed from a valid memcg pointer
to objcg vector or back.

If the object passed to mem_cgroup_from_obj() is a slab object and
page->mem_cgroup is NULL, it means that the object is not accounted, so
the function must return NULL.

I've discovered the race looking at the code, so far I haven't seen it in
the wild.

Link: https://lkml.kernel.org/r/20200910022435.2773735-1-guro@fb.com
Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-slab-fix-racy-access-to-page-mem_cgroup-in-mem_cgroup_from_obj
+++ a/mm/memcontrol.c
@@ -2888,6 +2888,17 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 	page = virt_to_head_page(p);
 
 	/*
+	 * If page->mem_cgroup is set, it's either a simple mem_cgroup pointer
+	 * or a pointer to obj_cgroup vector. In the latter case the lowest
+	 * bit of the pointer is set.
+	 * The page->mem_cgroup pointer can be asynchronously changed
+	 * from NULL to (obj_cgroup_vec | 0x1UL), but can't be changed
+	 * from a valid memcg pointer to objcg vector or back.
+	 */
+	if (!page->mem_cgroup)
+		return NULL;
+
+	/*
 	 * Slab objects are accounted individually, not per-page.
 	 * Memcg membership data for each individual object is saved in
 	 * the page->obj_cgroups.
_
