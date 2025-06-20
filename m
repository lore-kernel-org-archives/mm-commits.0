Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7796322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391351; cv=none; b=b7ovgSMhFpwvWcHW1IWDLsl6YrKDY84Pd4LsjrNUiuEcnp5zh/TAVg5QSreLCAij+MNEvGn3Quemo20dKcBZiTFO3LWq68zJcmkLKrKB6Mf0t004c+6BtDgMdQPbOxQC1FAbWNMRJmjuhrRgCQ6JP/mKTK6UPKKYqaxSeh/deNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391351; c=relaxed/simple;
	bh=EPTKMYyPGMZcxqY7g3HnnZ3MBShKy4qEoASLGZiC0pc=;
	h=Date:To:From:Subject:Message-Id; b=d44InLJRxvfyyf6PmGidtwT3j0JVYtqDHI0g5rDKGsmtF4HIQxqBlU3KaRyVdSOykCfNYU6qNuaNl3sok86WAQZIOs6L0YS3QGm9N0iMAwWT5mD3Tz09wy2ayb7b2QqIwfigDg2Oraq8pUHgNWt/BSAA6QRMYHTBu+OlASOC6wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r9+0HmlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r9+0HmlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749A4C4CEED;
	Fri, 20 Jun 2025 03:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391351;
	bh=EPTKMYyPGMZcxqY7g3HnnZ3MBShKy4qEoASLGZiC0pc=;
	h=Date:To:From:Subject:From;
	b=r9+0HmlZB/gDKedbPjZWPxC0iJGZuHRwNXNxSwUmiNo3EDXAMQuOwP+68Zr3SsxIa
	 u2Z2ivTAIj6udt44OC2D414k/VrSSb8b+pCjj3bRnCk5D69CAX14b8FFu5mKRTILwP
	 /H0OqOHEMdlsFbNLcAzNOYf87iBAS+DzQqWOcKoU=
Date: Thu, 19 Jun 2025 20:49:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,ryan.roberts@arm.com,pulehui@huawei.com,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,donettom@linux.ibm.com,broonie@kernel.org,anshuman.khandual@arm.com,aishwarya.tcv@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-add-configs-to-fix-testcase-failure.patch removed from -mm tree
Message-Id: <20250620034911.749A4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add configs to fix testcase failure
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-configs-to-fix-testcase-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: efe99fabeb11 ("selftests/mm: add test about uprobe pte be orphan during vma merge")
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

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch

