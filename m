Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54302C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhKXAkQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:40:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhKXAkQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:40:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD87F60F6B;
        Wed, 24 Nov 2021 00:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637714227;
        bh=45UM9KM/Phem42SIL05dhDEPp2Yc7eSpX7cNt54ktys=;
        h=Date:From:To:Subject:From;
        b=LQRaiGMvjp89MvqC709fCJPiXd4aO03GQvsqUnSF8rdkta7A42q76mUIXExu7sZS7
         6F9IyDijIK4e5VlVKfiGRgWAUmz6eP86d4AGxwxXVZgGesgM8wMVwSUvCej2IQzB1t
         FgZwzq6TrbyPRy5OJDCfcUhNDfH0RWZm0z3j2Ows=
Date:   Tue, 23 Nov 2021 16:37:06 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, cannonmatthews@google.com,
        joannali@google.com, juew@google.com, linmiaohe@huawei.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, songmuchun@bytedance.com,
        ygyao@google.com
Subject:  + hugetlb-add-hugetlbnuma_stat-file.patch added to -mm
 tree
Message-ID: <20211124003706.A01sQdsRM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add hugetlb.*.numa_stat file
has been added to the -mm tree.  Its filename is
     hugetlb-add-hugetlbnuma_stat-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-hugetlbnuma_stat-=
file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-hugetlbnuma_stat-=
file.patch

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
=46rom: Mina Almasry <almasrymina@google.com>
Subject: hugetlb: add hugetlb.*.numa_stat file

For hugetlb backed jobs/VMs it's critical to understand the numa
information for the memory backing these jobs to deliver optimal
performance.

Currently this technically can be queried from /proc/self/numa_maps, but
there are significant issues with that. Namely:

1. Memory can be mapped or unmapped.

2. numa_maps are per process and need to be aggregated across all
   processes in the cgroup.  For shared memory this is more involved as
   the userspace needs to make sure it doesn't double count shared
   mappings.

3. I believe querying numa_maps needs to hold the mmap_lock which adds
   to the contention on this lock.

For these reasons I propose simply adding hugetlb.*.numa_stat file,
   which shows the numa information of the cgroup similarly to
   memory.numa_stat.

On cgroup-v2:
   cat /sys/fs/cgroup/unified/test/hugetlb.2MB.numa_stat
   total=3D2097152 N0=3D2097152 N1=3D0

On cgroup-v1:
   cat /sys/fs/cgroup/hugetlb/test/hugetlb.2MB.numa_stat
   total=3D2097152 N0=3D2097152 N1=3D0
   hierarichal_total=3D2097152 N0=3D2097152 N1=3D0

This patch was tested manually by allocating hugetlb memory and querying
the hugetlb.*.numa_stat file of the cgroup and its parents.
=EF=BF=BC
Link: https://lkml.kernel.org/r/20211123001020.4083653-1-almasrymina@google=
.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jue Wang <juew@google.com>
Cc: Yang Yao <ygyao@google.com>
Cc: Joanna Li <joannali@google.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/hugetlb.rst |    4=20
 Documentation/admin-guide/cgroup-v2.rst         |    5=20
 include/linux/hugetlb.h                         |    4=20
 include/linux/hugetlb_cgroup.h                  |    7=20
 mm/hugetlb_cgroup.c                             |  133 ++++++++++++--
 5 files changed, 141 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/hugetlb.rst~hugetlb-add-hugetlbnu=
ma_stat-file
+++ a/Documentation/admin-guide/cgroup-v1/hugetlb.rst
@@ -29,12 +29,14 @@ Brief summary of control files::
  hugetlb.<hugepagesize>.max_usage_in_bytes             # show max "hugepag=
esize" hugetlb  usage recorded
  hugetlb.<hugepagesize>.usage_in_bytes                 # show current usag=
e for "hugepagesize" hugetlb
  hugetlb.<hugepagesize>.failcnt                        # show the number o=
f allocation failure due to HugeTLB usage limit
+ hugetlb.<hugepagesize>.numa_stat                      # show the numa inf=
ormation of the hugetlb memory charged to this cgroup
=20
 For a system supporting three hugepage sizes (64k, 32M and 1G), the control
 files include::
=20
   hugetlb.1GB.limit_in_bytes
   hugetlb.1GB.max_usage_in_bytes
+  hugetlb.1GB.numa_stat
   hugetlb.1GB.usage_in_bytes
   hugetlb.1GB.failcnt
   hugetlb.1GB.rsvd.limit_in_bytes
@@ -43,6 +45,7 @@ files include::
   hugetlb.1GB.rsvd.failcnt
   hugetlb.64KB.limit_in_bytes
   hugetlb.64KB.max_usage_in_bytes
+  hugetlb.64KB.numa_stat
   hugetlb.64KB.usage_in_bytes
   hugetlb.64KB.failcnt
   hugetlb.64KB.rsvd.limit_in_bytes
@@ -51,6 +54,7 @@ files include::
   hugetlb.64KB.rsvd.failcnt
   hugetlb.32MB.limit_in_bytes
   hugetlb.32MB.max_usage_in_bytes
+  hugetlb.32MB.numa_stat
   hugetlb.32MB.usage_in_bytes
   hugetlb.32MB.failcnt
   hugetlb.32MB.rsvd.limit_in_bytes
--- a/Documentation/admin-guide/cgroup-v2.rst~hugetlb-add-hugetlbnuma_stat-=
file
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -2260,6 +2260,11 @@ HugeTLB Interface Files
 	are local to the cgroup i.e. not hierarchical. The file modified event
 	generated on this file reflects only the local events.
=20
+  hugetlb.<hugepagesize>.numa_stat
+	Similar to memory.numa_stat, it shows the numa information of the
+        hugetlb pages of <hugepagesize> in this cgroup.  Only active in
+        use hugetlb pages are included.  The per-node values are in bytes.
+
 Misc
 ----
=20
--- a/include/linux/hugetlb_cgroup.h~hugetlb-add-hugetlbnuma_stat-file
+++ a/include/linux/hugetlb_cgroup.h
@@ -36,6 +36,11 @@ enum hugetlb_memory_event {
 	HUGETLB_NR_MEMORY_EVENTS,
 };
=20
+struct hugetlb_cgroup_per_node {
+	/* hugetlb usage in pages over all hstates. */
+	unsigned long usage[HUGE_MAX_HSTATE];
+};
+
 struct hugetlb_cgroup {
 	struct cgroup_subsys_state css;
=20
@@ -57,6 +62,8 @@ struct hugetlb_cgroup {
=20
 	/* Handle for "hugetlb.events.local" */
 	struct cgroup_file events_local_file[HUGE_MAX_HSTATE];
+
+	struct hugetlb_cgroup_per_node *nodeinfo[];
 };
=20
 static inline struct hugetlb_cgroup *
--- a/include/linux/hugetlb.h~hugetlb-add-hugetlbnuma_stat-file
+++ a/include/linux/hugetlb.h
@@ -622,8 +622,8 @@ struct hstate {
 #endif
 #ifdef CONFIG_CGROUP_HUGETLB
 	/* cgroup control files */
-	struct cftype cgroup_files_dfl[7];
-	struct cftype cgroup_files_legacy[9];
+	struct cftype cgroup_files_dfl[8];
+	struct cftype cgroup_files_legacy[10];
 #endif
 	char name[HSTATE_NAME_LEN];
 };
--- a/mm/hugetlb_cgroup.c~hugetlb-add-hugetlbnuma_stat-file
+++ a/mm/hugetlb_cgroup.c
@@ -123,29 +123,58 @@ static void hugetlb_cgroup_init(struct h
 	}
 }
=20
+static void hugetlb_cgroup_free(struct hugetlb_cgroup *h_cgroup)
+{
+	int node;
+
+	for_each_node(node)
+		kfree(h_cgroup->nodeinfo[node]);
+	kfree(h_cgroup);
+}
+
 static struct cgroup_subsys_state *
 hugetlb_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
 	struct hugetlb_cgroup *parent_h_cgroup =3D hugetlb_cgroup_from_css(parent=
_css);
 	struct hugetlb_cgroup *h_cgroup;
+	int node;
+
+	h_cgroup =3D kzalloc(struct_size(h_cgroup, nodeinfo, nr_node_ids),
+			   GFP_KERNEL);
=20
-	h_cgroup =3D kzalloc(sizeof(*h_cgroup), GFP_KERNEL);
 	if (!h_cgroup)
 		return ERR_PTR(-ENOMEM);
=20
 	if (!parent_h_cgroup)
 		root_h_cgroup =3D h_cgroup;
=20
+	/*
+	 * TODO: this routine can waste much memory for nodes which will
+	 * never be onlined. It's better to use memory hotplug callback
+	 * function.
+	 */
+	for_each_node(node) {
+		/* Set node_to_alloc to -1 for offline nodes. */
+		int node_to_alloc =3D
+			node_state(node, N_NORMAL_MEMORY) ? node : -1;
+		h_cgroup->nodeinfo[node] =3D
+			kzalloc_node(sizeof(struct hugetlb_cgroup_per_node),
+				     GFP_KERNEL, node_to_alloc);
+		if (!h_cgroup->nodeinfo[node])
+			goto fail_alloc_nodeinfo;
+	}
+
 	hugetlb_cgroup_init(h_cgroup, parent_h_cgroup);
 	return &h_cgroup->css;
+
+fail_alloc_nodeinfo:
+	hugetlb_cgroup_free(h_cgroup);
+	return ERR_PTR(-ENOMEM);
 }
=20
 static void hugetlb_cgroup_css_free(struct cgroup_subsys_state *css)
 {
-	struct hugetlb_cgroup *h_cgroup;
-
-	h_cgroup =3D hugetlb_cgroup_from_css(css);
-	kfree(h_cgroup);
+	hugetlb_cgroup_free(hugetlb_cgroup_from_css(css));
 }
=20
 /*
@@ -289,7 +318,17 @@ static void __hugetlb_cgroup_commit_char
 		return;
=20
 	__set_hugetlb_cgroup(page, h_cg, rsvd);
-	return;
+	if (!rsvd) {
+		unsigned long usage =3D
+			h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
+		/*
+		 * This write is not atomic due to fetching usage and writing
+		 * to it, but that's fine because we call this with
+		 * hugetlb_lock held anyway.
+		 */
+		WRITE_ONCE(h_cg->nodeinfo[page_to_nid(page)]->usage[idx],
+			   usage + nr_pages);
+	}
 }
=20
 void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
@@ -328,8 +367,17 @@ static void __hugetlb_cgroup_uncharge_pa
=20
 	if (rsvd)
 		css_put(&h_cg->css);
-
-	return;
+	else {
+		unsigned long usage =3D
+			h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
+		/*
+		 * This write is not atomic due to fetching usage and writing
+		 * to it, but that's fine because we call this with
+		 * hugetlb_lock held anyway.
+		 */
+		WRITE_ONCE(h_cg->nodeinfo[page_to_nid(page)]->usage[idx],
+			   usage - nr_pages);
+	}
 }
=20
 void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
@@ -418,6 +466,59 @@ enum {
 	RES_RSVD_FAILCNT,
 };
=20
+static int hugetlb_cgroup_read_numa_stat(struct seq_file *seq, void *dummy)
+{
+	int nid;
+	struct cftype *cft =3D seq_cft(seq);
+	int idx =3D MEMFILE_IDX(cft->private);
+	bool legacy =3D MEMFILE_ATTR(cft->private);
+	struct hugetlb_cgroup *h_cg =3D hugetlb_cgroup_from_css(seq_css(seq));
+	struct cgroup_subsys_state *css;
+	unsigned long usage;
+
+	if (legacy) {
+		/* Add up usage across all nodes for the non-hierarchical total. */
+		usage =3D 0;
+		for_each_node_state(nid, N_MEMORY)
+			usage +=3D READ_ONCE(h_cg->nodeinfo[nid]->usage[idx]);
+		seq_printf(seq, "total=3D%lu", usage * PAGE_SIZE);
+
+		/* Simply print the per-node usage for the non-hierarchical total. */
+		for_each_node_state(nid, N_MEMORY)
+			seq_printf(seq, " N%d=3D%lu", nid,
+				   READ_ONCE(h_cg->nodeinfo[nid]->usage[idx]) *
+					   PAGE_SIZE);
+		seq_putc(seq, '\n');
+	}
+
+	/*
+	 * The hierarchical total is pretty much the value recorded by the
+	 * counter, so use that.
+	 */
+	seq_printf(seq, "%stotal=3D%lu", legacy ? "hierarichal_" : "",
+		   page_counter_read(&h_cg->hugepage[idx]) * PAGE_SIZE);
+
+	/*
+	 * For each node, transverse the css tree to obtain the hierarichal
+	 * node usage.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
+		usage =3D 0;
+		rcu_read_lock();
+		css_for_each_descendant_pre(css, &h_cg->css) {
+			usage +=3D READ_ONCE(hugetlb_cgroup_from_css(css)
+						   ->nodeinfo[nid]
+						   ->usage[idx]);
+		}
+		rcu_read_unlock();
+		seq_printf(seq, " N%d=3D%lu", nid, usage * PAGE_SIZE);
+	}
+
+	seq_putc(seq, '\n');
+
+	return 0;
+}
+
 static u64 hugetlb_cgroup_read_u64(struct cgroup_subsys_state *css,
 				   struct cftype *cft)
 {
@@ -668,8 +769,14 @@ static void __init __hugetlb_cgroup_file
 				    events_local_file[idx]);
 	cft->flags =3D CFTYPE_NOT_ON_ROOT;
=20
-	/* NULL terminate the last cft */
+	/* Add the numa stat file */
 	cft =3D &h->cgroup_files_dfl[6];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
+	cft->seq_show =3D hugetlb_cgroup_read_numa_stat;
+	cft->flags =3D CFTYPE_NOT_ON_ROOT;
+
+	/* NULL terminate the last cft */
+	cft =3D &h->cgroup_files_dfl[7];
 	memset(cft, 0, sizeof(*cft));
=20
 	WARN_ON(cgroup_add_dfl_cftypes(&hugetlb_cgrp_subsys,
@@ -739,8 +846,14 @@ static void __init __hugetlb_cgroup_file
 	cft->write =3D hugetlb_cgroup_reset;
 	cft->read_u64 =3D hugetlb_cgroup_read_u64;
=20
+	/* Add the numa stat file */
+	cft =3D &h->cgroup_files_dfl[8];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
+	cft->private =3D MEMFILE_PRIVATE(idx, 1);
+	cft->seq_show =3D hugetlb_cgroup_read_numa_stat;
+
 	/* NULL terminate the last cft */
-	cft =3D &h->cgroup_files_legacy[8];
+	cft =3D &h->cgroup_files_legacy[9];
 	memset(cft, 0, sizeof(*cft));
=20
 	WARN_ON(cgroup_add_legacy_cftypes(&hugetlb_cgrp_subsys,
_

Patches currently in -mm which might be from almasrymina@google.com are

hugetlb-add-hugetlbnuma_stat-file.patch

