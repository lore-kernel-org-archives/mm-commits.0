Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A04C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB7A6141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEHWmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWmV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E0BE6140E;
        Sat,  8 May 2021 22:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513678;
        bh=nQlyz32QkN2Qd6JsaB3u08U6n//aAEE0KoUcKTe4Nhg=;
        h=Date:From:To:Subject:From;
        b=VSuar1ji9cKAcJcBpF4cPhuiNWIcL4Ph4Y1arY5QEeN18oj+trIiZ46PLx8xa94JR
         kRYiw9apu8H21zBFhccZrotm+H5nb/55q+TNi/ofwF467LwZrIuKChGnzPRmTJPkyc
         k5X5y17/dg3AOCDwd+vU7erf1SwFVUZa4RL8u2MA=
Date:   Sat, 08 May 2021 15:41:18 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  [merged]
 kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch
 removed from -mm tree
Message-ID: <20210508224118.PhSt6lIIw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftests: cgroup: update kmem test for new vmstat implement=
ation
has been removed from the -mm tree.  Its filename was
     kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: kselftests: cgroup: update kmem test for new vmstat implementation

With memcg having switched to rstat, memory.stat output is precise.=20
Update the cgroup selftest to reflect the expectations and error
tolerances of the new implementation.

Also add newly tracked types of memory to the memory.stat side of the
equation, since they're included in memory.current and could throw false
positives.

Link: https://lkml.kernel.org/r/20210209163304.77088-9-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |   22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~kselftests-cgroup-update-k=
mem-test-for-new-vmstat-implementation
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -19,12 +19,12 @@
=20
=20
 /*
- * Memory cgroup charging and vmstat data aggregation is performed using
- * percpu batches 32 pages big (look at MEMCG_CHARGE_BATCH). So the maximum
- * discrepancy between charge and vmstat entries is number of cpus multipl=
ied
- * by 32 pages multiplied by 2.
+ * Memory cgroup charging is performed using percpu batches 32 pages
+ * big (look at MEMCG_CHARGE_BATCH), whereas memory.stat is exact. So
+ * the maximum discrepancy between charge and vmstat entries is number
+ * of cpus multiplied by 32 pages.
  */
-#define MAX_VMSTAT_ERROR (4096 * 32 * 2 * get_nprocs())
+#define MAX_VMSTAT_ERROR (4096 * 32 * get_nprocs())
=20
=20
 static int alloc_dcache(const char *cgroup, void *arg)
@@ -162,7 +162,7 @@ static int cg_run_in_subcgroups(const ch
  */
 static int test_kmem_memcg_deletion(const char *root)
 {
-	long current, slab, anon, file, kernel_stack, sum;
+	long current, slab, anon, file, kernel_stack, pagetables, percpu, sock, s=
um;
 	int ret =3D KSFT_FAIL;
 	char *parent;
=20
@@ -184,11 +184,14 @@ static int test_kmem_memcg_deletion(cons
 	anon =3D cg_read_key_long(parent, "memory.stat", "anon ");
 	file =3D cg_read_key_long(parent, "memory.stat", "file ");
 	kernel_stack =3D cg_read_key_long(parent, "memory.stat", "kernel_stack ");
+	pagetables =3D cg_read_key_long(parent, "memory.stat", "pagetables ");
+	percpu =3D cg_read_key_long(parent, "memory.stat", "percpu ");
+	sock =3D cg_read_key_long(parent, "memory.stat", "sock ");
 	if (current < 0 || slab < 0 || anon < 0 || file < 0 ||
-	    kernel_stack < 0)
+	    kernel_stack < 0 || pagetables < 0 || percpu < 0 || sock < 0)
 		goto cleanup;
=20
-	sum =3D slab + anon + file + kernel_stack;
+	sum =3D slab + anon + file + kernel_stack + pagetables + percpu + sock;
 	if (abs(sum - current) < MAX_VMSTAT_ERROR) {
 		ret =3D KSFT_PASS;
 	} else {
@@ -198,6 +201,9 @@ static int test_kmem_memcg_deletion(cons
 		printf("anon =3D %ld\n", anon);
 		printf("file =3D %ld\n", file);
 		printf("kernel_stack =3D %ld\n", kernel_stack);
+		printf("pagetables =3D %ld\n", pagetables);
+		printf("percpu =3D %ld\n", percpu);
+		printf("sock =3D %ld\n", sock);
 	}
=20
 cleanup:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


