Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105E8C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC1B621D40
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940180;
	bh=EuJ92Y0R6JprhH3Gdg054fayGfDA6jl3ih1CSRvnAbQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JFcbzcALu+k+IsCRIpPMtc3zaLDX4Hx9O6LtupnvnGlzATM4faRA7unAJSlckcxW0
	 b2rWGN+RBfHteRYnXntZRTjxdGvPBj/+eD+vbVGb/wVO5ETzBkcahtfvBivvgl1Sna
	 qZJqReI8RDf2dHKNoWywZLhUAYM4Vw+HyNkckWzU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgILTtj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgILTti (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:49:38 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3AE62087C;
        Sat, 12 Sep 2020 19:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599940178;
        bh=EuJ92Y0R6JprhH3Gdg054fayGfDA6jl3ih1CSRvnAbQ=;
        h=Date:From:To:Subject:From;
        b=jssWOdTMW7fIVtEAN1JfxNQzVaLaI1SVyAzsourVnbS38ESlQ1FvFYxHj3alFJtRR
         olZ0efwS5+rwhgAwiT3bGLcQDyLGNEUydLu2255PhCSzohlvVnm32Axz+sggqO2Db9
         1JnaMjh/1H8R0KAwkshdr/9hZtsi7dtW+du7R1lM=
Date:   Sat, 12 Sep 2020 12:49:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com,
        sjpark@amazon.de, rientjes@google.com, mkoutny@suse.com,
        mhocko@kernel.org, hannes@cmpxchg.org, guro@fb.com,
        gthelen@google.com, shakeelb@google.com
Subject:  + memcg-introduce-per-memcg-reclaim-interface.patch added
 to -mm tree
Message-ID: <20200912194937.taUz1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: introduce per-memcg reclaim interface
has been added to the -mm tree.  Its filename is
     memcg-introduce-per-memcg-reclaim-interface.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-introduce-per-memcg-rec=
laim-interface.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-introduce-per-memcg-rec=
laim-interface.patch

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
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: introduce per-memcg reclaim interface

Introduce an memcg interface to trigger memory reclaim on a memory cgroup.

Use cases:
----------

1) Per-memcg uswapd:

   Usually applications consists of combination of latency sensitive
   and latency tolerant tasks.  For example, tasks serving user requests
   vs tasks doing data backup for a database application.  At the moment
   the kernel does not differentiate between such tasks when the
   application hits the memcg limits.  So, potentially a latency sensitive
   user facing task can get stuck in high reclaim and be throttled by the
   kernel.

   Similarly there are cases of single process applications having two
   set of thread pools where threads from one pool have high scheduling
   priority and low latency requirement.  One concrete example from our
   production is the VMM which have high priority low latency thread pool
   for the VCPUs while separate thread pool for stats reporting, I/O
   emulation, health checks and other managerial operations.  The kernel
   memory reclaim does not differentiate between VCPU thread or a
   non-latency sensitive thread and a VCPU thread can get stuck in high
   reclaim.

   One way to resolve this issue is to preemptively trigger the memory
   reclaim from a latency tolerant task (uswapd) when the application is
   near the limits.  Finding 'near the limits' situation is an orthogonal
   problem.

2) Proactive reclaim:

   This is a similar to the previous use-case, the difference is
   instead of waiting for the application to be near its limit to trigger
   memory reclaim, continuously pressuring the memcg to reclaim a small
   amount of memory.  This gives more accurate and uptodate workingset
   estimation as the LRUs are continuously sorted and can potentially
   provide more deterministic memory overcommit behavior.  The memory
   overcommit controller can provide more proactive response to the
   changing behavior of the running applications instead of being
   reactive.

Benefit of user space solution:
-------------------------------

1) More flexible on who should be charged for the cpu of the memory
   reclaim.  For proactive reclaim, it makes more sense to centralized the
   overhead while for uswapd, it makes more sense for the application to
   pay for the cpu of the memory reclaim.

2) More flexible on dedicating the resources (like cpu).  The memory
   overcommit controller can balance the cost between the cpu usage and
   the memory reclaimed.

3) Provides a way to the applications to keep their LRUs sorted, so,
   under memory pressure better reclaim candidates are selected.  This
   also gives more accurate and uptodate notion of working set for an
   application.

Questions:
----------

1) Why memory.high is not enough?

   memory.high can be used to trigger reclaim in a memcg and can
   potentially be used for proactive reclaim as well as uswapd use cases.=
=20
   However there is a big negative in using memory.high.  It can
   potentially introduce high reclaim stalls in the target application as
   the allocations from the processes or the threads of the application
   can hit the temporary memory.high limit.

   Another issue with memory.high is that it is not delegatable.  To
   actually use this interface for uswapd, the application has to
   introduce another layer of cgroup on whose memory.high it has write
   access.

2) Why uswapd safe from self induced reclaim?

   This is very similar to the scenario of oomd under global memory
   pressure.  We can use the similar mechanisms to protect uswapd from
   self induced reclaim i.e.  memory.min and mlock.

Interface options:
------------------

Introducing a very simple memcg interface 'echo 10M > memory.reclaim' to
trigger reclaim in the target memory cgroup.

In future we might want to reclaim specific type of memory from a memcg,
so, this interface can be extended to allow that. e.g.

$ echo 10M [all|anon|file|kmem] > memory.reclaim

However that should be when we have concrete use-cases for such
functionality. Keep things simple for now.

Link: https://lkml.kernel.org/r/20200909215752.1725525-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Michal Koutn=C3=BD" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    9 +++++
 mm/memcontrol.c                         |   37 ++++++++++++++++++++++
 2 files changed, 46 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-introduce-per-memcg-rec=
laim-interface
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1181,6 +1181,15 @@ PAGE_SIZE multiple when read back.
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
=20
+  memory.reclaim
+	A write-only file which exists on non-root cgroups.
+
+	This is a simple interface to trigger memory reclaim in the
+	target cgroup. Write the number of bytes to reclaim to this
+	file and the kernel will try to reclaim that much memory.
+	Please note that the kernel can over or under reclaim from
+	the target cgroup.
+
   memory.oom.group
 	A read-write single value file which exists on non-root
 	cgroups.  The default value is "0".
--- a/mm/memcontrol.c~memcg-introduce-per-memcg-reclaim-interface
+++ a/mm/memcontrol.c
@@ -6423,6 +6423,38 @@ static ssize_t memory_oom_group_write(st
 	return nbytes;
 }
=20
+static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
+			      size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg =3D mem_cgroup_from_css(of_css(of));
+	unsigned int nr_retries =3D MAX_RECLAIM_RETRIES;
+	unsigned long nr_to_reclaim, nr_reclaimed =3D 0;
+	int err;
+
+	buf =3D strstrip(buf);
+	err =3D page_counter_memparse(buf, "", &nr_to_reclaim);
+	if (err)
+		return err;
+
+	while (nr_reclaimed < nr_to_reclaim) {
+		unsigned long reclaimed;
+
+		if (signal_pending(current))
+			break;
+
+		reclaimed =3D try_to_free_mem_cgroup_pages(memcg,
+						nr_to_reclaim - nr_reclaimed,
+						GFP_KERNEL, true);
+
+		if (!reclaimed && !nr_retries--)
+			break;
+
+		nr_reclaimed +=3D reclaimed;
+	}
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] =3D {
 	{
 		.name =3D "current",
@@ -6475,6 +6507,11 @@ static struct cftype memory_files[] =3D {
 		.seq_show =3D memory_oom_group_show,
 		.write =3D memory_oom_group_write,
 	},
+	{
+		.name =3D "reclaim",
+		.flags =3D CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
+		.write =3D memory_reclaim,
+	},
 	{ }	/* terminate */
 };
=20
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-introduce-per-memcg-reclaim-interface.patch

