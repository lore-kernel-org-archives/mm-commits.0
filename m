Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F886566A
	for <mm-commits@vger.kernel.org>; Sat, 14 Jun 2025 00:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749861564; cv=none; b=bjAebpdHOfoRJ3YkimcBYJcYmd73uYy2kVQThxifegEwW7Wps9vilsQltwIOpI+vYabFmooFfOCzs9NTDucZFbQuHL0u7+kWOHMJ1xGHlWFmjqBgYHAqQM5atEwQnIdeA//Gzn/l+2PdPBBeBALQAqh9/BVCrrbE4nDuiqwXI+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749861564; c=relaxed/simple;
	bh=EBn6XYQJ36kPWp1uIvkslJ4EdwLxEvAZQzniVsYIPU4=;
	h=Date:To:From:Subject:Message-Id; b=bpSpG5yOZLp108P7Eja8zR1SirP7Wi1quDmpNJr1nSnLtuWJn6M1fexauDnrPDTlatqBTwawSadu5pEKuFCeaxVC4E5ErEmAghA7XS7HnDfRXhmPteCIeYwLktbC65dV9EfYtnacEPTcqRfbnc5uz2jlmiT67e7XlSq43sYPdwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=of+doL3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="of+doL3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8AFC4CEE3;
	Sat, 14 Jun 2025 00:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749861563;
	bh=EBn6XYQJ36kPWp1uIvkslJ4EdwLxEvAZQzniVsYIPU4=;
	h=Date:To:From:Subject:From;
	b=of+doL3zKCckZ5rx+92q9vgK30WX6oTf4qnem9NLSijeh5cMwSLvJiF++h2jvTe6R
	 BZD4nvX35CxQ1mCgQK9XNaRTGP+bvQCDVSBw7RcC7m7N+bK7p0ITSKQ5VerHUEXPjq
	 dRC2jPieqnvCO4LdSaz059fcRQjUYgc/5SMpeUpo=
Date: Fri, 13 Jun 2025 17:39:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,ryan.roberts@arm.com,pulehui@huawei.com,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,donettom@linux.ibm.com,broonie@kernel.org,anshuman.khandual@arm.com,aishwarya.tcv@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-configs-to-fix-testcase-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20250614003923.8F8AFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add configs to fix testcase failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-add-configs-to-fix-testcase-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-configs-to-fix-testcase-failure.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: add configs to fix testcase failure
Date: Fri, 13 Jun 2025 09:19:12 +0530

If CONFIG_UPROBES is not set, a merge subtest fails:

Failure log:

  7151 12:46:54.627936  # # #  RUN           merge.handle_uprobe_upon_merged_vma ...
  7152 12:46:54.639014  # # f /sys/bus/event_source/devices/uprobe/type
  7153 12:46:54.639306  # # fopen: No such file or directory
  7154 12:46:54.650451  # # # merge.c:473:handle_uprobe_upon_merged_vma:Expected read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type) (1) == 0 (0)
  7155 12:46:54.650730  # # # handle_uprobe_upon_merged_vma: Test terminated by assertion
  7156 12:46:54.661750  # # #          FAIL  merge.handle_uprobe_upon_merged_vma
  7157 12:46:54.662030  # # not ok 8 merge.handle_uprobe_upon_merged_vma

CONFIG_UPROBES is enabled by CONFIG_UPROBE_EVENTS, which gets enabled by
CONFIG_FTRACE. Therefore add these configs to selftests/mm/config so that
CI systems can include this config in the kernel build. To be completely
safe, add CONFIG_PROFILING too, to enable the dependency chain
PROFILING -> PERF_EVENTS -> UPROBE_EVENTS -> UPROBES.

Link: https://lkml.kernel.org/r/20250613034912.53791-1-dev.jain@arm.com
Fixes: efe99fabeb11b ("selftests/mm: add test about uprobe pte be orphan during vma merge")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reported-by: Aishwarya <aishwarya.tcv@arm.com>
Closes: https://lore.kernel.org/all/20250610103729.72440-1-aishwarya.tcv@arm.com/
Tested-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Tested-by : Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pu Lehui <pulehui@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/config |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/config~selftests-mm-add-configs-to-fix-testcase-failure
+++ a/tools/testing/selftests/mm/config
@@ -8,3 +8,6 @@ CONFIG_GUP_TEST=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_MEM_SOFT_DIRTY=y
 CONFIG_ANON_VMA_NAME=y
+CONFIG_FTRACE=y
+CONFIG_PROFILING=y
+CONFIG_UPROBES=y
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-add-configs-to-fix-testcase-failure.patch
xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch

