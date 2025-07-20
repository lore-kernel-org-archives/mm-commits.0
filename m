Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51501361
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976869; cv=none; b=tgqba5tpduRhIoKXDh82H9DSyWYb5sArA+qTztQ8in/5Aq+3t4asiEzm8JB6PlqA6i+JLhynsI30pvYZcj4YfIsw2z4EE4VzanBnGiFNJnRr0OZnSCNirGgb7QsEp1b0b5AbEviMAXqGkQbb+XoBgr/qjsN3KZXtcmFyDpKNC7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976869; c=relaxed/simple;
	bh=fLlvSDNNUCzZSWrh2zzboYZEPt9hlQG/ux9whPeBehc=;
	h=Date:To:From:Subject:Message-Id; b=vBgMvAJzorRw9Rv2kL8bXEDOgdtg7BP9v4+2nciLG0pj4gQSpr8PirpFS4ddQXO/52WpznkocQtiRamNifNh5G0jejsNBdXpK2/PDK0aqaVpmgvPMTN4nyRmVMBzLv6xu3FwPQywKcVoJbQey9K85eukdidkYgrjJHHpMFo0mfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bImnplUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bImnplUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD23C4CEE3;
	Sun, 20 Jul 2025 02:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976869;
	bh=fLlvSDNNUCzZSWrh2zzboYZEPt9hlQG/ux9whPeBehc=;
	h=Date:To:From:Subject:From;
	b=bImnplUNQIkJMqJTkH8/FntebaaXfQZ6XLlK74w/ocpg9L3G5LF4voGmjeBtsEBk2
	 YaB9i9HxVFgW/CpOLwsX6/rmdCj8iOwSS4KkGoOxQPj4SYFjBi+v+dcBOvm4OJfflg
	 8j4bJOBUQkdY9T+Kc7ITc23olQ8ENT0BZ/Nn0m4M=
Date: Sat, 19 Jul 2025 19:01:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch removed from -mm tree
Message-Id: <20250720020109.3CD23C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: rename to have damon_sample_ prefix
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/mtier: rename to have damon_sample_ prefix
Date: Sat, 5 Jul 2025 10:49:57 -0700

DAMON sample module, mtier has its name 'mtier'.  It could conflict with
future modules, and not very easy to identify it by name.  Use a prefix,
"damon_sample_" for the name.

Note that this could break users if they depend on the old name.  But it
is just a sample, so no such usage is expected, or known.  Even if such
usage exists, updating it for the new name should be straightforward.

Link: https://lkml.kernel.org/r/20250705175000.56259-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/samples/damon/mtier.c~samples-damon-mtier-rename-to-have-damon_sample_-prefix
+++ a/samples/damon/mtier.c
@@ -12,6 +12,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_sample_mtier."
+
 static unsigned long node0_start_addr __read_mostly;
 module_param(node0_start_addr, ulong, 0600);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

