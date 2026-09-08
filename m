Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95154CF5E
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893633; cv=none; b=nrmhf/bJ6cfrpgdMU3JV3oX8DacnraYprg7S9znp2HgYCX+cRkTt8sevJgE7jTg2GyZzEeuh5ZQg2gatcJEVk2UTjNhBgMSCGvDUUFIJCIPWWeO7J+WxnNjVVowBXKGfwRGjuNPQUAsDdO8p/DH1NLxFX/jZKMikGlb7Y4tSICU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893633; c=relaxed/simple;
	bh=IBhi+0Huetz7ASxD5J9+HjAa5uEBy4t2iWpZTMiADZo=;
	h=Date:To:From:Subject:Message-Id; b=c29wwjoSj7MwcN7zj/jnL3pv5ZIFVo6KtzgtkPXRy/0/vUW4pzz1F6DNCfFCt9b+1daKGCL/lI8SIHUn4SyyDCx+IzEcjCPG/R5jwkCUQxOsxHNo2HMLGE4z1qd4GY6NM4ELji6uhm8fggeSGzgraeadXov42YJYAH5Oj8oTOcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xs8iJ+j6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xs8iJ+j6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949F21F00A3D;
	Tue,  8 Sep 2026 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788893631;
	bh=P4kHQjrrHMFv3HGtQzY14qvjs8AOBNvOdtt5mc4t0iY=;
	h=Date:To:From:Subject;
	b=xs8iJ+j6APYdIFozYrfTu2VHPwJcvvOHQTmo3h7OlCb14ffnm2kIDNqsy71e7HupB
	 C6aa8ZxmcyU54kUSv8yNWqNS38RTHqGBkq5G1CZufot5wcxtr87js9Ml+7V5UAd4vP
	 2vmHeTTS/+4XG+2HlJUR1yU2Y3Jsvfne/FZIl7xQ=
Date: Tue, 08 Sep 2026 11:53:51 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch added to mm-new branch
Message-Id: <20260908185351.949F21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: fix broken :ref: usage and a typo
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: Docs/mm/damon/design: fix broken :ref: usage and a typo
Date: Tue, 8 Sep 2026 06:52:55 -0700

The Statistics section refers readers to the DAMON sysfs interface
documentation for how to read the statistics, using a ':ref:' role. 
However, the role name has a superfluous 's' appended (':ref:s' instead of
':ref:').  Moreover, its target label 'sysfs_stats' does not exist; the
correct label is 'sysfs_schemes_stats'.  Fix both.

Also fix a typo, 'frequenceis' -> 'frequencies', in the Adaptive Regions
Adjustment section.

Link: https://lore.kernel.org/20260908135257.97523-1-sj@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-broken-ref-usage-and-a-typo
+++ a/Documentation/mm/damon/design.rst
@@ -249,7 +249,7 @@ For each ``aggregation interval``, it co
 sum of the two regions' sizes is smaller than the size of total regions divided
 by the ``minimum number of regions``, DAMON merges the two regions.  If the
 resulting number of total regions is still higher than ``maximum number of
-regions``, it repeats the merging with increasing access frequenceis difference
+regions``, it repeats the merging with increasing access frequencies difference
 threshold until the upper-limit of the number of regions is met, or the
 threshold becomes higher than possible maximum value (``aggregation interval``
 divided by ``sampling interval``).   Then, after it reports and clears the
@@ -889,7 +889,7 @@ the scheme is deactivated.  Note that, u
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
-<sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
+<sysfs_interface>`, refer to :ref:`stats <sysfs_schemes_stats>` part of the
 documentation.
 
 Regions Walking
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch
selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch

