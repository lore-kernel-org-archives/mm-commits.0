Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793594259;
	b=atONNYAdd1qNElk90sx2L5QKgHmWPmQmbuDwa6iYCSratC5X3t3Ne1hG/ufdHgiuusw5
	 Cp2WjSqIztLsdkYTBmWAP+e8CxeEqlp4AFWwsz4+aEn7vs6b03bnx9fPvxYxvqkwUfEk9
	 0epROC9EbuXouCYTql5jkrZ5vLIcO+ZwcXTcwQVolMoxUzp78vDpezV237TQ01j6E7WBZ
	 gZvvWql/wUplYqzo25tMYpE+5/htzhrU5i9AwN1BM1IVSrx25EKS3AwhlucTO3APvm/pb
	 QmUC68Sn19FSzk3Z4KXMPC5ZvhNQ5FHSpvy53Wg7qHVy+Q0gZRI1LCdACh5U+Q4jGfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793594259;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ag0QmLBKOgk9VYZVmkElRg78WbSRQ61t7dBIRj1Cfdw=;
	b=v2UmVMwF8NmxMNhhvyVylKX746kout+ywJvpBoB3AS2LIOxvf/Y3LKiIZyBOUvNBRz/c
	 mvLP2U9eEJIuRIm0jz2bgZZoiGSjzU0slIF+FbcWjqZzsYHf8wKE0og+/5gGWxWVL7LMI
	 MvAVzHYGzCjD0zjpNDhw1uOj4NVw5WisTisNbD+9v8LA3ifQl3jh/axwsW9wGvExb04R5
	 ATpgzZZ2A/JHoJ9ZP22MG5ENN3/ou5KKJJVCR3iosGReY728HfL9aSl1qL/uURdoyJD3G
	 LkIDlfuK5NGTEAkZwGS0Ir6sCZigXkv8plKo1xTMUN1JLqe3i4or8jXV+mFN9lOH2FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AcZH3Cu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C43606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 04:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AcZH3Cu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C160A1F000C1;
	Mon,  2 Nov 2026 04:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793594258;
	bh=Ag0QmLBKOgk9VYZVmkElRg78WbSRQ61t7dBIRj1Cfdw=;
	h=Date:To:From:Subject;
	b=AcZH3Cu7709n1tb3Dc10qfR8YLIiRUV8WK7TA0GdF84CaezaehW/RxvS1gflow/X9
	 /d5eMMAG/g1O6DOY4CA/Wsn88M80FAdDcRkH7zGrKM6B/9ioSZU2eqv2063IBzFLEM
	 bczyU1dyXBi4e0zMwVeM1Kp75C/PIbQ6IfKcK5CM=
Date: Sun, 01 Nov 2026 20:37:38 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lukas.bulwahn@gmail.com,
	joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,
	kolyshkin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-is_userspace-exclude-kernel-code-under-tools.patch added to mm-nonmm-unstable branch
Message-Id: <20261102043738.C160A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: checkpatch: is_userspace: exclude kernel code under tools/
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-is_userspace-exclude-kernel-code-under-tools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-is_userspace-exclude-kernel-code-under-tools.patch

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
From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: checkpatch: is_userspace: exclude kernel code under tools/
Date: Thu, 22 Oct 2026 15:44:20 -0700

Patch series "checkpatch: skip more kernel-only checks for userspace code".

Commit 99b70ece33d8 ("checkpatch: suppress strscpy warnings for
userspace tools") added is_userspace() to skip checks which only make
sense for the kernel. This series extends that to a few more checks
which produce false positives for userspace code under tools/:

 - ENOSYS: the "ENOSYS means invalid syscall nr" rule is about the
   kernel ABI; in userspace, errno == ENOSYS is the standard way to
   detect a missing syscall (e.g. to skip a selftest on older kernels);
 - AVOID_BUG: "Do not crash the kernel" does not apply to userspace,
   where BUG()/BUG_ON() are assert-like shims;
 - SSCANF_TO_KSTRTO: kstrto<type> is not available in userspace.

Running "checkpatch.pl -f" (with --strict for AVOID_BUG, which is
a CHECK in file mode) on the files under tools/ that use ENOSYS, BUG()
or sscanf() gives 699 such warnings before this series (ENOSYS: 188,
AVOID_BUG: 491, SSCANF_TO_KSTRTO: 20), and none after.

Since tools/ also contains some kernel code (test modules, Kbuild-built
mocks, rvgen templates), patch 1 makes is_userspace() return false for
those locations, so they are still subject to all the kernel checks
(this also applies to the existing strcpy/strlcpy/strncpy checks).


This patch (of 4):

is_userspace() treats everything under tools/ as userspace code, and is
used to skip checks that only make sense for the kernel. However, tools/
also contains some kernel code: test modules, Kbuild-built mocks, and
templates and golden outputs of the runtime verification monitor
generator. Such code should be subject to the same checks as the rest
of the kernel.

Explicitly exclude the known locations of kernel code under tools/.

Link: https://lore.kernel.org/20261022224426.2756960-1-kolyshkin@gmail.com
Link: https://lore.kernel.org/20261022224426.2756960-2-kolyshkin@gmail.com
Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-is_userspace-exclude-kernel-code-under-tools
+++ a/scripts/checkpatch.pl
@@ -2670,6 +2670,11 @@ sub exclude_global_initialisers {
 sub is_userspace {
     my ($realfile) = @_;
 
+    # Kernel code under tools/: test modules, mocks, code generator templates.
+    return 0 if ($realfile =~ m@^tools/testing/(?:cxl|nvdimm|crypto)/@ ||
+             $realfile =~ m@^tools/testing/selftests/(?:bpf/test_kmods|livepatch/test_modules|mm/page_frag|net/bench/page_pool)/@ ||
+             $realfile =~ m@^tools/(?:power/cpupower/debug/kernel|virtio/vhost_test|verification/rvgen)/@);
+
     return $userspace if (defined $userspace);
 
     return ($realfile =~ m@^tools/@ ||
_

Patches currently in -mm which might be from kolyshkin@gmail.com are

checkpatch-is_userspace-exclude-kernel-code-under-tools.patch
checkpatch-dont-warn-about-enosys-in-userspace-code.patch
checkpatch-dont-warn-about-bug-in-userspace-code.patch
checkpatch-dont-suggest-kstrtotype-in-userspace-code.patch

