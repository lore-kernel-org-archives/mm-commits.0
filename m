Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20A537E30F
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786505177; cv=none; b=DM9qW3vQl/gFBS0CACWhnYShZoksyvRoozIfz4a3/MQbPYyjD5vCPTSKA3ZOlWqNLgVIRzfqZlAKDnqGvVyXFcw2RPbqIKpkMsX0UQSVM/e28lcueWrht9CqbcP4JAfWfPpKHse6ksxOrnqsLXyYGAGSRytMwkYtFWDpsOjvpcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786505177; c=relaxed/simple;
	bh=YX5JwCPHx23O5T0OPPbmwTN12XO2WzrLvYvi71UhTLg=;
	h=Date:To:From:Subject:Message-Id; b=GlvZaQxKIuFX22ohbIZazqdOwIkZBjaPf9PZDMsLsOlMAwY4DEDPTafWnoeh9ipT0a7ZxA8K0ivB7p56aEcxUs29jxFjy5DO+/McS2wAAJHEd0wGnbEoAml3DHG8iwPBNfPsd086eugCUd7qrIgNPRsX8j/9ctrH6jos+UR7fU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rf/RYvyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rf/RYvyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6167A1F000E9;
	Wed, 12 Aug 2026 03:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786505175;
	bh=aanR72WRJY9ZfVdPTJMAllt2ZMnbXU0mf0JqYpbWCh0=;
	h=Date:To:From:Subject;
	b=rf/RYvyDjTlRzNNbCPmRlgMkShWgryhGwuGSr5Ke0q2eRhQ224MwiGNRddKu8t5GS
	 iF4vwW4j9owPyezovA7E9LGEl6PGuzUAZ6oKxrsAdxAdI0h5sAueP9Qx0Oy2sP48N4
	 pCZeUVhomz+WpuAC+atBC9AP5zUNvtzjqGj8kIHo=
Date: Tue, 11 Aug 2026 20:26:14 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch removed from -mm tree
Message-Id: <20260812032615.6167A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag-add-ioctl-to-proc-allocinfo-fix
has been removed from the -mm tree.  Its filename was
     alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch

This patch was dropped because it was folded into alloc_tag-add-ioctl-to-proc-allocinfo.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: alloc_tag-add-ioctl-to-proc-allocinfo-fix
Date: Thu Jul  9 10:13:24 AM PDT 2026

include compat.h, per Suren

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-lkp@intel.com/
Acked-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/alloc_tag.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/alloc_tag.c~alloc_tag-add-ioctl-to-proc-allocinfo-fix
+++ a/mm/alloc_tag.c
@@ -6,6 +6,7 @@
 #include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/compat.h>
 #include <linux/page_ext.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/proc_fs.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alloc_tag-add-ioctl-to-proc-allocinfo.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

