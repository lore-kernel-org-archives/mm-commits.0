Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42773419FC9
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790191395; cv=none; b=YaxpNwA2UqLKYicdP6lKA2wwyKR1hqKlitEUs8/TAB/qAP/yceJQK2Tbcd7tviFsl+KkTZefIJfICeeVpsIPKYQ/Vy7pAbWPMJiaNyJWsJPZvEX3Fpe8aYtU/51iwy6UdhkcstYZ9TLHEK1jHg3x/vDExVbo+5+44rC2Sso8ryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790191395; c=relaxed/simple;
	bh=zx1PKdHzQGOsnK9leU7j8j27LOuz8ZNIloq9n2SY/jI=;
	h=Date:To:From:Subject:Message-Id; b=U845bdJQKbtjCkLmBT0Q/Z/Ebqd+N55WPweEerUTlqYWTj+p6oXVdn/KK9QdFnkxidVP5b4Spavtuehw147WY4K8gxssJ6p1QKiR8GuLveHzv/5qvXN7vO8//fE5dS4WeiyxqPkaoLXMAyb/fMLpUJIQU0zoqf9UggzL8E0I3MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijXzIa7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijXzIa7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A2F1F000FF;
	Wed, 23 Sep 2026 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790191393;
	bh=WrXBu9g3I1wZYJiVeX0zHckDlrOzn0kD9MnGFCEup8I=;
	h=Date:To:From:Subject;
	b=ijXzIa7lpKLBRr9amgvTLPehJ/bDa1g/gtWsckLadYcEJshTInHSpOlq/4qgPYlfA
	 0qPTeLt2Au3GcxVY6SEPLaNbUQCfNfunLHVzbd/POa0MFA98BJZFikP+Rj4YZGeSMM
	 PepIoka+mXtcdDdr0qnt8n1btUnaQlguvsykg8Fo=
Date: Wed, 23 Sep 2026 12:23:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,brendan.jackman@linux.dev,ts930@dgu.ac.kr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-mlock2-errno-handling-and-false-pass-on-enosys.patch added to mm-new branch
Message-Id: <20260923192313.B4A2F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix mlock2 errno handling and false PASS on ENOSYS
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-mlock2-errno-handling-and-false-pass-on-enosys.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-mlock2-errno-handling-and-false-pass-on-enosys.patch

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
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

selftests-mm-fix-mlock2-errno-handling-and-false-pass-on-enosys.patch

