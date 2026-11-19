Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066008;
	b=k/we6Qp5WoV6U/9cApLNDmrKg2h6MJIUBpcnwl4ZelyCMDKroKYhdjKJWuYxrDyJ5NMe
	 UUU3z9wShWtYsUadfY5RHJOVWDRAftznVX3l/YkFP2L1bI0vBjv6OuYHSvfqNpgSu+sqr
	 p9CMhbkKg3CIlrCwnYutIZNg0HJDR/JWxYXLK+TtO+qz7ENqs+/ALvjDwtwdzExQcRrTd
	 w8dathORI3wUdp9iMHFMcjhOWAc6KPTSpxleFj7uZqNr/z37jQegbfGetn9H8kawzHyyV
	 kBUq8mb+oKwThBCHYKiqe8p+YAZPc9lLa0ytlsRIajy9/3etIiPVwOBU/4EkZzIHNbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066008;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=3kn9/TBynRn3qe+AFE7PIgg1xUlEDBLrTCrqYk+73wk=;
	b=kMHyVd2WMU1y/2DtAS/t2MDNPMaDe8Uym42f/pErk0WoQZkIwp6vOgpWx8ZAoF5SxZlI
	 UAPgytGRTqjcwwZhcKaSkD05mwh16BRszisW/Zgu0WdEJlSkfCZ8gxY5AYrk/w71XoeaS
	 E1JiAz1kiGPYrvrayj6p/meOIM21EYdbCTVLN+RDtuZ5vLG8GRdrlQny6NH55Q72hdKRf
	 0jRaB4U77OEeoXAPohOojFbOv2wSy9IPPwaPbgN0eD1mXgdWaXUZxAdfytU62yUn18JU9
	 pnF+ALgq94H1mrbfrmLGGg369j9EHnKLYB2MZvKPeimCaC3BpBbCTUr18RQBVqMNenw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wmVknEhX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B541606A320
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wmVknEhX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406311F000C4;
	Thu, 19 Nov 2026 05:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066008;
	bh=3kn9/TBynRn3qe+AFE7PIgg1xUlEDBLrTCrqYk+73wk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=wmVknEhX4CAGAnO0YBRwMQO40qkf6glzg7lxXhHFlrt+fvG490BaXVJ+plPUUfTR9
	 B6gixqwFX1tzl4oR18CNYtlaX3SBlSfYWDXQXKx/SLRMmMEk6bqE5vhlBzKUJaZcB/
	 7gnKalGC6ENG3LH5khJXz2dr4XGVoPi2qCH94BoM=
Date: Wed, 18 Nov 2026 21:26:47 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ljs@kernel.org,
	cyphar@cyphar.com,cmllamas@google.com,aris@redhat.com,wakel@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261105030843.3319056-1-wakel@google.com>
References: <20261105030843.3319056-1-wakel@google.com>
Subject: + selftests-memfd-rename-local-union-semun-to-avoid-bionic-clash.patch added to mm-new branch
Message-Id: <20261119052648.406311F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/memfd: rename local union semun to avoid bionic clash
has been added to the -mm mm-new branch.  Its filename is
     selftests-memfd-rename-local-union-semun-to-avoid-bionic-clash.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-rename-local-union-semun-to-avoid-bionic-clash.patch

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
From: Wake Liu <wakel@google.com>
Subject: selftests/memfd: rename local union semun to avoid bionic clash
Date: Thu,  5 Nov 2026 03:08:43 +0000

Commit b24335521de9 ("selftests/memfd: use IPC semaphore instead of
SIGSTOP/SIGCONT") added a local definition of union semun, since glibc and
musl expect the caller to define it before calling semctl().  Bionic,
however, already defines union semun in <sys/sem.h>, so memfd_test no
longer builds against it:

  memfd_test.c:45:7: error: redefinition of 'semun'

Rename the local union to memfd_semun.  Its layout is unchanged, so it can
still be passed as the variadic semctl() argument with any C library.

Link: https://patch.msgid.link/20261105030843.3319056-1-wakel@google.com
Fixes: b24335521de9 ("selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT")
Signed-off-by: Wake Liu <wakel@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Carlos Llamas <cmllamas@google.com>

 tools/testing/selftests/memfd/memfd_test.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-rename-local-union-semun-to-avoid-bionic-clash
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -42,7 +42,13 @@
 		    F_SEAL_EXEC)
 
 #define MFD_NOEXEC_SEAL	0x0008U
-union semun {
+
+/*
+ * glibc and musl leave union semun for the caller to define, but bionic
+ * already provides it in <sys/sem.h>. Use a private name so the test
+ * builds against all of them.
+ */
+union memfd_semun {
 	int val;
 	struct semid_ds *buf;
 	unsigned short int *array;
@@ -1387,7 +1393,7 @@ static void test_sysctl_sysctl2_failset(
 static int sysctl_nested_child(void *arg)
 {
 	int pid, sem;
-	union semun semun;
+	union memfd_semun semun;
 	struct sembuf sembuf;
 
 	printf("%s nested sysctl 0\n", memfd_str);
_

Patches currently in -mm which might be from wakel@google.com are

selftests-memfd-rename-local-union-semun-to-avoid-bionic-clash.patch

