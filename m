Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D84BEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjFSUUn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjFSUUV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A243010C2
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 365BB60E71
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92652C433C0;
        Mon, 19 Jun 2023 20:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206018;
        bh=yfQdtfCJImUG389W9IZc+MJiyHV4JBQUEM3RJRubmLU=;
        h=Date:To:From:Subject:From;
        b=bWcLsZRCB2Ppvx+JubXo2/iFeeup8ha96Jx3KOTNie/SrHj97gKGyvK6pdFboPE1Y
         bJST+wBiN9JAU0UgPpSlOZ2Wd9O+cJaIDPZzBhDiNITayRt9/p8c1lSiieWquNTjTS
         nkytsVB4Fo8bt7KHkyKG4VzN0DQk+tXrgN7Bu15I=
Date:   Mon, 19 Jun 2023 13:20:18 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch removed from -mm tree
Message-Id: <20230619202018.92652C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: shrinkers: make count and scan in shrinker debugfs lockless"
has been removed from the -mm tree.  Its filename was
     revert-mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Revert "mm: shrinkers: make count and scan in shrinker debugfs lockless"
Date: Fri, 9 Jun 2023 08:15:15 +0000

This reverts commit 20cd1892fcc3efc10a7ac327cc3790494bec46b5.

Kernel test robot reports -88.8% regression in stress-ng.ramfs.ops_per_sec
test case [1], which is caused by commit f95bdb700bc6 ("mm: vmscan: make
global slab shrink lockless").  The root cause is that SRCU has to be
careful to not frequently check for SRCU read-side critical section exits.
Therefore, even if no one is currently in the SRCU read-side critical
section, synchronize_srcu() cannot return quickly.  That's why
unregister_shrinker() has become slower.

We will try to use the refcount+RCU method [2] proposed by Dave Chinner to
continue to re-implement the lockless slab shrink.  So revert the
shrinker_srcu related changes first.

[1]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
[2]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/

Link: https://lkml.kernel.org/r/20230609081518.3039120-5-qi.zheng@linux.dev
Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202305230837.db2c233f-yujie.liu@intel.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/mm/shrinker_debug.c~revert-mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless
+++ a/mm/shrinker_debug.c
@@ -5,12 +5,10 @@
 #include <linux/seq_file.h>
 #include <linux/shrinker.h>
 #include <linux/memcontrol.h>
-#include <linux/srcu.h>
 
 /* defined in vmscan.c */
 extern struct rw_semaphore shrinker_rwsem;
 extern struct list_head shrinker_list;
-extern struct srcu_struct shrinker_srcu;
 
 static DEFINE_IDA(shrinker_debugfs_ida);
 static struct dentry *shrinker_debugfs_root;
@@ -51,13 +49,18 @@ static int shrinker_debugfs_count_show(s
 	struct mem_cgroup *memcg;
 	unsigned long total;
 	bool memcg_aware;
-	int ret = 0, nid, srcu_idx;
+	int ret, nid;
 
 	count_per_node = kcalloc(nr_node_ids, sizeof(unsigned long), GFP_KERNEL);
 	if (!count_per_node)
 		return -ENOMEM;
 
-	srcu_idx = srcu_read_lock(&shrinker_srcu);
+	ret = down_read_killable(&shrinker_rwsem);
+	if (ret) {
+		kfree(count_per_node);
+		return ret;
+	}
+	rcu_read_lock();
 
 	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
 
@@ -88,7 +91,8 @@ static int shrinker_debugfs_count_show(s
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
-	srcu_read_unlock(&shrinker_srcu, srcu_idx);
+	rcu_read_unlock();
+	up_read(&shrinker_rwsem);
 
 	kfree(count_per_node);
 	return ret;
@@ -111,8 +115,9 @@ static ssize_t shrinker_debugfs_scan_wri
 		.gfp_mask = GFP_KERNEL,
 	};
 	struct mem_cgroup *memcg = NULL;
-	int nid, srcu_idx;
+	int nid;
 	char kbuf[72];
+	ssize_t ret;
 
 	read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
 	if (copy_from_user(kbuf, buf, read_len))
@@ -141,7 +146,11 @@ static ssize_t shrinker_debugfs_scan_wri
 		return -EINVAL;
 	}
 
-	srcu_idx = srcu_read_lock(&shrinker_srcu);
+	ret = down_read_killable(&shrinker_rwsem);
+	if (ret) {
+		mem_cgroup_put(memcg);
+		return ret;
+	}
 
 	sc.nid = nid;
 	sc.memcg = memcg;
@@ -150,7 +159,7 @@ static ssize_t shrinker_debugfs_scan_wri
 
 	shrinker->scan_objects(shrinker, &sc);
 
-	srcu_read_unlock(&shrinker_srcu, srcu_idx);
+	up_read(&shrinker_rwsem);
 	mem_cgroup_put(memcg);
 
 	return size;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


