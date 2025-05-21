Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A34C1CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846619; cv=none; b=VsB+epPJMBSxEOpazi5n0pedh5pQPb+4sl07GsrSXfbdc3CB/zCYwLefAzI5gq9UStm9Xz3WbFoN2SF1gENfwJto2Y8ns7hTkilKHOdnja/UBbTsLlddj9xwfNohsA+HY2OBbnAtMLK/4flpNHAZ8N/gLWieImlHtKgJUhd8uj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846619; c=relaxed/simple;
	bh=Tro7+mUhuYFU5cWdqzFfD2LMvYOLiJcK0Kq2e5djmWQ=;
	h=Date:To:From:Subject:Message-Id; b=PRWVTHNSRosixGjv8KXnsiJ3Sm9UDBUvq4Z2mf3pA/lD9D/WyXUNUEiZrryRe66q43UNnZEycuRMYAN8nxtiOT2Iqb+e8a+TfMleXdNSv6u7dxzOJ7F9GcYPqr/l3tfisVPT/yXN7gS4KWApfvOfXi1tJYFLb+Gt8z0h4Q6aiqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=icHWD754; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="icHWD754"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BA1C4CEE4;
	Wed, 21 May 2025 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846618;
	bh=Tro7+mUhuYFU5cWdqzFfD2LMvYOLiJcK0Kq2e5djmWQ=;
	h=Date:To:From:Subject:From;
	b=icHWD754m+23YAFU9kxD5AwfdwKCEW38mPgJYt23oQHqj9E5yWgdnmprj+KjVx3a0
	 4PFCPbSOoI7+jpuyD67htnKRvd7tLY6lR45Esl1E2AGOKY33hvkwYiIbKRlMEk+k5t
	 Iet5bINcru3lnPxl53F6fWR6p0iBPXpIjMUvuPlo=
Date: Wed, 21 May 2025 09:56:57 -0700
To: mm-commits@vger.kernel.org,rrichter@amd.com,rppt@kernel.org,lenb@kernel.org,Jonathan.Cameron@huawei.com,haibo1.xu@intel.com,david@redhat.com,dan.j.williams@intel.com,chenhuacai@kernel.org,chenbaozi@phytium.com.cn,bfaccini@nvidia.com,alison.schofield@intel.com,wangyuquan1236@phytium.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-numa_memblks-introduce-numa_add_reserved_memblk.patch removed from -mm tree
Message-Id: <20250521165658.40BA1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: numa_memblks: introduce numa_add_reserved_memblk
has been removed from the -mm tree.  Its filename was
     mm-numa_memblks-introduce-numa_add_reserved_memblk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuquan Wang <wangyuquan1236@phytium.com.cn>
Subject: mm: numa_memblks: introduce numa_add_reserved_memblk
Date: Thu, 8 May 2025 10:27:19 +0800

acpi_parse_cfmws() currently adds empty CFMWS ranges to numa_meminfo with
the expectation that numa_cleanup_meminfo moves them to
numa_reserved_meminfo.  There is no need for that indirection when it is
known in advance that these unpopulated ranges are meant for
numa_reserved_meminfo in support of future hotplug / CXL provisioning.

Introduce and use numa_add_reserved_memblk() to add the empty CFMWS ranges
directly.

Link: https://lkml.kernel.org/r/20250508022719.3941335-1-wangyuquan1236@phytium.com.cn
Signed-off-by: Yuquan Wang <wangyuquan1236@phytium.com.cn>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Cc: Bruno Faccini <bfaccini@nvidia.com>
Cc: Chen Baozi <chenbaozi@phytium.com.cn>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haibo Xu <haibo1.xu@intel.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Robert Richter <rrichter@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/srat.c     |    2 +-
 include/linux/numa_memblks.h |    1 +
 mm/numa_memblks.c            |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/acpi/numa/srat.c~mm-numa_memblks-introduce-numa_add_reserved_memblk
+++ a/drivers/acpi/numa/srat.c
@@ -464,7 +464,7 @@ static int __init acpi_parse_cfmws(union
 		return -EINVAL;
 	}
 
-	if (numa_add_memblk(node, start, end) < 0) {
+	if (numa_add_reserved_memblk(node, start, end) < 0) {
 		/* CXL driver must handle the NUMA_NO_NODE case */
 		pr_warn("ACPI NUMA: Failed to add memblk for CFMWS node %d [mem %#llx-%#llx]\n",
 			node, start, end);
--- a/include/linux/numa_memblks.h~mm-numa_memblks-introduce-numa_add_reserved_memblk
+++ a/include/linux/numa_memblks.h
@@ -22,6 +22,7 @@ struct numa_meminfo {
 };
 
 int __init numa_add_memblk(int nodeid, u64 start, u64 end);
+int __init numa_add_reserved_memblk(int nid, u64 start, u64 end);
 void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
 
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
--- a/mm/numa_memblks.c~mm-numa_memblks-introduce-numa_add_reserved_memblk
+++ a/mm/numa_memblks.c
@@ -201,6 +201,28 @@ int __init numa_add_memblk(int nid, u64
 }
 
 /**
+ * numa_add_reserved_memblk - Add one numa_memblk to numa_reserved_meminfo
+ * @nid: NUMA node ID of the new memblk
+ * @start: Start address of the new memblk
+ * @end: End address of the new memblk
+ *
+ * Add a new memblk to the numa_reserved_meminfo.
+ *
+ * Usage Case: numa_cleanup_meminfo() reconciles all numa_memblk instances
+ * against memblock_type information and moves any that intersect reserved
+ * ranges to numa_reserved_meminfo. However, when that information is known
+ * ahead of time, we use numa_add_reserved_memblk() to add the numa_memblk
+ * to numa_reserved_meminfo directly.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int __init numa_add_reserved_memblk(int nid, u64 start, u64 end)
+{
+	return numa_add_memblk_to(nid, start, end, &numa_reserved_meminfo);
+}
+
+/**
  * numa_cleanup_meminfo - Cleanup a numa_meminfo
  * @mi: numa_meminfo to clean up
  *
_

Patches currently in -mm which might be from wangyuquan1236@phytium.com.cn are


