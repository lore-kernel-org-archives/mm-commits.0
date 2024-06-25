Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA01144D20
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291703; cv=none; b=DaeTsPg3ot+LLrMyzfwCl3/lCvOVAuxkak/NTvH49fpRAftqKS0vAOM0jy74PPrwBUQ2LOwtAxk5a4g2nQt4HVTupLCmtsvYjEdvW56yCTVNNWHMqoz7x0Y/1mfJiRZy4DlRCbtEZvnhGWutONRvWccU5J9vIl4M5H80vQXfGsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291703; c=relaxed/simple;
	bh=IKkZuGjJO6jeQjdrZZCNThYQkKuWdL+Ka30j/E56aFY=;
	h=Date:To:From:Subject:Message-Id; b=HgI0LzcFLXP0Tj21EaFdPgtZvDPMc9j50VKuR0nZ2C73kDvlal7zweK4vhY9K162MOi3+p9JS8DJW2LWUIWYUE71R3Morx+JI0f9mO4ERF7MI8Prcn2fOt7UuEHG3/Aa0GBfjAoDHYGsmXsrSa6DJJ6CZpApEYTT9Y8MDN6lTOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AILNS5D3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AILNS5D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029D7C32782;
	Tue, 25 Jun 2024 05:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291703;
	bh=IKkZuGjJO6jeQjdrZZCNThYQkKuWdL+Ka30j/E56aFY=;
	h=Date:To:From:Subject:From;
	b=AILNS5D3Ea+bR1NZETiP6VAM3ujL/CLM6QTm3PgBnbajtB5fb0zbsrtveCX6ssFqS
	 LZLo9lWMG7zcB0lkOtAY8Zsd2zUv+gDlhCXEqsWWIVwziHCHZWW4Q2xFXgObRP0tPS
	 9bCzCA/tFm2b9Vxv5fAkMUru3bdPf7pO2sOkhRYY=
Date: Mon, 24 Jun 2024 22:01:42 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-switch-to-the-new-cftypes.patch removed from -mm tree
Message-Id: <20240625050143.029D7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: switch to the new cftypes
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-switch-to-the-new-cftypes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/hugetlb_cgroup: switch to the new cftypes
Date: Wed, 12 Jun 2024 09:24:09 +0000

The previous patch has already reconstructed the cftype attributes based
on the templates and saved them in dfl_cftypes and legacy_cftypes.  then
remove the old procedure and switch to the new cftypes.

Link: https://lkml.kernel.org/r/20240612092409.2027592-4-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 -
 mm/hugetlb_cgroup.c     |  163 +++-----------------------------------
 2 files changed, 17 insertions(+), 151 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb_cgroup-switch-to-the-new-cftypes
+++ a/include/linux/hugetlb.h
@@ -686,11 +686,6 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
-#ifdef CONFIG_CGROUP_HUGETLB
-	/* cgroup control files */
-	struct cftype cgroup_files_dfl[8];
-	struct cftype cgroup_files_legacy[10];
-#endif
 	char name[HSTATE_NAME_LEN];
 };
 
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-switch-to-the-new-cftypes
+++ a/mm/hugetlb_cgroup.c
@@ -841,164 +841,26 @@ hugetlb_cgroup_cfttypes_init(struct hsta
 	}
 }
 
-static void __init __hugetlb_cgroup_file_dfl_init(int idx)
+static void __init __hugetlb_cgroup_file_dfl_init(struct hstate *h)
 {
-	char buf[32];
-	struct cftype *cft;
-	struct hstate *h = &hstates[idx];
+	int idx = hstate_index(h);
 
 	hugetlb_cgroup_cfttypes_init(h, dfl_files + idx * DFL_TMPL_SIZE,
 				     hugetlb_dfl_tmpl, DFL_TMPL_SIZE);
-
-	/* format the size */
-	mem_fmt(buf, sizeof(buf), huge_page_size(h));
-
-	/* Add the limit file */
-	cft = &h->cgroup_files_dfl[0];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_LIMIT);
-	cft->seq_show = hugetlb_cgroup_read_u64_max;
-	cft->write = hugetlb_cgroup_write_dfl;
-	cft->flags = CFTYPE_NOT_ON_ROOT;
-
-	/* Add the reservation limit file */
-	cft = &h->cgroup_files_dfl[1];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.max", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_LIMIT);
-	cft->seq_show = hugetlb_cgroup_read_u64_max;
-	cft->write = hugetlb_cgroup_write_dfl;
-	cft->flags = CFTYPE_NOT_ON_ROOT;
-
-	/* Add the current usage file */
-	cft = &h->cgroup_files_dfl[2];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.current", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
-	cft->seq_show = hugetlb_cgroup_read_u64_max;
-	cft->flags = CFTYPE_NOT_ON_ROOT;
-
-	/* Add the current reservation usage file */
-	cft = &h->cgroup_files_dfl[3];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.current", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_USAGE);
-	cft->seq_show = hugetlb_cgroup_read_u64_max;
-	cft->flags = CFTYPE_NOT_ON_ROOT;
-
-	/* Add the events file */
-	cft = &h->cgroup_files_dfl[4];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events", buf);
-	cft->private = MEMFILE_PRIVATE(idx, 0);
-	cft->seq_show = hugetlb_events_show;
-	cft->file_offset = offsetof(struct hugetlb_cgroup, events_file[idx]);
-	cft->flags = CFTYPE_NOT_ON_ROOT;
-
-	/* Add the events.local file */
-	cft = &h->cgroup_files_dfl[5];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events.local", buf);
-	cft->private = MEMFILE_PRIVATE(idx, 0);
-	cft->seq_show = hugetlb_events_local_show;
-	cft->file_offset = offsetof(struct hugetlb_cgroup,
-				    events_local_file[idx]);
-	cft->flags = CFTYPE_NOT_ON_ROOT;
-
-	/* Add the numa stat file */
-	cft = &h->cgroup_files_dfl[6];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
-	cft->private = MEMFILE_PRIVATE(idx, 0);
-	cft->seq_show = hugetlb_cgroup_read_numa_stat;
-	cft->flags = CFTYPE_NOT_ON_ROOT;
-
-	/* NULL terminate the last cft */
-	cft = &h->cgroup_files_dfl[7];
-	memset(cft, 0, sizeof(*cft));
-
-	WARN_ON(cgroup_add_dfl_cftypes(&hugetlb_cgrp_subsys,
-				       h->cgroup_files_dfl));
 }
 
-static void __init __hugetlb_cgroup_file_legacy_init(int idx)
+static void __init __hugetlb_cgroup_file_legacy_init(struct hstate *h)
 {
-	char buf[32];
-	struct cftype *cft;
-	struct hstate *h = &hstates[idx];
+	int idx = hstate_index(h);
 
 	hugetlb_cgroup_cfttypes_init(h, legacy_files + idx * LEGACY_TMPL_SIZE,
 				     hugetlb_legacy_tmpl, LEGACY_TMPL_SIZE);
-
-	/* format the size */
-	mem_fmt(buf, sizeof(buf), huge_page_size(h));
-
-	/* Add the limit file */
-	cft = &h->cgroup_files_legacy[0];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.limit_in_bytes", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_LIMIT);
-	cft->read_u64 = hugetlb_cgroup_read_u64;
-	cft->write = hugetlb_cgroup_write_legacy;
-
-	/* Add the reservation limit file */
-	cft = &h->cgroup_files_legacy[1];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.limit_in_bytes", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_LIMIT);
-	cft->read_u64 = hugetlb_cgroup_read_u64;
-	cft->write = hugetlb_cgroup_write_legacy;
-
-	/* Add the usage file */
-	cft = &h->cgroup_files_legacy[2];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.usage_in_bytes", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
-	cft->read_u64 = hugetlb_cgroup_read_u64;
-
-	/* Add the reservation usage file */
-	cft = &h->cgroup_files_legacy[3];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.usage_in_bytes", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_USAGE);
-	cft->read_u64 = hugetlb_cgroup_read_u64;
-
-	/* Add the MAX usage file */
-	cft = &h->cgroup_files_legacy[4];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max_usage_in_bytes", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_MAX_USAGE);
-	cft->write = hugetlb_cgroup_reset;
-	cft->read_u64 = hugetlb_cgroup_read_u64;
-
-	/* Add the MAX reservation usage file */
-	cft = &h->cgroup_files_legacy[5];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.max_usage_in_bytes", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_MAX_USAGE);
-	cft->write = hugetlb_cgroup_reset;
-	cft->read_u64 = hugetlb_cgroup_read_u64;
-
-	/* Add the failcntfile */
-	cft = &h->cgroup_files_legacy[6];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.failcnt", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_FAILCNT);
-	cft->write = hugetlb_cgroup_reset;
-	cft->read_u64 = hugetlb_cgroup_read_u64;
-
-	/* Add the reservation failcntfile */
-	cft = &h->cgroup_files_legacy[7];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.failcnt", buf);
-	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_FAILCNT);
-	cft->write = hugetlb_cgroup_reset;
-	cft->read_u64 = hugetlb_cgroup_read_u64;
-
-	/* Add the numa stat file */
-	cft = &h->cgroup_files_legacy[8];
-	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
-	cft->private = MEMFILE_PRIVATE(idx, 0);
-	cft->seq_show = hugetlb_cgroup_read_numa_stat;
-
-	/* NULL terminate the last cft */
-	cft = &h->cgroup_files_legacy[9];
-	memset(cft, 0, sizeof(*cft));
-
-	WARN_ON(cgroup_add_legacy_cftypes(&hugetlb_cgrp_subsys,
-					  h->cgroup_files_legacy));
 }
 
-static void __init __hugetlb_cgroup_file_init(int idx)
+static void __init __hugetlb_cgroup_file_init(struct hstate *h)
 {
-	__hugetlb_cgroup_file_dfl_init(idx);
-	__hugetlb_cgroup_file_legacy_init(idx);
+	__hugetlb_cgroup_file_dfl_init(h);
+	__hugetlb_cgroup_file_legacy_init(h);
 }
 
 static void __init __hugetlb_cgroup_file_pre_init(void)
@@ -1013,13 +875,22 @@ static void __init __hugetlb_cgroup_file
 	BUG_ON(!legacy_files);
 }
 
+static void __init __hugetlb_cgroup_file_post_init(void)
+{
+	WARN_ON(cgroup_add_dfl_cftypes(&hugetlb_cgrp_subsys,
+				       dfl_files));
+	WARN_ON(cgroup_add_legacy_cftypes(&hugetlb_cgrp_subsys,
+					  legacy_files));
+}
+
 void __init hugetlb_cgroup_file_init(void)
 {
 	struct hstate *h;
 
 	__hugetlb_cgroup_file_pre_init();
 	for_each_hstate(h)
-		__hugetlb_cgroup_file_init(hstate_index(h));
+		__hugetlb_cgroup_file_init(h);
+	__hugetlb_cgroup_file_post_init();
 }
 
 /*
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


