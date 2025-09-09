Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037024C076;
	Tue,  9 Sep 2025 02:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757385460; cv=none; b=rE6ZQRCU3HPcwi03L5K4i472u/0gUtGU6kabszGPuS5xn0/3iTLY876wUlgdirlUmc3+Vt434tin1tSIEAT9JmwvSrp2ZwC5ifJ6iHlwwq8N4EhE0Q1bI8qtlvauMCxG22+9BVWk0o928AIajvouu+uNf3v8U4pEy9ix3zHSTT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757385460; c=relaxed/simple;
	bh=lVT8AX3kS1qX54o5tlezahaqWT/wDdWWbM7RGCvhXeU=;
	h=Date:To:From:Subject:Message-Id; b=EPSfF14/kY/BkYisXUZZ7QtqBBB1NoPVrqQqkwB4qza6nF3G0A8han5LyKFYvvWg0QGDLPneD2AykAWbjlnobsFKpXwvkTGZ/YCmI0Q59iWmzE5gl0gPw5fN48GAuhTMOgup6NtXcbUiSOB9pAgvGxqL1au7q7t6UuODnvaN0sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VhhZZjYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VhhZZjYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DFDC4CEF1;
	Tue,  9 Sep 2025 02:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757385460;
	bh=lVT8AX3kS1qX54o5tlezahaqWT/wDdWWbM7RGCvhXeU=;
	h=Date:To:From:Subject:From;
	b=VhhZZjYum2XFNkqD2ZziIeFqshQFwz6mX4+kYa9RZUzAZ45aSwseFl/qtXgfe4+N9
	 /+uRwghPBgAezzn+6OVfO5Dpv4DmZWH47CJ4qtIqYjEIIOolZE0ZqzMYGgOSv3Ofpo
	 6fC6nupaznv5l7TWphHxPQTSNk8I3YvzH1vRWq9w=
Date: Mon, 08 Sep 2025 19:37:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-wsse-avoid-starting-damon-before-initialization.patch added to mm-hotfixes-unstable branch
Message-Id: <20250909023739.F2DFDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/wsse: avoid starting DAMON before initialization
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     samples-damon-wsse-avoid-starting-damon-before-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-wsse-avoid-starting-damon-before-initialization.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/wsse: avoid starting DAMON before initialization
Date: Mon, 8 Sep 2025 19:22:36 -0700

Patch series "samples/damon: fix boot time enable handling fixup merge
mistakes".

This patch (of 3):

Commit 0ed1165c3727 ("samples/damon/wsse: fix boot time enable handling")
is somehow incompletely applying the origin patch [1].  It is missing the
part that avoids starting DAMON before module initialization.  Probably a
mistake during a merge has happened.  Fix it by applying the missed part
again.

Link: https://lkml.kernel.org/r/20250909022238.2989-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250909022238.2989-2-sj@kernel.org
Link: https://lore.kernel.org/20250706193207.39810-2-sj@kernel.org [1]
Fixes: 0ed1165c3727 ("samples/damon/wsse: fix boot time enable handling")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/wsse.c~samples-damon-wsse-avoid-starting-damon-before-initialization
+++ a/samples/damon/wsse.c
@@ -118,6 +118,9 @@ static int damon_sample_wsse_enable_stor
 		return 0;
 
 	if (enabled) {
+		if (!init_called)
+			return 0;
+
 		err = damon_sample_wsse_start();
 		if (err)
 			enabled = false;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch
mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch
samples-damon-wsse-avoid-starting-damon-before-initialization.patch
samples-damon-prcl-avoid-starting-damon-before-initialization.patch
samples-damon-mtier-avoid-starting-damon-before-initialization.patch
mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

