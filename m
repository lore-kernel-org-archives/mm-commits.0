Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE408289C
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 18:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718217237; cv=none; b=rYjuCoolTdhS0GJObjc+ulbnrh7KQgFa0h7w7hQtomkRQ994q56cNFVpuZ6kDsJ7EE0DU6bhct4pUHQQAJzV48kUl4qxQEgmnqBGeQAK8ee4mnTkFd9x1lOfd7C7SP4TTyoVSGpTTCGAdh52Kf7aehC82iZkiHPsmcMbriWxBpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718217237; c=relaxed/simple;
	bh=feBGzdu1zWBY1Bt9WInS2K2/6xMQyQa7nNaf+sl3LD4=;
	h=Date:To:From:Subject:Message-Id; b=BhfwUoYZ746ELBrGzb4ylZa52+AhIbHvPAtxpZEg/iiNXyadoB3raqnNl2lsT4Q6qniMG7935hoT5CGnbj7U8i37EIBxRDLRwYHl6qHaTOXT4SNxTTK7nLoKQpbMShj8NQhukZOlLA34eyEiWddRf0usXX6CX/mmE4mQCfW9fmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q5msfjEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q5msfjEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CE1C32786;
	Wed, 12 Jun 2024 18:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718217236;
	bh=feBGzdu1zWBY1Bt9WInS2K2/6xMQyQa7nNaf+sl3LD4=;
	h=Date:To:From:Subject:From;
	b=q5msfjElgymInpvluSliMmlBNTJtTt8P2bEcWDks/EKToNO2pyHvhtCEZcu9oRU1s
	 kzUejzpVhcp/7LyGtt4X1U+ZvrrDYmrSiQ0VIX3phZc+AZDb6xJu8u7q/9iF5ZnZn5
	 T81E4LAmvLm3jVkL4PxftCwt2ZBPzABpmCwqV8Jw=
Date: Wed, 12 Jun 2024 11:33:56 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-prepare-cftypes-based-on-template.patch added to mm-unstable branch
Message-Id: <20240612183356.94CE1C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cgroup: prepare cftypes based on template
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-prepare-cftypes-based-on-template.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-prepare-cftypes-based-on-template.patch

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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/hugetlb_cgroup: prepare cftypes based on template
Date: Wed, 12 Jun 2024 09:24:08 +0000

Unlike other cgroup subsystems, the hugetlb cgroup does not provide a
static array of cftype that explicitly displays the properties, handling
functions, etc., of each file.  Instead, it dynamically creates the
attribute of cftypes based on the hstate during the startup procedure. 
This reduces the readability of the code.

To fix this issue, introduce two templates of cftypes, and rebuild the
attributes according to the hstate to make it ready to be added to cgroup
framework.

Link: https://lkml.kernel.org/r/20240612092409.2027592-3-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |  156 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-prepare-cftypes-based-on-template
+++ a/mm/hugetlb_cgroup.c
@@ -27,7 +27,17 @@
 #define MEMFILE_IDX(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 
+/* Use t->m[0] to encode the offset */
+#define MEMFILE_OFFSET(t, m0)	(((offsetof(t, m0) << 16) | sizeof_field(t, m0)))
+#define MEMFILE_OFFSET0(val)	(((val) >> 16) & 0xffff)
+#define MEMFILE_FIELD_SIZE(val)	((val) & 0xffff)
+
+#define DFL_TMPL_SIZE		ARRAY_SIZE(hugetlb_dfl_tmpl)
+#define LEGACY_TMPL_SIZE	ARRAY_SIZE(hugetlb_legacy_tmpl)
+
 static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
+static struct cftype *dfl_files;
+static struct cftype *legacy_files;
 
 static inline struct page_counter *
 __hugetlb_cgroup_counter_from_cgroup(struct hugetlb_cgroup *h_cg, int idx,
@@ -702,12 +712,142 @@ static int hugetlb_events_local_show(str
 	return __hugetlb_events_show(seq, true);
 }
 
+static struct cftype hugetlb_dfl_tmpl[] = {
+	{
+		.name = "max",
+		.private = RES_LIMIT,
+		.seq_show = hugetlb_cgroup_read_u64_max,
+		.write = hugetlb_cgroup_write_dfl,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "rsvd.max",
+		.private = RES_RSVD_LIMIT,
+		.seq_show = hugetlb_cgroup_read_u64_max,
+		.write = hugetlb_cgroup_write_dfl,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "current",
+		.private = RES_USAGE,
+		.seq_show = hugetlb_cgroup_read_u64_max,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "rsvd.current",
+		.private = RES_RSVD_USAGE,
+		.seq_show = hugetlb_cgroup_read_u64_max,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "events",
+		.seq_show = hugetlb_events_show,
+		.file_offset = MEMFILE_OFFSET(struct hugetlb_cgroup, events_file[0]),
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "events.local",
+		.seq_show = hugetlb_events_local_show,
+		.file_offset = MEMFILE_OFFSET(struct hugetlb_cgroup, events_local_file[0]),
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "numa_stat",
+		.seq_show = hugetlb_cgroup_read_numa_stat,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	/* don't need terminator here */
+};
+
+static struct cftype hugetlb_legacy_tmpl[] = {
+	{
+		.name = "limit_in_bytes",
+		.private = RES_LIMIT,
+		.read_u64 = hugetlb_cgroup_read_u64,
+		.write = hugetlb_cgroup_write_legacy,
+	},
+	{
+		.name = "rsvd.limit_in_bytes",
+		.private = RES_RSVD_LIMIT,
+		.read_u64 = hugetlb_cgroup_read_u64,
+		.write = hugetlb_cgroup_write_legacy,
+	},
+	{
+		.name = "usage_in_bytes",
+		.private = RES_USAGE,
+		.read_u64 = hugetlb_cgroup_read_u64,
+	},
+	{
+		.name = "rsvd.usage_in_bytes",
+		.private = RES_RSVD_USAGE,
+		.read_u64 = hugetlb_cgroup_read_u64,
+	},
+	{
+		.name = "max_usage_in_bytes",
+		.private = RES_MAX_USAGE,
+		.write = hugetlb_cgroup_reset,
+		.read_u64 = hugetlb_cgroup_read_u64,
+	},
+	{
+		.name = "rsvd.max_usage_in_bytes",
+		.private = RES_RSVD_MAX_USAGE,
+		.write = hugetlb_cgroup_reset,
+		.read_u64 = hugetlb_cgroup_read_u64,
+	},
+	{
+		.name = "failcnt",
+		.private = RES_FAILCNT,
+		.write = hugetlb_cgroup_reset,
+		.read_u64 = hugetlb_cgroup_read_u64,
+	},
+	{
+		.name = "rsvd.failcnt",
+		.private = RES_RSVD_FAILCNT,
+		.write = hugetlb_cgroup_reset,
+		.read_u64 = hugetlb_cgroup_read_u64,
+	},
+	{
+		.name = "numa_stat",
+		.seq_show = hugetlb_cgroup_read_numa_stat,
+	},
+	/* don't need terminator here */
+};
+
+static void __init
+hugetlb_cgroup_cfttypes_init(struct hstate *h, struct cftype *cft,
+			     struct cftype *tmpl, int tmpl_size)
+{
+	char buf[32];
+	int i, idx = hstate_index(h);
+
+	/* format the size */
+	mem_fmt(buf, sizeof(buf), huge_page_size(h));
+
+	for (i = 0; i < tmpl_size; cft++, tmpl++, i++) {
+		*cft = *tmpl;
+		/* rebuild the name */
+		snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
+		/* rebuild the private */
+		cft->private = MEMFILE_PRIVATE(idx, tmpl->private);
+		/* rebuild the file_offset */
+		if (tmpl->file_offset) {
+			unsigned int offset = tmpl->file_offset;
+
+			cft->file_offset = MEMFILE_OFFSET0(offset) +
+					   MEMFILE_FIELD_SIZE(offset) * idx;
+		}
+	}
+}
+
 static void __init __hugetlb_cgroup_file_dfl_init(int idx)
 {
 	char buf[32];
 	struct cftype *cft;
 	struct hstate *h = &hstates[idx];
 
+	hugetlb_cgroup_cfttypes_init(h, dfl_files + idx * DFL_TMPL_SIZE,
+				     hugetlb_dfl_tmpl, DFL_TMPL_SIZE);
+
 	/* format the size */
 	mem_fmt(buf, sizeof(buf), huge_page_size(h));
 
@@ -779,6 +919,9 @@ static void __init __hugetlb_cgroup_file
 	struct cftype *cft;
 	struct hstate *h = &hstates[idx];
 
+	hugetlb_cgroup_cfttypes_init(h, legacy_files + idx * LEGACY_TMPL_SIZE,
+				     hugetlb_legacy_tmpl, LEGACY_TMPL_SIZE);
+
 	/* format the size */
 	mem_fmt(buf, sizeof(buf), huge_page_size(h));
 
@@ -856,10 +999,23 @@ static void __init __hugetlb_cgroup_file
 	__hugetlb_cgroup_file_legacy_init(idx);
 }
 
+static void __init __hugetlb_cgroup_file_pre_init(void)
+{
+	int cft_count;
+
+	cft_count = hugetlb_max_hstate * DFL_TMPL_SIZE + 1; /* add terminator */
+	dfl_files = kcalloc(cft_count, sizeof(struct cftype), GFP_KERNEL);
+	BUG_ON(!dfl_files);
+	cft_count = hugetlb_max_hstate * LEGACY_TMPL_SIZE + 1; /* add terminator */
+	legacy_files = kcalloc(cft_count, sizeof(struct cftype), GFP_KERNEL);
+	BUG_ON(!legacy_files);
+}
+
 void __init hugetlb_cgroup_file_init(void)
 {
 	struct hstate *h;
 
+	__hugetlb_cgroup_file_pre_init();
 	for_each_hstate(h)
 		__hugetlb_cgroup_file_init(hstate_index(h));
 }
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl.patch
mm-hugetlb_cgroup-prepare-cftypes-based-on-template.patch
mm-hugetlb_cgroup-switch-to-the-new-cftypes.patch

