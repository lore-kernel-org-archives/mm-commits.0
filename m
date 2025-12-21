Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9991D309EF0
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766343469; cv=none; b=jWtNY0bwzFy7eh1rSLFY9okAYB7KDaXPtngKaBzbsG8yKEF68zKmwe2A3IeSWBOG8OumP8BaKI95A2+2gaLwgug09SHSnaGh1QVc+o4CXdAQ3MYcOpTvmLX4yKMZesKM/VoJSedcaza9JszHWhVBeY/On27r7ZB+YEGET/SOXFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766343469; c=relaxed/simple;
	bh=XK8THDvHTkWh+fUz/KjbkfN3O4uYs42c38EITuEzg1I=;
	h=Date:To:From:Subject:Message-Id; b=dbto85FTDx3sRFwZXLzLaCl1rv0oaRo5UUUCPNiZ8gkj5ic5xfpwOrAMTSL+HiCL2fOJiTC8s1bm4UBpN7TyWSBTsAnH9S2JqYn+UCQYitPUphaNZlGnQOT08/Et9siOBTUE4sRR3VPpdsS5arANyUD3xPekqAOIQvfKUZBssuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GS8dE3uF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GS8dE3uF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1389CC4CEFB;
	Sun, 21 Dec 2025 18:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766343469;
	bh=XK8THDvHTkWh+fUz/KjbkfN3O4uYs42c38EITuEzg1I=;
	h=Date:To:From:Subject:From;
	b=GS8dE3uFxZQYaiTtJkY5a5HK+53W4FtBhOuLbzgPIkNIgAdtc3CuSEcKZMgMsEQyn
	 +RdN3pAk8c2mdX/z1AS5/AZ3f96aSsLSGXBP5t2z/FOb2hFow1UZIe5jHR3/+vzSp9
	 yZgGt1DchHk+4V6wVYN7QHmDryp07ENYTxnvRzUw=
Date: Sun, 21 Dec 2025 10:57:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch added to mm-new branch
Message-Id: <20251221185749.1389CC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove arm64 nr_hugepages setup for va_high_addr_switch test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: remove arm64 nr_hugepages setup for va_high_addr_switch test
Date: Sun, 21 Dec 2025 12:00:23 +0800

arm64 and x86_64 has the same nr_hugepages requriement for running the
va_high_addr_switch test.  Since commit d9d957bd7b61 ("selftests/mm: alloc
hugepages in va_high_addr_switch test"), the setup can be done in
va_high_addr_switch.sh.  So remove the duplicated setup.

Link: https://lkml.kernel.org/r/20251221040025.3159990-3-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    8 --------
 1 file changed, 8 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -412,15 +412,7 @@ if [ $VADDR64 -ne 0 ]; then
 	fi
 
 	# va high address boundary switch test
-	ARCH_ARM64="arm64"
-	prev_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$ARCH" == "$ARCH_ARM64" ]; then
-		echo 6 > /proc/sys/vm/nr_hugepages
-	fi
 	CATEGORY="hugevm" run_test bash ./va_high_addr_switch.sh
-	if [ "$ARCH" == "$ARCH_ARM64" ]; then
-		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
-	fi
 fi # VADDR64
 
 # vmalloc stability smoke test
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-fix-va_high_addr_switchsh-return-value.patch
selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch
selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch
selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch
selftests-mm-fix-comment-for-check_test_requirements.patch

