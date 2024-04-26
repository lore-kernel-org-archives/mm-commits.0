Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F00881752
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104476; cv=none; b=FM2cOQIWJYZVwB1xKnqmPtSZNzNKuIY2lwUGcuJwkg2vLaoSqj+cirlu4fL7ryRomCpVewHHlri/DKBv2scV+EJEQD3ZMeV+BrMzEkIbK6RfPcHhBjlBPEfgo//kYb4SuyNl6ZMVGRGt4wDV1TJNpQXhhYgTxlKg4OUtXsnc2pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104476; c=relaxed/simple;
	bh=wPd1KL9sofJ+TeuqHBlWL4K5J2qfhxo5miBxDOrbtQU=;
	h=Date:To:From:Subject:Message-Id; b=VerfBckzgwbFJCyr1CzI3PERRL7XfHLc/9FBwtxBVqp9ppXG1+6xrltjUZZPMQEmmJq7FKNsabaEjnnRVA9Gm6e23psapexMUCldK/5nyUjPOmKIQz2ksVqcWcZ53mZHAh6/85Bgpcnfozi4K15a0bPjNV45jXRonghZByPJdIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vFtWLbAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vFtWLbAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88D1C116B1;
	Fri, 26 Apr 2024 04:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104476;
	bh=wPd1KL9sofJ+TeuqHBlWL4K5J2qfhxo5miBxDOrbtQU=;
	h=Date:To:From:Subject:From;
	b=vFtWLbAV+urEDkMDlXysz8zdqpdcY9DEnGcf+S7ljmDwEx9by6J/82usor6X078qW
	 A/j4CYazYlTwga1ouJHS8lD2xaPUZo38NVi/3K/WQAj6/bB8kpEUWcJQTzYyPvcfQc
	 31m72K5u5N3KvuEFZEFvv7N5nWJ2eAG+6mFfyPw0=
Date: Thu, 25 Apr 2024 21:07:55 -0700
To: mm-commits@vger.kernel.org,pstanner@redhat.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] devres-dont-use-proxy-headers.patch removed from -mm tree
Message-Id: <20240426040755.E88D1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: devres: don't use "proxy" headers
has been removed from the -mm tree.  Its filename was
     devres-dont-use-proxy-headers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: devres: don't use "proxy" headers
Date: Wed, 3 Apr 2024 13:46:57 +0300

Update header inclusions to follow IWYU (Include What You Use) principle.

Link: https://lkml.kernel.org/r/20240403104820.557487-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/lib/devres.c~devres-dont-use-proxy-headers
+++ a/lib/devres.c
@@ -1,10 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/bug.h>
 #include <linux/device.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/gfp.h>
+#include <linux/errno.h>
 #include <linux/export.h>
+#include <linux/gfp_types.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
 #include <linux/of_address.h>
+#include <linux/types.h>
 
 enum devm_ioremap_type {
 	DEVM_IOREMAP = 0,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

xarray-use-bits_per_longs.patch
xarray-dont-use-proxy-headers.patch
media-rc-add-missing-ioh.patch
media-stih-cec-add-missing-ioh.patch
kfifo-dont-use-proxy-headers.patch

