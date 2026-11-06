Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794002332;
	b=la7H8Oc/JzJLnHtGEggVNnEcnJc7cRLcTqxxv0olr+GCNwkKrVYoUhGmjb7rI+e2wM6b
	 BgEND2LfgSKaCCBz8IbqGiXSVPFS7Ir0VsabyKShRH6/RGtXRaaHGt+6vYV3//puSaPk/
	 /pu1oaREF5alOwPoSMUFa7/JBLgPg33DSfRYnH++j9fDiuhAQ9C4NIPmR03MKyfHAuC+z
	 eJX8ZUR/e8+Jc9luThG6w2KSDLgR6QTJQSybd0BnE8rUqvAWIHAowW994GL70tm2B5a2t
	 yPaXnt7K9JVa22bMQyRYPpjtLY9ZPttcB3uIB8tToeljk3YwSTwhJa+ynOXPuL6Ugtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794002332;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=n6g408vDrCw6rrS2Hml0JPvgX6V6jfcBKkI+OayBR5g=;
	b=bWFcYoSPxFRfttQTklLZAmgpH1L/4BZNKnPtfyxVGUxcWqmaATROiWGNLgeHfn7ElYOL
	 fkhwsxunQqWL3JSHPsxfumil3PB7lpc7WCOsmsNwPUKbYmE8BjF8jPOK3D4T7RDkitYAW
	 7htual2GSBKsY1DZjszyiROzBXANq9W3Lnu5a6gAy4uZidLqcRREzubVMWhzQ4VLDI6KL
	 XaYXCCwJRpHWLw6tat66jxSTsrNGJPek2ah5R7xGBjIPn7fXWzAZD1SCUDAlZszxXvV7C
	 VemoDcOrt3omg4nWUD8bOzEOV+C55W9FXUhw8LQupxIwVNdUAjhCuOmoKNGNvJgtdJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=heFq1fz8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB51F606A326
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 21:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=heFq1fz8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627DF1F0089F;
	Fri,  6 Nov 2026 21:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794002331;
	bh=n6g408vDrCw6rrS2Hml0JPvgX6V6jfcBKkI+OayBR5g=;
	h=Date:To:From:Subject;
	b=heFq1fz8vxMLKEMrAzXb1tMFZHfpIuIMViDdBZVSPewnzD6p6Z92NCIZCYvEFgei+
	 vMKorxSPUD96/Jd7CNWV/n+NG1m+9+aBvv2rXJn/4iGxU6DOs0Md6P0ygClZ396FEf
	 mJqP3q5xdo1fhi0qNSFOdqt0dqma8Cr6Nor8EA0E=
Date: Fri, 06 Nov 2026 13:58:51 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,
	tglx@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,
	mhocko@suse.com,ljs@kernel.org,lihongfu@kylinos.cn,liam@infradead.org,
	kevin.brodsky@arm.com,joey.gouly@arm.com,david@kernel.org,
	dave.hansen@linux.intel.com,clopez@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pkeys-wait-for-the-child-in-become_child.patch added to mm-new branch
Message-Id: <20261106215851.627DF1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: pkeys: wait for the child in become_child()
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-pkeys-wait-for-the-child-in-become_child.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pkeys-wait-for-the-child-in-become_child.patch

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
From: Carlos López <clopez@suse.de>
Subject: selftests/mm: pkeys: wait for the child in become_child()
Date: Fri,  6 Nov 2026 17:46:39 +0100

become_child() forks during test_pkey_alloc_exhaust() and has the parent
exit, so that the remaining tests run in the child.  However, the test
runner only waits for the original process, so it sees the test finish
early with a success status while the remaining tests keep running in the
background.  Failures after the first fork are thus not reported in the
exit status, and the remaining tests overlap with the next selftest.

Fix this by waiting for the child in the parent and exiting with its
status.  A previous fix avoided waiting, arguing that the parents would
keep holding their resources [1].  Particularly, the parent keeps the
hugetlb reservation of its test memory, so the child runs out of hugetlb
pages after a few iterations.  Avoid this by freeing the test memory
before waiting.

Link: https://lore.kernel.org/20261106164639.2959195-1-clopez@suse.de
Link: https://lore.kernel.org/all/20240419115027.3848958-1-usama.anjum@collabora.com [1]
Fixes: e1812933b17b ("x86/selftests/pkeys: Fork() to check for state being preserved")
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
---

 tools/testing/selftests/mm/protection_keys.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-pkeys-wait-for-the-child-in-become_child
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -1009,9 +1009,10 @@ static void test_pkey_syscalls_bad_args(
 	pkey_assert(err);
 }
 
-static void become_child(void)
+static void become_child(int *ptr)
 {
 	pid_t forkret;
+	int status;
 
 	forkret = fork();
 	pkey_assert(forkret >= 0);
@@ -1021,7 +1022,16 @@ static void become_child(void)
 		/* in the child */
 		return;
 	}
-	_exit(0);
+
+	/*
+	 * Wait for the child to finish the tests and pass on its result.
+	 * Free the test memory first, as it may reserve pages from the
+	 * small hugetlb pool that the child needs.
+	 */
+	free_pkey_malloc(ptr);
+	if (waitpid(forkret, &status, 0) != forkret || !WIFEXITED(status))
+		_exit(KSFT_FAIL);
+	_exit(WEXITSTATUS(status));
 }
 
 /* Assumes that all pkeys other than 'pkey' are unallocated */
@@ -1060,7 +1070,7 @@ static void test_pkey_alloc_exhaust(int
 		 * preserved across fork().
 		 */
 		if (i == NR_PKEYS*2)
-			become_child();
+			become_child(ptr);
 	}
 
 	dprintf3("%s()::%d\n", __func__, __LINE__);
_

Patches currently in -mm which might be from clopez@suse.de are

selftests-mm-pkeys-wait-for-the-child-in-become_child.patch

