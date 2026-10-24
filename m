Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832272;
	b=2QS/CckLKOpCtixEJZODan2YuOrJsfPWEWSnIasB4n/xHw2lXSg0CSXp4Tha//sv2mQy
	 F83iSGE7iuWJs+d0xP3VAfnKKZoWs0ESDO+b0JH6rRgJ6y/2BRCebPwZffAHQrr+RAaAZ
	 GwzLIYxOXKzh9B69OSmoAy4rDYIxmbYuxyC0vBqiSSHz7RbWa2co0iQmOxu7GJhuri5PR
	 SjxeVtiH7X/cFlxFNvMPnY5Ga0viqiUtZOt4tM2G/7FWT4epklAUbv6sPs59fRSvz10S8
	 6zxKZ9dxyGu2Z8+BQW4/uTfPYNZVNsrX4seZCOiigjyLFe//pzGdecNZ1ywstGZB6zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832272;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iyiVgTtQwPQVjnhUmhPtBpxiC2kJK4/RPFoMK3Jg3og=;
	b=YWr2nHiu8E9hXop7GrA5g1IY8XJHc1RKrMA0UVCznDf/mYryL/KWPaR3AY4ooLW2+LyM
	 Kva69cYjV07kCwNzGOpkSqe5LG+t9mODme0+yE8uCC7hcc0kqEEdMCLEA8in/NIbJBlw6
	 1Hv0nsNwbOuQ86/bRTC+zMC67XNfLTDj3Jcph8q1lPmA+W39NNxkBBfKJyg5uUiJJRCQr
	 x8cQU2LUyEgDDh5UmGlGE61SWaHqxHInz6QwCnKfF1f7VNyVZXxOcwUrgVvJ8lCQwb/pC
	 X6jUAk6wj7rYuUctetkVwNHJ3RW21Oc7aJ+j9c93ocP2ac4qk0mpAEQswdomZl9aDkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=siigPbTq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2750606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=siigPbTq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F77E1F01825;
	Sat, 24 Oct 2026 08:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832271;
	bh=iyiVgTtQwPQVjnhUmhPtBpxiC2kJK4/RPFoMK3Jg3og=;
	h=Date:To:From:Subject;
	b=siigPbTqpkzLIp5IXe9oLQXRs9pe4BVlnqE83ZhTNopFiIPfIvnqePs43wfhyQGuF
	 JxDQudJYfYkpxUq0xsLNXCZADZat+GusyuVlnvSrTqvTRALtCZOoH9VE7fplspKcAq
	 HBKc3TAOYvvTH8p55KIWhEyMbrx8e3PmhXzze2RA=
Date: Sat, 24 Oct 2026 01:57:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,brendan.jackman@linux.dev,ts930@dgu.ac.kr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-mlock2-errno-handling-and-false-pass-on-enosys.patch removed from -mm tree
Message-Id: <20261024085751.3F77E1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: fix mlock2 errno handling and false PASS on ENOSYS
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-mlock2-errno-handling-and-false-pass-on-enosys.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Park Tae-sun <ts930@dgu.ac.kr>
Subject: selftests/mm: fix mlock2 errno handling and false PASS on ENOSYS
Date: Wed, 23 Sep 2026 18:26:48 +0900

While inspecting selftests/mm syscall wrappers, I noticed that mlock2_()
in mlock2.h handles the syscall return value differently from other
wrappers:

    int ret = syscall(__NR_mlock2, start, len, flags);
    if (ret) {
        errno = ret;
        return -1;
    }

Commit 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
introduced this intending to make mlock2_() behave like libc by setting
errno and returning -1.  However, glibc syscall(2) already returns -1 on
failure and sets positive errno.  Assigning "errno = ret;" overwrites
errno with -1.

To verify this, mlock2 was disabled in the kernel (via sys_ni_syscall) to
return -ENOSYS. Testing revealed two interrelated defects:

1. In the unmodified test, mlock2_() clobbered errno to -1. The check
   "if (ret && errno == ENOSYS)" in main() was bypassed, resulting in an
   immediate crash in the first test:

       ~ # ./mlock2-tests
       TAP version 13
       1..15
       Bail out! mlock2(0): Unknown error -1
       # Planned tests != run tests (15 != 0)
       # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
       (exit code: 1 - FAIL)

2. After restoring mlock2_() to directly return syscall(), errno correctly
   retained ENOSYS (38), entering the ENOSYS check in main(). However, it
   then called ksft_finished():

       ~ # ./mlock2-tests
       TAP version 13
       # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
       ~ # echo $?
       0

   Because ksft_set_plan() had not been called yet (ksft_plan == 0) and
   zero tests ran (ksft_pass == 0), ksft_finished() evaluated 0 == 0 as
   success and exited with KSFT_PASS (code 0) without any TAP skip header.

Fix both issues by:
1. Returning the syscall() result directly in mlock2_() so that errno is
   preserved.
2. Calling ksft_exit_skip() on ENOSYS so unsupported kernels report a TAP
   skip ("1..0 # SKIP ...") and exit with KSFT_SKIP (code 4).

Verification on the mlock2-disabled kernel:

    ~ # ./mlock2-tests
    TAP version 13
    1..0 # SKIP mlock2() syscall is not supported
    ~ # echo $?
    4

Re-enabling mlock2 in the kernel confirmed all 15 tests pass cleanly:

    ~ # ./mlock2-tests
    TAP version 13
    1..15
    ok 1 test_mlock_lock: Locked
    ...
    ok 15 test_mlockall_future_droppable: droppable memory not locked
    # Totals: pass:15 fail:0 xfail:0 xpass:0 skip:0 error:0
    ~ # echo $?
    0

Link: https://lore.kernel.org/20260923-selftests-mm-mlock2-fix-v1-1-750b627854c6@dgu.ac.kr
Fixes: 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
Fixes: 65c89684896d ("selftests/mm: mlock2-tests: conform test to TAP format output")
Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
---

 tools/testing/selftests/mm/mlock2-tests.c |    2 +-
 tools/testing/selftests/mm/mlock2.h       |    8 +-------
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/mlock2.h~selftests-mm-fix-mlock2-errno-handling-and-false-pass-on-enosys
+++ a/tools/testing/selftests/mm/mlock2.h
@@ -6,13 +6,7 @@
 
 static int mlock2_(void *start, size_t len, int flags)
 {
-	int ret = syscall(__NR_mlock2, start, len, flags);
-
-	if (ret) {
-		errno = ret;
-		return -1;
-	}
-	return 0;
+	return syscall(__NR_mlock2, start, len, flags);
 }
 
 static FILE *seek_to_smaps_entry(unsigned long addr)
--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-fix-mlock2-errno-handling-and-false-pass-on-enosys
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -502,7 +502,7 @@ int main(int argc, char **argv)
 
 	ret = mlock2_(map, size, MLOCK_ONFAULT);
 	if (ret && errno == ENOSYS)
-		ksft_finished();
+		ksft_exit_skip("mlock2() syscall is not supported\n");
 
 	munmap(map, size);
 
_

Patches currently in -mm which might be from ts930@dgu.ac.kr are


