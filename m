Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588452;
	b=SblbhKg45u1Z8yf5I85F1Rv1PH9QBS1nc/PWUurfy1ye3FAWECFOZ4X93xQkZIZabngA
	 qb8z8C6btkUaYyJTrgWmlsIL49vBe7TZ9Vi2OYif7DUV35QLZIGXID5kbvVJg+vTW4LuK
	 EQzXfLWwDaq3O2SusPmV98E5enAFQxfGvvN28JeOmSwJUPK5Lk5ccIrJz00rdL72noj0v
	 mwwtTQb9F6zvdzkNbBJpvY8g687+MH9HJwazGNDT3M3J5KOxVrvfPARYonvfhKnCBJxA3
	 5bqdfyTDwH667jjVOH+ZqGA3PpuEqXd21fQ2PtBuZ5wiaq8kpt+Q/NzsElrjn6GsQDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588452;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=n/zZbeTEmtRjgltbrbK4zyGuMoWTia6UK5Mbbt+l6wk=;
	b=BCxU2oHRF1A7y15L8XuXs6YQejmhGY7BS0KMNpjEv6wtqHR0KK/t968iVRFGsg6C8wGo
	 oX4pRMliYAlXAqeKmNf5L3ZDnSOTRuiLzPS69YCQeAf5076gwBZ8KH/a9o4wmdbuqk0kG
	 J3ejmRqJltIYSp7E3FQkWBNxnw0KteSx94upDABNmeWbxJi9+Ot6NsiESvo01azMn0ULj
	 6WxwD8GdRBZTUpQBbv97VX6YhA6HMAU2YAuhddUOSD+6o/JC1XKT/Bikq9As2Sh6ZIgSV
	 fWUv+GzELU5QKLcYaCHGb3ePk0GyJPfgsFxp3MvIsc9v1BJ2F3NQ0dderTZG30Ek1jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rrKMG2NX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707D3606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 06:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rrKMG2NX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44A51F000C4;
	Wed, 25 Nov 2026 06:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795588452;
	bh=n/zZbeTEmtRjgltbrbK4zyGuMoWTia6UK5Mbbt+l6wk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=rrKMG2NX2KVfwVZ/vdBeSce8kV07AISPrp0mNREZGecFUfpe9wXzLf2dPaqPP77Sk
	 r8SNcolDk2DD43rdZT5OytpMOs5Ywq0O+FFms0OetaqAA14nhrV8CmWdyw2sxhGx4R
	 JhxYXQz3JoSoNRAG2BrGZZXgqTkzB70WbOOZKN1U=
Date: Tue, 24 Nov 2026 22:34:11 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,joe@perches.com,
	apw@canonical.com,akpm@linux-foundation.org,adobriyan@gmail.com,
	fuqingshuang@kylinos.cn
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120062933.3169112-1-fuqingshuang@kylinos.cn>
References: <20261120062933.3169112-1-fuqingshuang@kylinos.cn>
Subject: + selftests-proc-skip-fd-003-kthread-if-run-as-non-root.patch added to mm-nonmm-unstable branch
Message-Id: <20261125063411.E44A51F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/proc: skip fd-003-kthread if run as non-root
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-skip-fd-003-kthread-if-run-as-non-root.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-skip-fd-003-kthread-if-run-as-non-root.patch

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
From: Qingshuang Fu <fuqingshuang@kylinos.cn>
Subject: selftests/proc: skip fd-003-kthread if run as non-root
Date: Fri, 20 Nov 2026 14:29:33 +0800

/proc/$KERNEL_THREAD/fd can only be opened with ptrace access, so
openat() on the "fd" directory of a kernel thread returns EACCES
when the test is run as non-root.  kernel_thread_fd() conflates this
with "process is userspace process", the scan over /proc runs to
completion without finding a usable descriptor and the test exits
with 1 (KSFT_FAIL) instead of 4 (KSFT_SKIP):

  $ ./fd-003-kthread; echo $?
  1

Distinguish the two cases and skip the test like the rest of
selftests/proc does when privileges are missing, so that unprivileged
runs report "skip" instead of a false failure.

Link: https://patch.msgid.link/20261120062933.3169112-1-fuqingshuang@kylinos.cn
Fixes: b2f5de0334f0 ("tools/testing/selftests/proc: test /proc/*/fd a bit (+ PF_KTHREAD is ABI!)")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>

 tools/testing/selftests/proc/fd-003-kthread.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/proc/fd-003-kthread.c~selftests-proc-skip-fd-003-kthread-if-run-as-non-root
+++ a/tools/testing/selftests/proc/fd-003-kthread.c
@@ -36,6 +36,7 @@
  *
  * Return /proc/$PID/fd descriptor if process is kernel thread.
  * Return -1 if a process is userspace process.
+ * Return -EACCES if run as non-root.
  */
 static int kernel_thread_fd(unsigned int pid)
 {
@@ -88,6 +89,8 @@ static int kernel_thread_fd(unsigned int
 	fd = -1;
 	if (flags & PF_KHTREAD) {
 		fd = openat(dir_fd, "fd", O_RDONLY|O_DIRECTORY);
+		if (fd == -1 && errno == EACCES)
+			fd = -EACCES;
 	}
 	close(dir_fd);
 	return fd;
@@ -168,6 +171,8 @@ int main(void)
 		pid++;
 	}
 	/* EACCES if run as non-root. */
+	if (fd == -EACCES)
+		return 4;
 	if (pid >= 1024)
 		return 1;
 
_

Patches currently in -mm which might be from fuqingshuang@kylinos.cn are

selftests-proc-include-linux-mmanh-for-mremap_dontunmap.patch
selftests-proc-skip-fd-003-kthread-if-run-as-non-root.patch

