Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D162343C9
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585929; cv=none; b=nnuiS2l1oUbg9C0uEPOrxIKQ9Gfsr4B9PSMMk8HQXGqw72/1LP34WY6I0aEYoBOCFucRQnYKNEGetmTAyXRR701tsWUpfh93O27znTvCZUB9aOIbFR504+eUxAKCU9RMy4sEV1JwmJO7sRyCcHj2hK5LXAS3Ld12QcdyDyG7Eus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585929; c=relaxed/simple;
	bh=gRsM1htBgBIoZBlgx9lLNJ1UnVRAB/dM6Dz3DuzAouY=;
	h=Date:To:From:Subject:Message-Id; b=YoaUZ8McYPsDV/GhbmeFsU4GAZ38XVO6XsSu7WXJKk8MBKBllu3u7y0zCjsdf9TFWEqYrlx4N1Xvibk9AhdZgej8C/H2hSDe/zPJkUwrDfpqpDynzpi/5nh1i6wfBAELQ4lQXh+/gKxtQzS57CkD3bm8poy3iPGVMHpmeYsP5l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ObjENwsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ObjENwsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD48C4CEED;
	Tue, 10 Jun 2025 20:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749585929;
	bh=gRsM1htBgBIoZBlgx9lLNJ1UnVRAB/dM6Dz3DuzAouY=;
	h=Date:To:From:Subject:From;
	b=ObjENwsfhwBD9C7J/qpAHzGKfGdetuXbbqWdjXEIsZkQ2QydCMcxdYlW3Pnihgna/
	 +vr5zGVQ+3/CarDNDFdumshyW14z9Zg6gsyKyoOE0B3i8d6JXO9okVgzPzwzLza1SB
	 T5LresUZXk8em+IygSzB3TnhY24bs2sSlxr59mws=
Date: Tue, 10 Jun 2025 13:05:28 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,pulehui@huawei.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,broonie@kernel.org,aishwarya.tcv@arm.com,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch added to mm-new branch
Message-Id: <20250610200528.DFD48C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip uprobe vma merge test if uprobes are not enabled
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Fixes: efe99fabeb11b ("selftests/mm: add test about uprobe pte be orphan during vma merge")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reported-by: Aishwarya <aishwarya.tcv@arm.com>
Closes: https://lore.kernel.org/linux-mm/20250610103729.72440-1-aishwarya.tcv@arm.com/
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Pu Lehui <pulehui@huawei.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/merge.c~selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled
+++ a/tools/testing/selftests/mm/merge.c
@@ -477,7 +477,9 @@ TEST_F(merge, handle_uprobe_upon_merged_
 	ASSERT_GE(fd, 0);
 
 	ASSERT_EQ(ftruncate(fd, page_size), 0);
-	ASSERT_EQ(read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type), 0);
+	if (read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type) != 0) {
+		SKIP(goto out, "Failed to read uprobe sysfs file, skipping");
+	}
 
 	memset(&attr, 0, attr_sz);
 	attr.size = attr_sz;
@@ -498,6 +500,7 @@ TEST_F(merge, handle_uprobe_upon_merged_
 	ASSERT_NE(mremap(ptr2, page_size, page_size,
 			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr1), MAP_FAILED);
 
+out:
 	close(fd);
 	remove(probe_file);
 }
_

Patches currently in -mm which might be from pfalcato@suse.de are

selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch

