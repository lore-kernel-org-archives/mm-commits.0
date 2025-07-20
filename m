Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5581361
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976868; cv=none; b=rU4pZ5UrB3/S1NT+Ol6ZKiLqW9pD8bTIOywMA4wcZiMnXsxOIGbxGSlZDheGm5KZnnxaNR8beptRsj3Trp3DvJh6DtAfNHcG4ftfTUc/jEr+3PSh+JmHHu5ehctTd7Ph86acDhzVr9FA+ApxLFkIMxTEM5Kalg/Di73uHENIk7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976868; c=relaxed/simple;
	bh=/LXRPyRdpmd46sqSxQkBM6E9ZsHZVuerxxqAyBr9e74=;
	h=Date:To:From:Subject:Message-Id; b=oaVN+JPPPcHhLGejU8mSmbJF3IOzspNetFVfEHMtDIBp0ZKuLzzhUoMG9fgWhhLWVNSPQ8WUVkZlYWbBDY0Ot0K32U84nbMByAmd4xlCi+zoYkfgcX2/3Ffc8MkZFuV4ljnQbA7+udb3r99TghjAJzL4D2RnqAzAoUxuGUhjeEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SgWJD3ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SgWJD3ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F573C4CEE3;
	Sun, 20 Jul 2025 02:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976868;
	bh=/LXRPyRdpmd46sqSxQkBM6E9ZsHZVuerxxqAyBr9e74=;
	h=Date:To:From:Subject:From;
	b=SgWJD3llcepezYCQ2w5bOKAsHBPub3PCh/WvLuKQIb7tCGyx7t2gLOc0UZ+3r7ciq
	 freuB6dkp42uBl1QoCJWLpVduFduMpLLb73dA2zXZoP0Aonh9IDLRmYKyP2sI0imn+
	 nLWQEwhQTKwzRIwARDVTRDT8DnX8NirNzSqH5Ckk=
Date: Sat, 19 Jul 2025 19:01:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch removed from -mm tree
Message-Id: <20250720020108.1F573C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/prcl: rename to have damon_sample_ prefix
has been removed from the -mm tree.  Its filename was
     samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/prcl: rename to have damon_sample_ prefix
Date: Sat, 5 Jul 2025 10:49:56 -0700

DAMON sample module, prcl has its name 'prcl'.  It could conflict with
future modules, and not very easy to identify it by name.  Use a prefix,
"damon_sample_" for the name.

Note that this could break users if they depend on the old name.  But it
is just a sample, so no such usage is expected, or known.  Even if such
usage exists, updating it for the new name should be straightforward.

Link: https://lkml.kernel.org/r/20250705175000.56259-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/samples/damon/prcl.c~samples-damon-prcl-rename-to-have-damon_sample_-prefix
+++ a/samples/damon/prcl.c
@@ -11,6 +11,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_sample_prcl."
+
 static int target_pid __read_mostly;
 module_param(target_pid, int, 0600);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

