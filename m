Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524B0C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B5A1610FC
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhD3F5X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3F5W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D64B61463;
        Fri, 30 Apr 2021 05:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762193;
        bh=Wupyuqbiw3faLxxVW9HL3RjxtvDbi0KvXQVzBauljfU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EWTheZe/QFv41JkzgYBr2kSsTKjm0+dbM0q9JhX0ADTwB5yMZfWBKSwKOaCH0q8mp
         5zU8bJTvCGr7IlVTN025RrzPo2Lw0+ZgPXvt+gvC99vQnbqskpPphDKwlisMEUQQ98
         8C9f3+TsczRD4A2LYatTzfX0ywnvMpkFeRKRZoiw=
Date:   Thu, 29 Apr 2021 22:56:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 066/178] kselftests: cgroup: update kmem test for
 new vmstat implementation
Message-ID: <20210430055633.0loZ7aZwY%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
