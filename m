Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2CD484236
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865981; cv=none; b=pdw+6gO9FKPLJk8jxa36ACtzT1xUzvupelekP1vOKQTh303tOPt2Tst7BRk5BqUaeEphyZvZJL66O/wkV/48SYl6JRHU4ymCf+s9nAeiVPCfrZRioKmLvzjPEf0DGV8DERiEQ/NrcdWM+pezzjlEVUOdWMyDWVkPnP+03Jo/caY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865981; c=relaxed/simple;
	bh=FsAPagM+r+bmHxN7y/MGqQPcbhoB5gweHdzs6XRCyT8=;
	h=Date:To:From:Subject:Message-Id; b=CkwDYMIjbbk9FS0TVOqMyG8A/P7m41aMl/XOXS7xmIcTD8wuNFpFZmh5iXbNOa8Ic77hdW9qq8P6JsiQgOK/qPtNucfAlkBzXaKR70jNjAuCBRynYLZYrV+rFglrGVA98bcjAbAZrfXVWkw9dyLe0NQ/EU1E6M+UWQHb/wRxgQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LZdZ3hgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LZdZ3hgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E6D1F00893;
	Tue, 13 Oct 2026 04:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865979;
	bh=ojzlL2D3IDKTS9L4VNvakB+7C42HnoDWshBfrUtD8IA=;
	h=Date:To:From:Subject;
	b=LZdZ3hgf4pVI7kd+yIKia2DTr9hGyZUGzYTXaDoe7c58rCCezAGosoIiKjPqc3ik9
	 gqouPxgwuSYf8E+7WS7WVK2Yd3uY62IIZkCb+DYpmtRIsFfIAAVP4w0n6eksPKTYvt
	 Wmy90N7tFciRCtzkSoheZ/n2Xg2MeOb8q1pSDdhs=
Date: Mon, 12 Oct 2026 21:32:59 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch removed from -mm tree
Message-Id: <20261013043259.A3E6D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: raise min_unref_scans to 3 for verbose auto-scan
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: kmemleak: raise min_unref_scans to 3 for verbose auto-scan
Date: Thu, 17 Sep 2026 06:47:37 -0700

CONFIG_DEBUG_KMEMLEAK_VERBOSE sends every report to the console, so a
transient false positive there is broadcast to whatever collects the
kernel log rather than sitting in the debugfs file until someone looks. 
That asymmetry justifies being more conservative than the general case.

Require one more consecutive unreferenced scan before reporting.  The only
cost is that a genuine leak is reported one scan interval later (600s by
default); the value stays writable at run time through the module
parameter.

Kernels without CONFIG_DEBUG_KMEMLEAK_VERBOSE keep reporting on the first
unreferenced scan.

I've been running constant upstream kernel with
CONFIG_DEBUG_KMEMLEAK_VERBOSE set, and I am still seeing some rare false
positive, that goes away with min_unref_scans=3, so, making it the default
based on my heuristic.

Link: https://lore.kernel.org/20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/dev-tools/kmemleak.rst |    2 +-
 mm/kmemleak.c                        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -206,7 +206,7 @@ the minimum age of an object to be repor
 
 The ``min_unref_scans`` module parameter requires an object to be seen
 unreferenced in that many consecutive scans before it is reported. It
-defaults to 2 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
+defaults to 3 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
 periodic scan thread confirms a leak on its own, and to 1 otherwise. A
 value of 1 preserves the historical behaviour; higher values filter the
 transient false positives described above, at the cost of delaying genuine
--- a/mm/kmemleak.c~mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan
+++ a/mm/kmemleak.c
@@ -238,7 +238,7 @@ static struct task_struct *scan_thread;
 static unsigned long jiffies_min_age;
 /* consecutive scans an object must stay unreferenced before reporting */
 static unsigned int min_unref_scans =
-	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 2 : 1;
+	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 3 : 1;
 module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
_

Patches currently in -mm which might be from leitao@debian.org are


