Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867265;
	b=2P2BLzi39t1l+emYLgQw8N8K84h8EvgyDiTMn8hMQ7a2+JPpr2j/MKTZklPXOBqNCHZh
	 lgFqPgxglgcA8f8jacZhmwz9jM1/PCO/HjhDtUPTFmoHvOxosazAQXfvC1pq+PE4FgCGr
	 lnfhsaV8WXh7K8nVB1z566sJT8AYvCPAioKCww9/DR37Xf3NHzaSYGnW8cBTIHc8sH1f/
	 QLxOUHZ7QKE5ZJGGEB0gGtjqYmB9Xs8oVcnlvKY5Zu+3udGj043a55fvULVE6SqL9UWLO
	 Wjbm0zLBDihjpRem+8sw0c+ccNPELi8qQkjQYjFXdrjG+rRObMwNWnbwLpR6s0ZE8SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867265;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=X0j85ybTjK0sR5lX/rcIukOhhNPDukv/oIYgFUkPYjw=;
	b=5HPVrbvv9cPsxKpj2MQJXnPFh2GiIdCIJzTwuN7hNRqioWI2VvfKrRtbWqpPuXfvCnqM
	 XlBc2grlAppu1/s2srSr6p0Zf+zjD/AkhmVVoxdgkscAUsQ7exBcybqfVS56PW41EpoXr
	 k36I//XnhBJsGJfZIlspW5RpTjmv1IvFeq6phRSoms38Z5JbRZNX7VtKFoAP+QkNyN1vO
	 pmamCsf9cBXjw8AFnIh5kMsixbqh/LzizBqwf7mw1xY2MyOnCXH/71PrDyifrsG1kD2cs
	 oqXzYcLTjNT7qJzeo2N7S6ZbQdn86xLyfUQrmj9x8y8QtnrEyd00uprprKorcaCRcnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x0zndhXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FF0606A338
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 22:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x0zndhXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56961F000C8;
	Mon, 16 Nov 2026 22:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794867264;
	bh=X0j85ybTjK0sR5lX/rcIukOhhNPDukv/oIYgFUkPYjw=;
	h=Date:To:From:Subject;
	b=x0zndhXNhttGYdFYDvlx/e3S2xJF9uKPBOIVj4KQWHHt0GNdN1UEZBV66j+osuG3o
	 9/EDS73UMWP1NzuYmoRMA+77mWjCnYA0g9kCSLmxjOPljjpFYh35rPu7QLblFj4B3/
	 firu0HVditZI4ETvPEMr76mK8SduZ+03lzbPKZqY=
Date: Mon, 16 Nov 2026 14:14:24 -0800
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,shuah@kernel.org,
	oleg@redhat.com,legion@kernel.org,ldv@strace.io,evgsyr@gmail.com,
	bradley.morgan@linux.dev,renzo@cs.unibo.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ptrace-reject-out-of-range-error-values-in-ptrace_set_syscall_info.patch added to mm-nonmm-unstable branch
Message-Id: <20261116221424.C56961F000C8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ptrace-reject-out-of-range-error-values-in-ptrace_set_syscall_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ptrace-reject-out-of-range-error-values-in-ptrace_set_syscall_info.patch

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
Subject: ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
Date: Mon, 16 Nov 2026 14:40:45 +0100

Patch series "ptrace: reject out of range error values in
PTRACE_SET_SYSCALL_INFO", v4.

With is_error set, PTRACE_SET_SYSCALL_INFO passes info.exit.rval to
syscall_set_return_value() as an "int" error without checking it: a
positive value, or on 64-bit one outside the "int" range, turns the
error into a success or is truncated.

Patch 1 rejects with -ERANGE any error value outside [-MAX_ERRNO, -1].
Patch 2 adds a test case for this to the set_syscall_info selftest.

This series is independent of the PTRACE_SET_SYSCALL_INFO seccomp skip
and SET_IP series: they apply on top of each other in either order.

Testing (x86_64, QEMU): tools/testing/selftests/ptrace/set_syscall_info
passes 1/1 with this series applied.


This patch (of 2):

With is_error set, PTRACE_SET_SYSCALL_INFO passes info.exit.rval to
syscall_set_return_value() as an "int" error without checking it: a
positive value, or on 64-bit one outside the "int" range, turns the error
into a success or is truncated.

Reject with -ERANGE any error value outside [-MAX_ERRNO, -1].

Link: https://lore.kernel.org/20261116134050.505355-1-renzo@cs.unibo.it
Link: https://lore.kernel.org/20261116134050.505355-2-renzo@cs.unibo.it
Fixes: 26bb32768fe6 ("ptrace: introduce PTRACE_SET_SYSCALL_INFO request")
Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dmitry V. Levin <ldv@strace.io>
Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Eugene Syromyatnikov <evgsyr@gmail.com>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>

 kernel/ptrace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/ptrace.c~ptrace-reject-out-of-range-error-values-in-ptrace_set_syscall_info
+++ a/kernel/ptrace.c
@@ -1111,6 +1111,10 @@ ptrace_set_syscall_info_exit(struct task
 	if (rval != info->exit.rval)
 		return -ERANGE;
 
+	/* An error must be a negative errno value. */
+	if (info->exit.is_error && !IS_ERR_VALUE(rval))
+		return -ERANGE;
+
 	if (info->exit.is_error)
 		syscall_set_return_value(child, regs, rval, 0);
 	else
_

Patches currently in -mm which might be from renzo@cs.unibo.it are

ptrace-reject-out-of-range-error-values-in-ptrace_set_syscall_info.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values.patch

