Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD363BD63B
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 02:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437639; cv=none; b=EMmZDNqDrWlL86LLXnottrbqRBuost+TUnrwu1mL+70aPP5uDvRF8V75ez28oDxbEIDDcXN3wCRyIkddWvYiRf+23YaaN1et8kryxg9ZONbHpXCpJtcKJQJ+IV3o6iiYHVTmqvnARxAtrVgkNkjH5lMHuImLkbzLJ3WdEx3QJfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437639; c=relaxed/simple;
	bh=bPXrrt+/SU3OFbSuvcIf94Y6VgJ10oOQwuUhhIR8ANI=;
	h=Date:To:From:Subject:Message-Id; b=jhPkAPWsTFx7TNy33LZvlXpNr0cMGOd80944Dd0zXuRmGYay0U5HWVSBhnS74vHhkIwoe5AWlKHfchKjee1EX5tNSOV+HL3uOBqxSV44EHavSAc5X8pLaVUWMKHJqEQtKMNTkSyP15aKJEkDZBgf2h5bVCW4UV5W4Zr/YItMtc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cbDwDIHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cbDwDIHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2942F1F000FF;
	Tue, 15 Sep 2026 02:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789437637;
	bh=2B3RZ30Y2W5f13OPZ+QzG7XwTYcCNWRK+t/1kKy1Igs=;
	h=Date:To:From:Subject;
	b=cbDwDIHTDUoa1nVz0nahP40KSP6JaOhqtRA2S+HwVBApDWRi1Di1cd2bEh+rhWKzj
	 J2sPDngZ5TUobUH1CF28urImApyNVrWFjhJEWkE9LjLDUZWETWwsVzfLcY7EEspWdn
	 f9U3/f3ksaGLjU/9NTHxGWuHSGglXR3rLmRVcxMk=
Date: Mon, 14 Sep 2026 19:00:36 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-ignore-test-generated-damon_dump_output.patch added to mm-new branch
Message-Id: <20260915020037.2942F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: ignore test-generated damon_dump_output
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-ignore-test-generated-damon_dump_output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-ignore-test-generated-damon_dump_output.patch

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
Subject: selftests/damon: ignore test-generated damon_dump_output
Date: Mon, 14 Sep 2026 07:19:47 -0700

sysfs.py and sysfs_no_op_commit_break.py dump the DAMON status collected
via drgn_dump_damon_status.py into a damon_dump_output file in the working
directory.  Ignore it so that running the tests in-tree does not pollute
git status.

Link: https://lore.kernel.org/20260914141952.91465-3-sj@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/damon/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-ignore-test-generated-damon_dump_output
+++ a/tools/testing/selftests/damon/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 access_memory
 access_memory_even
+damon_dump_output
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch
selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch
selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch
selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch
selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch
selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch

