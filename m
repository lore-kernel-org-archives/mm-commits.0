Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F8AC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83E42206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195831;
	bh=p39MursnYxJL8f1g5K/mMsUF6WJjtDF5/YuFTUwuFvU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=vPi1OA/OWowluQu7mc4iKmp3G8kDnG6CcJyrqKTo8a7mkIzQIG+96AXJcYCGHUDZZ
	 z3oBIZNcMuR+gPW9Ehf0kuF3kIiy5dzalKR7UWTXW5SV/O3bDzKLmgUoM1lh0O8W+F
	 2nt14NdL/KXvD6Un/ij2OcuuVFVfo+1kgxqLy93M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLBab (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBab (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:30:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD0F207F7;
        Wed, 12 Aug 2020 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195830;
        bh=p39MursnYxJL8f1g5K/mMsUF6WJjtDF5/YuFTUwuFvU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OhTABckLonHgwyX6kijgr+HGY6IUQCQLbAsfcAX2ydgxN1HOK/vVNcnlf/UxR36Qw
         yPFLi5+lpyuioRr31ahaSGn76Ca58/Hv+tYbZyPpKAGbKKihRkj57oJExr8MYNIFQR
         Daxu661Uc1Q/tNasP+KF/sl5kjQV3haf53QGaXl4=
Date:   Tue, 11 Aug 2020 18:30:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, cuibixuan@huawei.com,
        dennis@kernel.org, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, longman@redhat.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        tj@kernel.org, tobin@kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 005/165] kselftests: cgroup: add perpcu memory
 accounting test
Message-ID: <20200812013029.07YGogvMl%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Roman Gushchin <guro@fb.com>
Subject: kselftests: cgroup: add perpcu memory accounting test

Add a simple test to check the percpu memory accounting.  The test creates
a cgroup tree with 1000 child cgroups and checks values of memory.current
and memory.stat::percpu.

Link: http://lkml.kernel.org/r/20200608230819.832349-6-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Bixuan Cui <cuibixuan@huawei.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |   70 ++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~kselftests-cgroup-add-perp=
cu-memory-accounting-test
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -18,6 +18,15 @@
 #include "cgroup_util.h"
=20
=20
+/*
+ * Memory cgroup charging and vmstat data aggregation is performed using
+ * percpu batches 32 pages big (look at MEMCG_CHARGE_BATCH). So the maximum
+ * discrepancy between charge and vmstat entries is number of cpus multipl=
ied
+ * by 32 pages multiplied by 2.
+ */
+#define MAX_VMSTAT_ERROR (4096 * 32 * 2 * get_nprocs())
+
+
 static int alloc_dcache(const char *cgroup, void *arg)
 {
 	unsigned long i;
@@ -180,7 +189,7 @@ static int test_kmem_memcg_deletion(cons
 		goto cleanup;
=20
 	sum =3D slab + anon + file + kernel_stack;
-	if (abs(sum - current) < 4096 * 32 * 2 * get_nprocs()) {
+	if (abs(sum - current) < MAX_VMSTAT_ERROR) {
 		ret =3D KSFT_PASS;
 	} else {
 		printf("memory.current =3D %ld\n", current);
@@ -331,6 +340,64 @@ cleanup:
 	return ret;
 }
=20
+/*
+ * This test creates a sub-tree with 1000 memory cgroups.
+ * Then it checks that the memory.current on the parent level
+ * is greater than 0 and approximates matches the percpu value
+ * from memory.stat.
+ */
+static int test_percpu_basic(const char *root)
+{
+	int ret =3D KSFT_FAIL;
+	char *parent, *child;
+	long current, percpu;
+	int i;
+
+	parent =3D cg_name(root, "percpu_basic_test");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup;
+
+	for (i =3D 0; i < 1000; i++) {
+		child =3D cg_name_indexed(parent, "child", i);
+		if (!child)
+			return -1;
+
+		if (cg_create(child))
+			goto cleanup_children;
+
+		free(child);
+	}
+
+	current =3D cg_read_long(parent, "memory.current");
+	percpu =3D cg_read_key_long(parent, "memory.stat", "percpu ");
+
+	if (current > 0 && percpu > 0 && abs(current - percpu) <
+	    MAX_VMSTAT_ERROR)
+		ret =3D KSFT_PASS;
+	else
+		printf("memory.current %ld\npercpu %ld\n",
+		       current, percpu);
+
+cleanup_children:
+	for (i =3D 0; i < 1000; i++) {
+		child =3D cg_name_indexed(parent, "child", i);
+		cg_destroy(child);
+		free(child);
+	}
+
+cleanup:
+	cg_destroy(parent);
+	free(parent);
+
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct kmem_test {
 	int (*fn)(const char *root);
@@ -341,6 +408,7 @@ struct kmem_test {
 	T(test_kmem_proc_kpagecgroup),
 	T(test_kmem_kernel_stacks),
 	T(test_kmem_dead_cgroups),
+	T(test_percpu_basic),
 };
 #undef T
=20
_
