Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B150C79F2
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 23:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745883073; cv=none; b=fpliBjG3ejTJYvvKWeiF4FmYnbOiE7t9qyCgXQ5rxum7etTh4wqCQRrjvTzZ+VrerZmDiJDSEVrsCJyk0kk8a/UfbBL+vPKlpZo7oh6im0SQuYPw0UV7rwHXhszUdIGAXrF+ibSqTNHSwlRwtzreROoCrAS+Yx79wrzXvp0XB1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745883073; c=relaxed/simple;
	bh=UI9O0jNwP7sJ6NFdexSYaeAe89M42X60MN2epZUvdvY=;
	h=Date:To:From:Subject:Message-Id; b=KC8fzTVvISDKpMXbSn7LhenGmbGT9bYFHk9/jC5ExMUraEj1zKMIOEig5gbJclsBRyPNkw3ziK+7ZtMooFMOzp9FS2d9+OatK1Lgo1TfvHEkoDE27tmeiCgnxG6MnixpCygXfReao6BBsfAj/crt73VHRCWdh5eUfFuDYHEwYmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4YDvriG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4YDvriG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7B2C4CEE4;
	Mon, 28 Apr 2025 23:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745883072;
	bh=UI9O0jNwP7sJ6NFdexSYaeAe89M42X60MN2epZUvdvY=;
	h=Date:To:From:Subject:From;
	b=V4YDvriG7TRu5CksayYj+sYnJHb0lWHk32kqprnIOdoXDE0nDoCj/W89WzbpjrueQ
	 xe2UWGFmI5+jxPrFR8x3g35SoVQz20eQFMO54zQh1wuD1JLSWO7HliG/ZWnmD4cHF6
	 sgnSdjSjHOP+M2LZ80qOYOLlttLDo7F4kgJE+v+k=
Date: Mon, 28 Apr 2025 16:31:12 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,Jonathan.Cameron@huawei.com,david@redhat.com,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch added to mm-new branch
Message-Id: <20250428233112.DC7B2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: DAX: warn when kmem regions are truncated for memory block alignment.
has been added to the -mm mm-new branch.  Its filename is
     dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Gregory Price <gourry@gourry.net>
Subject: DAX: warn when kmem regions are truncated for memory block alignment.
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

memory-implement-memory_block_advise-probe_max_size.patch
x86-probe-memory-block-size-advisement-value-during-mm-init.patch
acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch
cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed.patch
vmscancgroup-apply-mems_effective-to-reclaim.patch
dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch

