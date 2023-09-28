Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44038E732E5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 16:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjI1QGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjI1QGP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 12:06:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4030BD6
        for <mm-commits@vger.kernel.org>; Thu, 28 Sep 2023 09:06:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EA3C433C8;
        Thu, 28 Sep 2023 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695917173;
        bh=6oBw5NNegB7TYvKGRFbrJIxpTnHQiadB4OYbTsgaFrM=;
        h=Date:To:From:Subject:From;
        b=mFdeCQUhBdW1tuAs4EjUXoup8aClSk+iNZWz8cHyiFimxKFogRnphK8NKJgPsu4Ov
         p3Nza3rVACJLwKJT11APwntqMjTdlfGuvlwgsM04upIqeeNj418eR5KVtBPd7sp4RN
         1KbT71lOHUpncxEcFevsGZcvCGkYpiAoNijzEt0s=
Date:   Thu, 28 Sep 2023 09:06:13 -0700
To:     mm-commits@vger.kernel.org, dan.carpenter@linaro.org,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-add-a-secondary-array-for-shrinker_info-map-nr_deferred-fix.patch added to mm-unstable branch
Message-Id: <20230928160613.C7EA3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup: mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinker-add-a-secondary-array-for-shrinker_info-map-nr_deferred-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-add-a-secondary-array-for-shrinker_info-map-nr_deferred-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: fixup: mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}
Date: Thu, 28 Sep 2023 22:15:17 +0800

Dan Carpenter reported the following bug:

```
The patch b6884b5f15cf: "mm: shrinker: add a secondary array for
shrinker_info::{map, nr_deferred}" from Sep 11, 2023 (linux-next),
leads to the following Smatch static checker warning:

	mm/shrinker.c:100 alloc_shrinker_info()
	warn: inconsistent returns '&shrinker_mutex'.
```

To fix it, unlock the &shrinker_rwsem before the call to
free_shrinker_info().

Link: https://lkml.kernel.org/r/20230928141517.12164-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-mm/f960ae49-078c-4c00-9516-da31fc1a17d6@moroto.mountain/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shrinker.c~mm-shrinker-add-a-secondary-array-for-shrinker_info-map-nr_deferred-fix
+++ a/mm/shrinker.c
@@ -95,6 +95,7 @@ int alloc_shrinker_info(struct mem_cgrou
 	return ret;
 
 err:
+	up_write(&shrinker_rwsem);
 	free_shrinker_info(memcg);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-move-some-shrinker-related-function-declarations-to-mm-internalh.patch
mm-vmscan-move-shrinker-related-code-into-a-separate-file.patch
mm-shrinker-remove-redundant-shrinker_rwsem-in-debugfs-operations.patch
drm-ttm-introduce-pool_shrink_rwsem.patch
mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker.patch
mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix.patch
kvm-mmu-dynamically-allocate-the-x86-mmu-shrinker.patch
binder-dynamically-allocate-the-android-binder-shrinker.patch
drm-ttm-dynamically-allocate-the-drm-ttm_pool-shrinker.patch
xenbus-backend-dynamically-allocate-the-xen-backend-shrinker.patch
erofs-dynamically-allocate-the-erofs-shrinker.patch
f2fs-dynamically-allocate-the-f2fs-shrinker.patch
gfs2-dynamically-allocate-the-gfs2-glock-shrinker.patch
gfs2-dynamically-allocate-the-gfs2-qd-shrinker.patch
nfsv42-dynamically-allocate-the-nfs-xattr-shrinkers.patch
nfs-dynamically-allocate-the-nfs-acl-shrinker.patch
nfsd-dynamically-allocate-the-nfsd-filecache-shrinker.patch
quota-dynamically-allocate-the-dquota-cache-shrinker.patch
ubifs-dynamically-allocate-the-ubifs-slab-shrinker.patch
rcu-dynamically-allocate-the-rcu-lazy-shrinker.patch
rcu-dynamically-allocate-the-rcu-kfree-shrinker.patch
mm-thp-dynamically-allocate-the-thp-related-shrinkers.patch
sunrpc-dynamically-allocate-the-sunrpc_cred-shrinker.patch
mm-workingset-dynamically-allocate-the-mm-shadow-shrinker.patch
drm-i915-dynamically-allocate-the-i915_gem_mm-shrinker.patch
drm-msm-dynamically-allocate-the-drm-msm_gem-shrinker.patch
drm-panfrost-dynamically-allocate-the-drm-panfrost-shrinker.patch
dm-dynamically-allocate-the-dm-bufio-shrinker.patch
dm-zoned-dynamically-allocate-the-dm-zoned-meta-shrinker.patch
md-raid5-dynamically-allocate-the-md-raid5-shrinker.patch
bcache-dynamically-allocate-the-md-bcache-shrinker.patch
vmw_balloon-dynamically-allocate-the-vmw-balloon-shrinker.patch
virtio_balloon-dynamically-allocate-the-virtio-balloon-shrinker.patch
mbcache-dynamically-allocate-the-mbcache-shrinker.patch
ext4-dynamically-allocate-the-ext4-es-shrinker.patch
jbd2ext4-dynamically-allocate-the-jbd2-journal-shrinker.patch
nfsd-dynamically-allocate-the-nfsd-client-shrinker.patch
nfsd-dynamically-allocate-the-nfsd-reply-shrinker.patch
xfs-dynamically-allocate-the-xfs-buf-shrinker.patch
xfs-dynamically-allocate-the-xfs-inodegc-shrinker.patch
xfs-dynamically-allocate-the-xfs-qm-shrinker.patch
zsmalloc-dynamically-allocate-the-mm-zspool-shrinker.patch
fs-super-dynamically-allocate-the-s_shrink.patch
mm-shrinker-remove-old-apis.patch
mm-shrinker-add-a-secondary-array-for-shrinker_info-map-nr_deferred.patch
mm-shrinker-add-a-secondary-array-for-shrinker_info-map-nr_deferred-fix.patch
mm-shrinker-rename-preallocunregister_memcg_shrinker-to-shrinker_memcg_allocremove.patch
mm-shrinker-make-global-slab-shrink-lockless.patch
mm-shrinker-make-memcg-slab-shrink-lockless.patch
mm-shrinker-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
mm-shrinker-convert-shrinker_rwsem-to-mutex.patch

