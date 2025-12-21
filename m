Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F068C309F08
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766343474; cv=none; b=P82/tflAdChFCvUeH1v5KHdPEZARShl/4ZmY4BbTbfiIPQ/LBBsgftw19X4YBggje5vBspn0naXti4M2mxcN8iQyU1ADye3pfBD+yiO/7Cd+gwzAIUUAH9TudeSELon4gKS8iIBkZja7kjPYsXu8n2iF2EQbIthKTC2heuadC/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766343474; c=relaxed/simple;
	bh=+Il/o3wReervpikegWg5O/lMMB4tF1JOnPSTlKQ1c60=;
	h=Date:To:From:Subject:Message-Id; b=pixuBOyMq3bscUj3mLwLKRu0BGUYsX4ug4/UOmtm1JCo3k/nH8ZK1TBYPGR2caSwMMP1aVd8tWtjZELubzSCOOQmVVmZRPLp/pYCs1tZ5jnhCB4wxhRY/eJjLVAILAM8LUOfgUlGvjz8dRGdITktA6OKYjq5LyKDQxVBGywJqp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=geJrupDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="geJrupDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC55C4CEFB;
	Sun, 21 Dec 2025 18:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766343473;
	bh=+Il/o3wReervpikegWg5O/lMMB4tF1JOnPSTlKQ1c60=;
	h=Date:To:From:Subject:From;
	b=geJrupDW+g7W8jUFQqKyGYN//SV0X3hU0yUhifm9HqqATCaT+0iuU13sriKJymG0Y
	 2Gdk/ZEBCFsGUVMLwAw3rj5O7MEfoTlb1EgIl2uqS7SD/NNjoU7DvSMct+jYqF0zi8
	 kG8lO72E1GJooDhknCuhrs4RL8UtWyFEM0BTOre8=
Date: Sun, 21 Dec 2025 10:57:52 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-comment-for-check_test_requirements.patch added to mm-new branch
Message-Id: <20251221185753.2CC55C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix comment for check_test_requirements
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-comment-for-check_test_requirements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-comment-for-check_test_requirements.patch

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
Subject: selftests/mm: fix comment for check_test_requirements
Date: Sun, 21 Dec 2025 12:00:25 +0800

The test supports arm64 as well so the comment is incorrect.  And there's
a check for arm64 in va_high_addr_switch.c.

Link: https://lkml.kernel.org/r/20251221040025.3159990-5-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Fixes: 983e760bcdb6 ("selftest/mm: va_high_addr_switch: add ppc64 support check")
Fixes: f556acc2facd ("selftests/mm: skip test for non-LPA2 and non-LVA systems")
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

 tools/testing/selftests/mm/va_high_addr_switch.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-fix-comment-for-check_test_requirements
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -61,9 +61,9 @@ check_supported_ppc64()
 
 check_test_requirements()
 {
-	# The test supports x86_64 and powerpc64. We currently have no useful
-	# eligibility check for powerpc64, and the test itself will reject other
-	# architectures.
+	# The test supports x86_64, powerpc64 and arm64. There's check for arm64
+	# in va_high_addr_switch.c. The test itself will reject other architectures.
+
 	case `uname -m` in
 		"x86_64")
 			check_supported_x86_64
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-fix-va_high_addr_switchsh-return-value.patch
selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch
selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch
selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch
selftests-mm-fix-comment-for-check_test_requirements.patch

