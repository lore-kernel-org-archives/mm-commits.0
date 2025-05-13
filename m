Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522781EEA49
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119316; cv=none; b=jFb6LYliJLI5cIjCQXUE5RH7qFgW7OzBbeAJUyKtO2Vt6wyhNmXlOBix2eQw/NubF4G9tqmxmGPa1vqcmckVa79NPozu3NR2qSSAXgs+cT0NCsSqugJUh7VlywqxRVBNryN3cb0368nOHJ/q/nP36QC7eGI7GuBSTMw99OPSops=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119316; c=relaxed/simple;
	bh=Gf0C919ViQz1s8HdxFRJCUSTgU3ieJZXaoHI0yzBT7A=;
	h=Date:To:From:Subject:Message-Id; b=mqqgSj0BbWNn0ZuPsCmZjqf8ROcHu5suvgrWIGpXxyJTI+gJeL87hT5OTmxLYM/456/f9Cs2wtUvphIzp5Ame+059QJXP+2xYxbcuFV8WBOKlRxYCtGEpgM7v5YVNxf1QcsGO9Wh7ZIlatdlREx/hX/iae66901xoT4wwM21pG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qoWZjlzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qoWZjlzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A35C4CEE4;
	Tue, 13 May 2025 06:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119316;
	bh=Gf0C919ViQz1s8HdxFRJCUSTgU3ieJZXaoHI0yzBT7A=;
	h=Date:To:From:Subject:From;
	b=qoWZjlzBbBJrerh6vTwqqQWhElMHq9bOJwVQgUCVwwYr25va56f+L9JDWw8ANbSyI
	 dkB4nbgNyHQGeDYYQFtvsQXjfR6MEpA+kq/J+4KL08tnOKPDr5v+Xa3pzHKFqtRlEt
	 A1FruiiM3hhsv0LPx+EEefklE4zHiD9/7fWEk/nM=
Date: Mon, 12 May 2025 23:55:14 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,Jonathan.Cameron@huawei.com,david@redhat.com,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch removed from -mm tree
Message-Id: <20250513065516.25A35C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: DAX: warn when kmem regions are truncated for memory block alignment
has been removed from the -mm tree.  Its filename was
     dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: DAX: warn when kmem regions are truncated for memory block alignment
Date: Thu, 10 Apr 2025 10:28:31 -0400

Device capacity intended for use as system ram should be aligned to the
architecture-defined memory block size or that capacity will be silently
truncated and capacity stranded.

As hotplug dax memory becomes more prevelant, the memory block size
alignment becomes more important for platform and device vendors to pay
attention to - so this truncation should not be silent.

This issue is particularly relevant for CXL Dynamic Capacity devices,
whose capacity may arrive in spec-aligned but block-misaligned chunks.

Link: https://lkml.kernel.org/r/20250410142831.217887-1-gourry@gourry.net
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/dax/kmem.c~dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment
+++ a/drivers/dax/kmem.c
@@ -13,6 +13,7 @@
 #include <linux/mman.h>
 #include <linux/memory-tiers.h>
 #include <linux/memory_hotplug.h>
+#include <linux/string_helpers.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -68,7 +69,7 @@ static void kmem_put_memory_types(void)
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
-	unsigned long total_len = 0;
+	unsigned long total_len = 0, orig_len = 0;
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
 	int i, rc, mapped = 0;
@@ -97,6 +98,7 @@ static int dev_dax_kmem_probe(struct dev
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
+		orig_len += range_len(&dev_dax->ranges[i].range);
 		rc = dax_kmem_range(dev_dax, i, &range);
 		if (rc) {
 			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
@@ -109,6 +111,12 @@ static int dev_dax_kmem_probe(struct dev
 	if (!total_len) {
 		dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
 		return -EINVAL;
+	} else if (total_len != orig_len) {
+		char buf[16];
+
+		string_get_size(orig_len - total_len, 1, STRING_UNITS_2,
+				buf, sizeof(buf));
+		dev_warn(dev, "DAX region truncated by %s due to alignment\n", buf);
 	}
 
 	init_node_memory_type(numa_node, mtype);
_

Patches currently in -mm which might be from gourry@gourry.net are


