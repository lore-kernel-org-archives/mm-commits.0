Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E91A1361
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976867; cv=none; b=VzP5lQeGQga1dOrRp0mNKsQAC/7oxBK+2/oDTwhJn6Eq38j1mAtORBO/LKyJmDsUfxnh9e4WSi0Kj/NCkVjKedNWNgOwrvfKDi2gTuY23qivsRGS0HWNhlfXSmB8tpIjfCWdo5n0Eff0hr5fttht4ryRbCFetyfrKHN8kXv4Qok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976867; c=relaxed/simple;
	bh=9byNhFeJmSmqan6DuStdq66UmIlt5QAYK1j4e2mszDs=;
	h=Date:To:From:Subject:Message-Id; b=DIP/fdfiLrW7nwzBGYnj89q3ZZxqeUYQEnjNMKlBsBr6YRuVfuABnL7QLA0Eu1HY8j/9dT0k+qkubwQGfS4C4hU6w4a3ZKKCJq807X0zx2XucnnfFjHgwUBl7MEOlEZuednUCJnuw/EwVG11SZ5FeDX8AD0sPXHw1sP/b3PpvBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=flLx1gY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="flLx1gY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B30C4CEE3;
	Sun, 20 Jul 2025 02:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976867;
	bh=9byNhFeJmSmqan6DuStdq66UmIlt5QAYK1j4e2mszDs=;
	h=Date:To:From:Subject:From;
	b=flLx1gY0+pxjKLU8uU3cvssJFyPfgTMvtD5XDsmXvrJKHgDBenTcBjpU7H6zlMfsd
	 Q8gYNMi2DjufxR4x6OFq/9FstPork2vZAvOcgdOnbyyxRUAm+Fbl7YDH7v202xqFcH
	 i+45w+bHGIzBFGKb5dHw6GxudayyJq6EP16tIPl8=
Date: Sat, 19 Jul 2025 19:01:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch removed from -mm tree
Message-Id: <20250720020106.F1B30C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/wsse: rename to have damon_sample_ prefix
has been removed from the -mm tree.  Its filename was
     samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/wsse: rename to have damon_sample_ prefix
Date: Sat, 5 Jul 2025 10:49:55 -0700

Patch series "mm/damon: misc cleanups".

Yet another round of miscellaneous DAMON cleanups.


This patch (of 6):

DAMON sample module, wsse has its name 'wsse'.  It could conflict with
future modules, and not very easy to identify it by name.  Use a prefix,
"damon_sample_" for the name.

Note that this could break users if they depend on the old name.  But it
is just a sample, so no such usage is expected, or known.  Even if such
usage exists, updating it for the new name should be straightforward.

Link: https://lkml.kernel.org/r/20250705175000.56259-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250705175000.56259-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/samples/damon/wsse.c~samples-damon-wsse-rename-to-have-damon_sample_-prefix
+++ a/samples/damon/wsse.c
@@ -12,6 +12,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_sample_wsse."
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

