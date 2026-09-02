Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D15430DD00
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 00:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788309475; cv=none; b=px9vjCQn9NteyofBhMEvILy23aGsnhmHrGe84c3Ze3QVm3BjCgbQk6hhY+oY2Nu0put8Yjr9JaviMtyeZoVAKYlNP8nIOHWe+UPh4dF10+Tu882LHD52tZoefhqjRG7HhVmvi12krrzpcEl1TZulQB5LmHDLQtjvzmnpCUBjw6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788309475; c=relaxed/simple;
	bh=VfldkTgHkmXrRJsFuDex/m+3Pu4ryOU+74KiGQBu6uE=;
	h=Date:To:From:Subject:Message-Id; b=J11Zk0jVJRRRW3Oh3bpGfNVeFD9b+IWx9jfRI3YKpj6sy+EZ0AbywFROOYJgiArhZfGbv8JCpbE/t8nv1c/ep1xYocgwQeEaxfATtG0SjN2xwqeC4VDNMjiim8sG6QxvwZSwM/bO3xIiuFmSwcWigQVWdL2mUNOCkl3OxuiM0U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yzt5tP9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yzt5tP9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906701F000E9;
	Wed,  2 Sep 2026 00:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788309473;
	bh=m30tfsuJg6J5kY7KYLEsO1Nyhd16oRdIgqIeFc0ovSg=;
	h=Date:To:From:Subject;
	b=yzt5tP9J58hMWJlCt7CFm/vICz8VX0l9uELXzzsCksgwy7nPoT3vVo9ox7LXf+kmn
	 ugtMviSem9SLrZe4y3q5r4kGStFjWFN0L/FZq6TQKjF0J+AOkeuM1+Mpt0LkIRROi1
	 uqWjUC3IRxlP/jXZ557KJkAg2T46lGE9mPDBaHtA=
Date: Tue, 01 Sep 2026 17:37:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,almasrymina@google.com,akpm@linux-foundation.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-restore-hidden-hugetlb-reservation-scenarios.patch added to mm-new branch
Message-Id: <20260902003753.906701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: restore hidden hugetlb reservation scenarios
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-restore-hidden-hugetlb-reservation-scenarios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-restore-hidden-hugetlb-reservation-scenarios.patch

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
From: Song Hu <husong@kylinos.cn>
Subject: selftests/mm: restore hidden hugetlb reservation scenarios
Date: Tue, 14 Jul 2026 10:16:30 +0800

A stray 'continue' in the main loop of charge_reserved_hugetlb.sh made the
"more than reservation", "more than cgroup limit", and "multiple cgroups"
scenarios unreachable, so they never ran.

Remove it so the first two run again.  The third,
run_multiple_cgroup_test(), is separately broken -- a backslash
line-continuation breaks its local declarations and its hugetlb
reservation accounting does not charge as expected -- and has never run in
CI; skip it explicitly with a comment until fixed.  Also correct two `[[
"$method" == 2"" ]]` typos (harmless empty-string concatenation) to plain
`2`.

Link: https://lore.kernel.org/20260714021630.1063823-1-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |   14 +++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-restore-hidden-hugetlb-reservation-scenarios
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -439,11 +439,11 @@ for populate in "" "-o"; do
         fi
 
         # Skip populated shmem tests. Doesn't seem to be supported.
-        if [[ "$method" == 2"" ]] && [[ "$populate" == "-o" ]]; then
+        if [[ "$method" == 2 ]] && [[ "$populate" == "-o" ]]; then
           continue
         fi
 
-        if [[ "$method" == 2"" ]] && [[ "$reserve" == "-n" ]]; then
+        if [[ "$method" == 2 ]] && [[ "$reserve" == "-n" ]]; then
           continue
         fi
 
@@ -496,7 +496,6 @@ for populate in "" "-o"; do
         echo 'PASS'
 
         cleanup
-        continue
         echo
         echo
         echo
@@ -530,6 +529,15 @@ for populate in "" "-o"; do
 
         cleanup
 
+        # The "multiple cgroups" scenario (run_multiple_cgroup_test) is
+        # multiply broken and has never run in CI: a backslash
+        # line-continuation breaks its local declarations, it passes
+        # reservation sizes in bytes rather than pages (unlike
+        # run_test), and its assertions compare page counts to byte
+        # values. Skip it until properly rewritten; the two scenarios
+        # above are restored by this change.
+        continue
+
         echo
         echo
         echo
_

Patches currently in -mm which might be from husong@kylinos.cn are

selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch
selftests-mm-emit-tap-header-and-use-tap-skip-in-mremap_test.patch
selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch
selftests-mm-restore-hidden-hugetlb-reservation-scenarios.patch

