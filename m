Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972832;
	b=t5LZmsbRqZgpU/P97Wi/X5TnW08zjdPtUAa2JnrKhU+DTwbsFOMC2sj2nGVIm7gu9e08
	 ZDWt2sWpsYg8nT4XqYTZAbnxzwVDTZtl4d91tGoF3zaKs4pK4K+Y2T7FYSTC+cV0RuuA2
	 YGq5RTvsielVldOkEm1EEkgpNNPQcEHjuRGvbYu1q/ghUEWfWdo7sCn2TJbRimQ+K5q/R
	 5J8OYU1N+t5w6TIPz1xCRlPrqjx+8MOOp+7LrNdg5USk4znVCemsR/Oqgz5OqObJXCUus
	 KaFxRq2h9WU0mLZrQmAe+3eb/iCjHyookm3HOa33TgnbrA/SDneXdvYPwGQ49iPGHbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972832;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jxjBhwxjDXFTwaRPm10C4WI0Tmf8n9e9Q+6ZV//oK0I=;
	b=24g0DOqVILyUYsYv5FBW7Q5xkDHH0nBn2+/caObjtyTMAXHqcN5x0kwhQqdq17NNB5TB
	 UR6CsXreETGxGWrXx9EG10X2oBu8H/FXqd9Edu77JmEj3rdOs/fMzYuwj0LfVh4AeNGXa
	 E+0UqClQt3OTLNbidGolsvo1bXVc74nY7Q5+wSfettVF0iNUqaIiklp7JsfVXlcmJA28X
	 5aO6sE0ukVhoaXjzsvEdqRiQj1+x06EYg5a7A7mOSVl1znXAu85x7Y/HIiCogA3Vkjp3T
	 Ky3KmCKS6kxPEtWPkITkKD58UqVIaEq/dHPShIZp8Vlv32+4kaeLci9XQ11FOZJmseg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uUKwNiT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F019606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 03:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uUKwNiT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2AD1F000C4;
	Wed, 18 Nov 2026 03:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794972832;
	bh=jxjBhwxjDXFTwaRPm10C4WI0Tmf8n9e9Q+6ZV//oK0I=;
	h=Date:To:From:Subject;
	b=uUKwNiT5OTy39dguYZDbatk9naH1xbKvzi2jrEwUYNb2bSFiBs+OVsxB4c/dNTNHT
	 RHE5A3Uez6rkz4e8ptZfWo9LcvExNFWM3DJH/QtAHf98pw2u78RR6iThcvN6R8MK9Q
	 NsNf4bohYZhFGN76vmjJbuOihC39Kw4xqt1xcb5I=
Date: Tue, 17 Nov 2026 19:33:51 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ljs@kernel.org,
	david@kernel.org,chenxionggui@lanxincomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch added to mm-new branch
Message-Id: <20261118033352.0D2AD1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: handle implicit read permissions in madv_populate
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch

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
From: Xionggui Chen <chenxionggui@lanxincomputing.com>
Subject: selftests/mm: handle implicit read permissions in madv_populate
Date: Tue, 17 Nov 2026 07:06:06 +0000

The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.

On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
with PROT_WRITE.  MADV_POPULATE_READ checks this VMA permission, so it
succeeds and the test fails incorrectly.

Adjust the expected result for RISC-V using an architecture-specific
conditional, while preserving the existing behavior on other
architectures.

On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
while the updated test passes all 16 tests.

Link: https://lore.kernel.org/20261117070606.3752-1-evers_chen@163.com
Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>

 tools/testing/selftests/mm/madv_populate.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-handle-implicit-read-permissions-in-madv_populate
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -81,8 +81,13 @@ static void test_prot_write(void)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+#ifdef __riscv
+	ksft_test_result(ret == 0,
+			 "MADV_POPULATE_READ with PROT_WRITE\n");
+#else
 	ksft_test_result(ret == -1 && errno == EINVAL,
 			 "MADV_POPULATE_READ with PROT_WRITE\n");
+#endif
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
 	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");
_

Patches currently in -mm which might be from chenxionggui@lanxincomputing.com are

selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch

