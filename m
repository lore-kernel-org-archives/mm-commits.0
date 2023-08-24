Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29115C727BD
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244132AbjHXXWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244107AbjHXXWD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8FEA1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 337C165533
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C4DC433C8;
        Thu, 24 Aug 2023 23:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919320;
        bh=7FtZPZKXz+inh+cDpy52qkz699f4UIGChF89eOq7yRg=;
        h=Date:To:From:Subject:From;
        b=Npv1ZqO13P3HjAeC14xdpJVLChfQh+X0hGAovOpI4HfnLV3mG7HikhxO7bTdSF/Sj
         OUiAZwb+ib4JfHPBFMphVVkQBzOQz4FIs01FAh5bSDoh1DUUC/PKMGn5WfNt09CPwV
         d2fzeIH/Z6pTDFN7spJ6c/JYVsGazb0+70B53j4g=
Date:   Thu, 24 Aug 2023 16:21:59 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, lkarpins@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-fix-test_kmem_memcg_deletion-kernel-mem-check.patch removed from -mm tree
Message-Id: <20230824232200.83C4DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: fix test_kmem_memcg_deletion kernel mem check
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-test_kmem_memcg_deletion-kernel-mem-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lucas Karpinski <lkarpins@redhat.com>
Subject: selftests: cgroup: fix test_kmem_memcg_deletion kernel mem check
Date: Thu, 17 Aug 2023 15:57:48 -0400

Currently, not all kernel memory usage is being accounted for. This
commit switches to using the kernel entry within memory.stat which
already includes kernel_stack, pagetables, and slab. The kernel entry
also includes vmalloc and other additional kernel memory use cases which
were missing.

Link: https://lkml.kernel.org/r/bvrhe2tpsts2azaroq4ubp2slawmop6orndsswrewuscw3ugvk@kmemmrttsnc7
Signed-off-by: Lucas Karpinski <lkarpins@redhat.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |   21 ++++++-------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~selftests-cgroup-fix-test_kmem_memcg_deletion-kernel-mem-check
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -162,11 +162,11 @@ static int cg_run_in_subcgroups(const ch
  * allocates some slab memory (mostly negative dentries) using 2 * NR_CPUS
  * threads. Then it checks the sanity of numbers on the parent level:
  * the total size of the cgroups should be roughly equal to
- * anon + file + slab + kernel_stack.
+ * anon + file + kernel + sock.
  */
 static int test_kmem_memcg_deletion(const char *root)
 {
-	long current, slab, anon, file, kernel_stack, pagetables, percpu, sock, sum;
+	long current, anon, file, kernel, sock, sum;
 	int ret = KSFT_FAIL;
 	char *parent;
 
@@ -184,29 +184,22 @@ static int test_kmem_memcg_deletion(cons
 		goto cleanup;
 
 	current = cg_read_long(parent, "memory.current");
-	slab = cg_read_key_long(parent, "memory.stat", "slab ");
 	anon = cg_read_key_long(parent, "memory.stat", "anon ");
 	file = cg_read_key_long(parent, "memory.stat", "file ");
-	kernel_stack = cg_read_key_long(parent, "memory.stat", "kernel_stack ");
-	pagetables = cg_read_key_long(parent, "memory.stat", "pagetables ");
-	percpu = cg_read_key_long(parent, "memory.stat", "percpu ");
+	kernel = cg_read_key_long(parent, "memory.stat", "kernel ");
 	sock = cg_read_key_long(parent, "memory.stat", "sock ");
-	if (current < 0 || slab < 0 || anon < 0 || file < 0 ||
-	    kernel_stack < 0 || pagetables < 0 || percpu < 0 || sock < 0)
+	if (current < 0 || anon < 0 || file < 0 || kernel < 0 || sock < 0)
 		goto cleanup;
 
-	sum = slab + anon + file + kernel_stack + pagetables + percpu + sock;
+	sum = anon + file + kernel + sock;
 	if (abs(sum - current) < MAX_VMSTAT_ERROR) {
 		ret = KSFT_PASS;
 	} else {
 		printf("memory.current = %ld\n", current);
-		printf("slab + anon + file + kernel_stack = %ld\n", sum);
-		printf("slab = %ld\n", slab);
+		printf("anon + file + kernel + sock = %ld\n", sum);
 		printf("anon = %ld\n", anon);
 		printf("file = %ld\n", file);
-		printf("kernel_stack = %ld\n", kernel_stack);
-		printf("pagetables = %ld\n", pagetables);
-		printf("percpu = %ld\n", percpu);
+		printf("kernel = %ld\n", kernel);
 		printf("sock = %ld\n", sock);
 	}
 
_

Patches currently in -mm which might be from lkarpins@redhat.com are


