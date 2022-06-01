Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7FBC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 21:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiFAV1m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 17:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiFAV1m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 17:27:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D5F5FF35
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 14:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B59D66132A
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 21:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1FEC385A5;
        Wed,  1 Jun 2022 21:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654118860;
        bh=/5vU92x2fpSt1HYH/sQGSi/gB2QzP+2EQ0HrQ8LlUgo=;
        h=Date:To:From:Subject:From;
        b=ug6zosbY1193mxNDFiMLAZhO3b+OK+uafmbZulWmICSAK3saWP6h/MomuNXsI47qd
         TcwMee06+l/PN1Wy29QIKSgqgL9r4mgYDwc7b1Vs9476jRSRpmcPRfflgVheIIZ+yp
         BWi6qla5GYCb6mPZvZe34t98JeKkCzPavD+WBuwk=
Date:   Wed, 01 Jun 2022 14:27:39 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        kent.overstreet@gmail.com, hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch added to mm-unstable branch
Message-Id: <20220601212740.0A1FEC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: introduce mem_cgroup_ino() and mem_cgroup_get_from_ino()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcontrol: introduce mem_cgroup_ino() and mem_cgroup_get_from_ino()
Date: Tue, 31 May 2022 20:22:22 -0700

Patch series "mm: introduce shrinker debugfs interface", v5.

The only existing debugging mechanism is a couple of tracepoints in
do_shrink_slab(): mm_shrink_slab_start and mm_shrink_slab_end.  They
aren't covering everything though: shrinkers which report 0 objects will
never show up, there is no support for memcg-aware shrinkers.  Shrinkers
are identified by their scan function, which is not always enough (e.g. 
hard to guess which super block's shrinker it is having only
"super_cache_scan").

To provide a better visibility and debug options for memory shrinkers this
patchset introduces a /sys/kernel/debug/shrinker interface, to some extent
similar to /sys/kernel/slab.

For each shrinker registered in the system a directory is created.  As
now, the directory will contain only a "scan" file, which allows to get
the number of managed objects for each memory cgroup (for memcg-aware
shrinkers) and each numa node (for numa-aware shrinkers on a numa
machine).  Other interfaces might be added in the future.

To make debugging more pleasant, the patchset also names all shrinkers, so
that debugfs entries can have meaningful names.


This patch (of 5):

Shrinker debugfs requires a way to represent memory cgroups without using
full paths, both for displaying information and getting input from a user.

Cgroup inode number is a perfect way, already used by bpf.

This commit adds a couple of helper functions which will be used to handle
memcg-aware shrinkers.

Link: https://lkml.kernel.org/r/20220601032227.4076670-1-roman.gushchin@linux.dev
Link: https://lkml.kernel.org/r/20220601032227.4076670-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   21 +++++++++++++++++++++
 mm/memcontrol.c            |   23 +++++++++++++++++++++++
 2 files changed, 44 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino
+++ a/include/linux/memcontrol.h
@@ -837,6 +837,15 @@ static inline unsigned short mem_cgroup_
 }
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
 
+#ifdef CONFIG_SHRINKER_DEBUG
+static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
+{
+	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
+}
+
+struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
+#endif
+
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
 	return mem_cgroup_from_css(seq_css(m));
@@ -1343,6 +1352,18 @@ static inline struct mem_cgroup *mem_cgr
 	return NULL;
 }
 
+#ifdef CONFIG_SHRINKER_DEBUG
+static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
+{
+	return 0;
+}
+
+static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
+{
+	return NULL;
+}
+#endif
+
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
 	return NULL;
--- a/mm/memcontrol.c~mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino
+++ a/mm/memcontrol.c
@@ -5060,6 +5060,29 @@ struct mem_cgroup *mem_cgroup_from_id(un
 	return idr_find(&mem_cgroup_idr, id);
 }
 
+#ifdef CONFIG_SHRINKER_DEBUG
+struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
+{
+	struct cgroup *cgrp;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+
+	cgrp = cgroup_get_from_id(ino);
+	if (!cgrp)
+		return ERR_PTR(-ENOENT);
+
+	css = cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
+	if (css)
+		memcg = container_of(css, struct mem_cgroup, css);
+	else
+		memcg = ERR_PTR(-ENOENT);
+
+	cgroup_put(cgrp);
+
+	return memcg;
+}
+#endif
+
 static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch
mm-shrinkers-provide-shrinkers-with-names.patch
mm-docs-document-shrinker-debugfs.patch
tools-add-memcg_shrinkerpy.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch

