Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5532CC433E9
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33D61652AD
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhCHXI6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231292AbhCHXIh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 18:08:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FE566529C;
        Mon,  8 Mar 2021 23:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615244917;
        bh=+dNArH44qJ7PF6x9jHxxnKTJS+yb2XMmVz+WY/Sfa6M=;
        h=Date:From:To:Subject:From;
        b=vxzBbdefpGdA7pZnHpMxcGBakC9RZNpuFwLzhbPwZj93OS9z5VKY2+kIiFIZcIyUL
         ox/4q/n2/ukA/GY/9dIMdrcqutVTuNLZ4dBQFnukta8atcsJVtRgjDNffwL8u78BtR
         GzbjL1BOmgogkKYTn3ukDPgX40pE/d33b9oFMQB0=
Date:   Mon, 08 Mar 2021 15:08:36 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  +
 kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch
 added to -mm tree
Message-ID: <20210308230836.fljtQ35nb%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kselftests-cgroup-update-kmem=
-test-for-new-vmstat-implementation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kselftests-cgroup-update-kmem=
-test-for-new-vmstat-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

