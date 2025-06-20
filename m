Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E391C863B
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391357; cv=none; b=LuwXeytZEpIKRI1NZQnPjwd2BXAYOtfaNUZhMBwWpSDgjpJDF0Wt476IQFn4pGvn4ecjkEUwa+xmNTPmx+/9WHVaJNfdFK15NNjVdZzudxsFHkBoDt170madBgvF9pr7FA2K85q+0oiMzGVKbRXjuBxwPcCdnDmG/kANlxqrjBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391357; c=relaxed/simple;
	bh=jD0Spk8ATAiG4wxGOCdC09X1ciSqtTFZ5aoUFK9NlZE=;
	h=Date:To:From:Subject:Message-Id; b=oCOqO/GgpWMCeQRjjPjtJpfGlWusRIExY0lgjonkROKHSfTG+N1KsFgD/bToPot/uKb2ZwpWGDdqNx+3mwc5QG/rtaKCppuId4fYZcZ6tGLrrvHqBLGa+zXi+ceE754/+F+pfnMCfhRMSWchv13GkZmMtMawSHuGNrI4Ria83yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZKnbgB1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZKnbgB1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B552C4CEE3;
	Fri, 20 Jun 2025 03:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391356;
	bh=jD0Spk8ATAiG4wxGOCdC09X1ciSqtTFZ5aoUFK9NlZE=;
	h=Date:To:From:Subject:From;
	b=ZKnbgB1lJ0yGx36qut5DbeqmGwXHEOsK77mnDPrzPTc7AMdCOnOMBt1aAL61C3VgA
	 6tXPl8tDWir9T55HGPBwixAjTcEuRTOZODytT4KujoOUwXjbqcamrvmirYS+4W+aHj
	 6Etp9nE3yMYnaQIRbtpg3oXATphIp7op1ARB89fk=
Date: Thu, 19 Jun 2025 20:49:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,pulehui@huawei.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,broonie@kernel.org,aishwarya.tcv@arm.com,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch removed from -mm tree
Message-Id: <20250620034916.7B552C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip uprobe vma merge test if uprobes are not enabled
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: selftests/mm: skip uprobe vma merge test if uprobes are not enabled
Date: Tue, 10 Jun 2025 13:22:09 +0100

If uprobes are not enabled, the test currently fails with:

7151 12:46:54.627936  # # #  RUN           merge.handle_uprobe_upon_merged_vma ...
7152 12:46:54.639014  # # f /sys/bus/event_source/devices/uprobe/type
7153 12:46:54.639306  # # fopen: No such file or directory
7154 12:46:54.650451  # # # merge.c:473:handle_uprobe_upon_merged_vma:Expected
read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type) (1) == 0 (0)
7155 12:46:54.650730  # # # handle_uprobe_upon_merged_vma: Test terminated by assertion
7156 12:46:54.661750  # # #          FAIL  merge.handle_uprobe_upon_merged_vma
7157 12:46:54.662030  # # not ok 8 merge.handle_uprobe_upon_merged_vma

Skipping is a more sane and friendly behavior here.

Link: https://lkml.kernel.org/r/20250610122209.3177587-1-pfalcato@suse.de
Fixes: efe99fabeb11 ("selftests/mm: add test about uprobe pte be orphan during vma merge")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reported-by: Aishwarya <aishwarya.tcv@arm.com>
Closes: https://lore.kernel.org/linux-mm/20250610103729.72440-1-aishwarya.tcv@arm.com/
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by : Donet Tom <donettom@linux.ibm.com>
Reviewed-by : Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/merge.c~selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled
+++ a/tools/testing/selftests/mm/merge.c
@@ -470,7 +470,9 @@ TEST_F(merge, handle_uprobe_upon_merged_
 	ASSERT_GE(fd, 0);
 
 	ASSERT_EQ(ftruncate(fd, page_size), 0);
-	ASSERT_EQ(read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type), 0);
+	if (read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type) != 0) {
+		SKIP(goto out, "Failed to read uprobe sysfs file, skipping");
+	}
 
 	memset(&attr, 0, attr_sz);
 	attr.size = attr_sz;
@@ -491,6 +493,7 @@ TEST_F(merge, handle_uprobe_upon_merged_
 	ASSERT_NE(mremap(ptr2, page_size, page_size,
 			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr1), MAP_FAILED);
 
+out:
 	close(fd);
 	remove(probe_file);
 }
_

Patches currently in -mm which might be from pfalcato@suse.de are


