Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A411C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D650721531
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940318;
	bh=sfWseeIGpmW346icHdE/r16rMmha29P9gUmsQKgOFDU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PwLsHscxxfNdLLuDDDDgykR9MRcKQv504em/H8xx7GpvrB8P5E6ECFUCmYxak18LH
	 vSCjgJ3YDJu26Q3l4QMo2Do9xkFn4RgLizLQdXernozsJhtRf5/mvfRaRou2lc/OlY
	 DBcpYJYtaogcf8RyzRG/MphgPsAaONz1UXk+5WJ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgILTv6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgILTvu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:51:50 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDFB2087C;
        Sat, 12 Sep 2020 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599940310;
        bh=sfWseeIGpmW346icHdE/r16rMmha29P9gUmsQKgOFDU=;
        h=Date:From:To:Subject:From;
        b=oOeFYxUevzSkM/KgSg6Kpvt1f+prv3DGol/dNQjZwZzqKB+42rYitWhYv8ZGhB4iu
         +8VERho8kB6wkzRrzDv5p6G6knGpzGg4t3iW9yjfEJMspvfFABxs8FWcNQsugyu0jA
         YE1d2ZE57tYDShaTp5KBuGxw1OaNt1v1RfDccBMU=
Date:   Sat, 12 Sep 2020 12:51:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        hannes@cmpxchg.org, guro@fb.com
Subject:  +
 mm-memcg-slab-fix-racy-access-to-page-mem_cgroup-in-mem_cgroup_from_obj.patch
 added to -mm tree
Message-ID: <20200912195149.JAONk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix racy access to page->mem_cgroup in mem_cgroup_from_obj()
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-fix-racy-access-to-page-mem_cgroup-in-mem_cgroup_from_obj.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-fix-racy-access-to-page-mem_cgroup-in-mem_cgroup_from_obj.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-fix-racy-access-to-page-mem_cgroup-in-mem_cgroup_from_obj.patch

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

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-fix-racy-access-to-page-mem_cgroup-in-mem_cgroup_from_obj.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-rework-remote-memcg-charging-api-to-support-nesting.patch
mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch

