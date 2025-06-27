Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA9A2E88A9
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751054257; cv=none; b=ClxqA7ZHGmUWV9ohglSdcOh5zG5OJuE9PfweTgWk1PR3D1c3ptZd0j+8w/1xQW8HUwaINCrk3C5krGBzs2OtNkKYPT5atZ8yUjJDnlkHqHgNM/EhuV2S1Q1c5O01BsCOIRgNA9Qc5RzbbIBDxZdWCcf+1AAccV5dRoaY43mrItI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751054257; c=relaxed/simple;
	bh=KTLq+vwXvVEOwd6HkFLq9IIGFKpzIUuAIBn63gck4+g=;
	h=Date:To:From:Subject:Message-Id; b=JF86G8dJDUQYBSR5m1kC6toqGLIsc5scDSx68DdBlEWyoE8YHrGmvDUKToXg2eYEPbDIRkwQ1G27XLubQ6c4dV2+QLN5QLwBzZcGBkXmmOxhJXxmTOmmlCoEG29GU690f7xud90nneY8lbo7s+frGV2SvIQKwBUQ/5VmCt2w7nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gbNem3bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gbNem3bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA21C4CEE3;
	Fri, 27 Jun 2025 19:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751054255;
	bh=KTLq+vwXvVEOwd6HkFLq9IIGFKpzIUuAIBn63gck4+g=;
	h=Date:To:From:Subject:From;
	b=gbNem3bj04GjRHJGA5aIFP9Qul3QckCtPXmgdgv2ySdF9Bvnd06se/bWvBGoWLYLZ
	 aivxpIdFjGyqs5J0oXTb8Ly3smFiH4e4E3idcmKMuARRk/IPCY4rhjYCOfaoOSf5UA
	 ieOEtx/ul/C4pwv19x43ThMC3n/PMeNi1OsMZhPI=
Date: Fri, 27 Jun 2025 12:57:34 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch added to mm-unstable branch
Message-Id: <20250627195735.7FA21C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-damon-sysfs-schemes-decouple-from-damos_action-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-sysfs-schemes-decouple-from-damos_action-fix
Date: Fri Jun 27 12:56:28 PM PDT 2025

make damos_sysfs_action_names static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506271655.b8yfEZIT-lkp@intel.com/
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-decouple-from-damos_action-fix
+++ a/mm/damon/sysfs-schemes.c
@@ -1619,7 +1619,7 @@ struct damos_sysfs_action_name {
 	char *name;
 };
 
-struct damos_sysfs_action_name damos_sysfs_action_names[] = {
+static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 	{
 		.action = DAMOS_WILLNEED,
 		.name = "willneed",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fix-do_pages_stat-to-use-compat_uptr_t-fix.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

