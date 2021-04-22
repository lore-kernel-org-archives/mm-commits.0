Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2ACEC43460
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 23:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A271561417
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 23:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbhDVXJn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 19:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhDVXJn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 19:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B004661405;
        Thu, 22 Apr 2021 23:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619132943;
        bh=LHpjm6JmamAAo5jZavXZOjRlP4Lw6VyKAUHK54oNBmA=;
        h=Date:From:To:Subject:From;
        b=z2e/Sd39WpOfTdI4XhhmCftS8byBGeZRrBJCOJrEWjd3kcOjHmJUMidhtlMeiNv20
         UF1HRBxpp/C25vjM0inpjshzVDKwtc6Jtr4CRZnoVFaisj85r/XGTU3kV9VCjjYrF5
         /9m6ML3Gxw2nEek68yOhUyTVaNcRGUYD9yHpqH40=
Date:   Thu, 22 Apr 2021 16:09:03 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vvs@virtuozzo.com
Subject:  +
 tools-cgroup-slabinfopy-updated-to-work-on-current-kernel.patch added to
 -mm tree
Message-ID: <20210422230903.DgJKrJaC8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/cgroup/slabinfo.py: updated to work on current kernel
has been added to the -mm tree.  Its filename is
     tools-cgroup-slabinfopy-updated-to-work-on-current-kernel.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-cgroup-slabinfopy-updated-to-work-on-current-kernel.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-cgroup-slabinfopy-updated-to-work-on-current-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Roman Gushchin <guro@fb.com>
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

Patches currently in -mm which might be from vvs@virtuozzo.com are

tools-cgroup-slabinfopy-updated-to-work-on-current-kernel.patch

