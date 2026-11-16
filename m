Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794872234;
	b=K6ZKy6SZ4AS8XXuPC4CL/YavRMjueHxTD1t0eJxqBcafIb/CHwWxKgXMes3l/EDmcFPq
	 LKrtGo5E0QOmBYvrAb0GsB3WpzYsXzWP9IWhxbK5DpaPHNL3sl4omjAwx8XSv4o2aom6+
	 11tmcjxucKZ0maL81FANytEWzsdGXEEC5gZIQ+lzB+O8Ms8QOV+NumJ6H2u9/IyH4aziM
	 Tko28NHT9lBJNbhwmO53BLpx353r0RTSRP3KvR9DRVyQMaM6e2kl9i83j4fznFlABtpsr
	 Gk9Tou4fLCGwMRXXBQFmllMVzkUL9UyMhawJKIXCU4My5UFLOClCf0GzR7XHjj6hpgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794872234;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fzO7hcUXSpqBooQH/nrZJ3avQl6xZap0WfLzbIqvy4M=;
	b=MM95bu8J1D1PTbac63+iP69iPuFMhANMjCZ6LEp2DvdQYSsCj+I5yLaeEn33e/g4MrJd
	 FioLjkxCD+Kpx5Ua2IV7i9MLtv99yWz1FTbytWWnBwIhVF+QrhgS4d1NMi68s2oG1zhlV
	 0p9faJVnCgjyWdxpWuF4ahQfkywvAc+ama3LcKV0A9fqV1embWswWYrSA6uJIfY9X+OeV
	 s8Geyp1ENevudt7wZuSyufg4PqmYvGl90eRxGk8iMU1shzQYDKW2sq895nwA2vNyt2NxP
	 HuM0Lx1BsZoqHk5lS0KwgFf44ynYcaK4suXJLYNoQSOmPDoghpln8INBFTDQTXFT0gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ef97Spep;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990A9606A33B
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 23:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ef97Spep
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326661F000C4;
	Mon, 16 Nov 2026 23:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794872234;
	bh=fzO7hcUXSpqBooQH/nrZJ3avQl6xZap0WfLzbIqvy4M=;
	h=Date:To:From:Subject;
	b=ef97SpepOAEDT7e2Ldu2+NhAffc1vfdDhHEuUyfWEJ/8/1ouiD78wNI+2rfLMKyD5
	 E5rzu+9NXPumIXUtYiXJh00v/x71bzo/MEnze+Tvp34tBm8DPeA+X9vOdA4JM40q4L
	 W6zq1uDTkGi0M5OdTh2vLEUnzOU78cPLimzUwnsA=
Date: Mon, 16 Nov 2026 15:37:13 -0800
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,shuah@kernel.org,
	renzo@cs.unibo.it,oleg@redhat.com,legion@kernel.org,ldv@strace.io,
	evgsyr@gmail.com,bradley.morgan@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261116233714.326661F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/ptrace: test the lowest valid syscall error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/ptrace: test the lowest valid syscall error
Date: Mon, 16 Nov 2026 22:27:14 +0000

PTRACE_SET_SYSCALL_INFO must reject values below -MAX_ERRNO while
accepting -MAX_ERRNO itself. Name the bound locally for this userspace
selftest, and add a successful exit-stop case at that boundary. Retain
the existing -EISDIR case. The tracee checks the resulting errno.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Renzo Davoli <renzo@cs.unibo.it>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Bradley Morgan <bradley.morgan@linux.dev>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: Dmitry V . Levin <ldv@strace.io>
Cc: Eugene Syromyatnikov <evgsyr@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>

 tools/testing/selftests/ptrace/set_syscall_info.c |   25 +++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/ptrace/set_syscall_info.c~selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix
+++ a/tools/testing/selftests/ptrace/set_syscall_info.c
@@ -15,6 +15,8 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 
+#define MAX_ERRNO 4095
+
 #if defined(_MIPS_SIM) && _MIPS_SIM == _MIPS_SIM_NABI32
 /*
  * MIPS N32 is the only architecture where __kernel_ulong_t
@@ -131,7 +133,7 @@ static const long long bad_error_rval[]
 	0,
 	1,
 	ESRCH,
-	-4095 - 1,	/* -MAX_ERRNO - 1 */
+	-MAX_ERRNO - 1,
 	-2147483647LL - 1,
 #if __SIZEOF_LONG__ > 4
 	0x100000000LL,
@@ -325,6 +327,27 @@ TEST(set_syscall_info)
 			}
 		},
 
+		/* change scno, change non-error rval to -MAX_ERRNO */
+		{
+			{
+				{
+					__NR_chdir,
+					{
+						dummy[0], dummy[1], dummy[2],
+						dummy[3], dummy[4], dummy[5]
+					}
+				}, {
+					__NR_getppid,
+					{
+						dummy[0], dummy[1], dummy[2],
+						dummy[3], dummy[4], dummy[5]
+					}
+				}
+			}, {
+				{ 0, tracer_pid }, { 1, -MAX_ERRNO }
+			}
+		},
+
 		/* change scno and all args, change non-error rval */
 		{
 			{
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

