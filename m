Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17107C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 21:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE6BB61468
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 21:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243960AbhDWV3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Apr 2021 17:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231841AbhDWV3m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Apr 2021 17:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3F46611F1;
        Fri, 23 Apr 2021 21:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619213344;
        bh=qZK690HLtpAgAC/AcKrNksVMSVUBxC2HY0fQjTbJuD4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=i0xWwhLQIdX7athO5z/ozErsSkvJP1ttT9MhWiBPa5P+kwoEJHEyyH4wbCHxtkwf8
         61drufDuF7OT2M+SUCxgbudzhc5CsQonjktX/NmuexWH5R7KHAyp4jp6/kedhlVg9h
         nI+HbjqnnrKwGyf1lDHSSSBiubfQGExnQZTYg+p4=
Date:   Fri, 23 Apr 2021 14:29:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vvs@virtuozzo.com
Subject:  [patch 5/5] tools/cgroup/slabinfo.py: updated to work on
 current kernel
Message-ID: <20210423212903.MyWBagVIN%akpm@linux-foundation.org>
In-Reply-To: <20210423142805.fd6d718ec3296452108b3ee0@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: tools/cgroup/slabinfo.py: updated to work on current kernel

slabinfo.py script does not work with actual kernel version.
First, it was unable to recognise SLUB susbsytem,
when I specified it manually, it was failed again with
AttributeError: 'struct page' has no member 'obj_cgroups'
... and then again with
  File "tools/cgroup/memcg_slabinfo.py", line 221, in main
    memcg.kmem_caches.address_of_(),
AttributeError: 'struct mem_cgroup' has no member 'kmem_caches'

Link: https://lkml.kernel.org/r/cec1a75e-43b4-3d64-2084-d9f98fda037f@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Tested-by: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/cgroup/memcg_slabinfo.py |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/cgroup/memcg_slabinfo.py~tools-cgroup-slabinfopy-updated-to-work-on-current-kernel
+++ a/tools/cgroup/memcg_slabinfo.py
@@ -128,9 +128,9 @@ def detect_kernel_config():
 
     cfg['nr_nodes'] = prog['nr_online_nodes'].value_()
 
-    if prog.type('struct kmem_cache').members[1][1] == 'flags':
+    if prog.type('struct kmem_cache').members[1].name == 'flags':
         cfg['allocator'] = 'SLUB'
-    elif prog.type('struct kmem_cache').members[1][1] == 'batchcount':
+    elif prog.type('struct kmem_cache').members[1].name == 'batchcount':
         cfg['allocator'] = 'SLAB'
     else:
         err('Can\'t determine the slab allocator')
@@ -193,7 +193,7 @@ def main():
         # look over all slab pages, belonging to non-root memcgs
         # and look for objects belonging to the given memory cgroup
         for page in for_each_slab_page(prog):
-            objcg_vec_raw = page.obj_cgroups.value_()
+            objcg_vec_raw = page.memcg_data.value_()
             if objcg_vec_raw == 0:
                 continue
             cache = page.slab_cache
@@ -202,7 +202,7 @@ def main():
             addr = cache.value_()
             caches[addr] = cache
             # clear the lowest bit to get the true obj_cgroups
-            objcg_vec = Object(prog, page.obj_cgroups.type_,
+            objcg_vec = Object(prog, 'struct obj_cgroup **',
                                value=objcg_vec_raw & ~1)
 
             if addr not in stats:
_
