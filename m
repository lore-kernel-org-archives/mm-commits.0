Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867267;
	b=1f6mpMebN9b5ts30GcOfc8ikQnJDBkR0ILteDgGZP6rxtNBAh0nPY9cCy9TfPamw7W40
	 NeufpvcjEYrHGRPB3pdZ6f7+q2Wptzj2j/phFxWOXiTWviEGskc7nwIMJtDeiGPML853+
	 /60aaERnvPqBjAXdJxcd7bkFHpXlkGf/GMq6QtblSajpu03OmhtsEulZvWnJSIgqfFPIu
	 nUDUcXq2nu0q4kJNZjBnNSbj+Igbc9p/6sDoqjxddzVXDLGxx2nuTNXG69mwS3oNjzHSz
	 OyX46S7hFv2RQSim9KDcjPi164PaVIJz5fU22pjJKQV+UEW2gK1sSfz5zApRd9s1YWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867267;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HpPUiKoEEeRdBy8lKHpIjbvWx4Yo7D5PzenqX1DTC64=;
	b=vXV+CAorMSazB6iNe7O6AFoN/cfUDKfgC2gCgBUw76ZIwsiPx/OJzYcGGvpWehyyVtSm
	 ubaCLPLSHaqnk8JVmruRWmXTXmBACyQDXz5azW6iHf8TvR22Gql4Qz9F2VmymFEUJmOE1
	 DcP0A4OuMRweJF4I6yJW+0/fdAmx3pu67gLZe63h9NXbLiLGGov2N+1fCDgxjrZPIGqli
	 VnEO81wsIUwOIUBeLkjLIUjNSrJNG/LgbQBs2c4mAWWP8xDtomqUDrZFkr2qMX1eDD+J4
	 UQzPJ5bqBIIEbQ/XnTJSSLo7RdnwolBXHIQhplLjLlT6i/h1r4RMsce21DYgnxsNraA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xsrLs+7W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3149A606A886
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 22:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xsrLs+7W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48BD1F000C4;
	Mon, 16 Nov 2026 22:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794867267;
	bh=HpPUiKoEEeRdBy8lKHpIjbvWx4Yo7D5PzenqX1DTC64=;
	h=Date:To:From:Subject;
	b=xsrLs+7Wc+qDIcv3saGunUZsn/u7XxHDjEXI6Vg9mlsnruHAoaziaGRNG9m2kzeQV
	 GuU1O6uyMEZ0UMwqMUOVLr9HEiP6k2udMZMuncw8JdytTT1FofI9rKty0mSOsFjlv+
	 t5KuNSWXdcrUkGtGrs/2lPqK3Y/FYaeXQiC+Odz4=
Date: Mon, 16 Nov 2026 14:14:26 -0800
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,shuah@kernel.org,
	oleg@redhat.com,legion@kernel.org,ldv@strace.io,evgsyr@gmail.com,
	bradley.morgan@linux.dev,renzo@cs.unibo.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values.patch added to mm-nonmm-unstable branch
Message-Id: <20261116221426.E48BD1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/ptrace: check that PTRACE_SET_SYSCALL_INFO rejects invalid error values
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values.patch

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
From: Renzo Davoli <renzo@cs.unibo.it>
Subject: selftests/ptrace: check that PTRACE_SET_SYSCALL_INFO rejects invalid error values
Date: Mon, 16 Nov 2026 14:40:46 +0100

At every exit stop of the set_syscall_info test, try to set with is_error
set a few values outside [-MAX_ERRNO, -1], check that
PTRACE_SET_SYSCALL_INFO fails with ERANGE and that the return value of the
system call is left untouched.

Link: https://lore.kernel.org/20261116134050.505355-3-renzo@cs.unibo.it
Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dmitry V . Levin <ldv@strace.io>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Eugene Syromyatnikov <evgsyr@gmail.com>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>

 tools/testing/selftests/ptrace/set_syscall_info.c |   51 ++++++++++++
 1 file changed, 51 insertions(+)

--- a/tools/testing/selftests/ptrace/set_syscall_info.c~selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values
+++ a/tools/testing/selftests/ptrace/set_syscall_info.c
@@ -126,6 +126,54 @@ check_psi_exit(struct __test_metadata *_
 	}
 }
 
+/* Error values that PTRACE_SET_SYSCALL_INFO must reject with ERANGE. */
+static const long long bad_error_rval[] = {
+	0,
+	1,
+	ESRCH,
+	-4095 - 1,	/* -MAX_ERRNO - 1 */
+	-2147483647LL - 1,
+#if __SIZEOF_LONG__ > 4
+	0x100000000LL,
+	-0x100000000LL - ESRCH,
+#endif
+};
+
+static void
+check_psi_exit_bad_rval(struct __test_metadata *_metadata,
+			const struct ptrace_syscall_info *orig,
+			const struct si_exit *exp_exit)
+{
+	struct ptrace_syscall_info info;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(bad_error_rval); ++i) {
+		info = *orig;
+		info.exit.is_error = 1;
+		info.exit.rval = bad_error_rval[i];
+		ASSERT_EQ(-1, sys_ptrace(PTRACE_SET_SYSCALL_INFO,
+					 tracee_pid, sizeof(info),
+					 (uintptr_t) &info)) {
+			LOG_KILL_TRACEE("PTRACE_SET_SYSCALL_INFO: error rval %lld accepted",
+					bad_error_rval[i]);
+		}
+		ASSERT_EQ(ERANGE, errno) {
+			LOG_KILL_TRACEE("PTRACE_SET_SYSCALL_INFO: error rval %lld: %m",
+					bad_error_rval[i]);
+		}
+
+		/* the return value must be left untouched */
+		memset(&info, 0, sizeof(info));
+		info.op = 0xff;
+		ASSERT_LT(0, sys_ptrace(PTRACE_GET_SYSCALL_INFO, tracee_pid,
+					sizeof(info), (uintptr_t) &info)) {
+			LOG_KILL_TRACEE("PTRACE_GET_SYSCALL_INFO: %m");
+		}
+		check_psi_exit(_metadata, &info, exp_exit,
+			       "PTRACE_SET_SYSCALL_INFO with bad error rval");
+	}
+}
+
 TEST(set_syscall_info)
 {
 	const pid_t tracer_pid = getpid();
@@ -476,6 +524,9 @@ TEST(set_syscall_info)
 				check_psi_exit(_metadata, &info, exp_exit,
 						"PTRACE_GET_SYSCALL_INFO #1");
 
+				/* invalid error values must be rejected */
+				check_psi_exit_bad_rval(_metadata, &info, exp_exit);
+
 				/* apply the changes */
 				info.exit.is_error = set_exit->is_error;
 				info.exit.rval = set_exit->rval;
_

Patches currently in -mm which might be from renzo@cs.unibo.it are

ptrace-reject-out-of-range-error-values-in-ptrace_set_syscall_info.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values.patch

