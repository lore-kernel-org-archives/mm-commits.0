Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8191CD3B
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 21:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715464223; cv=none; b=qMStk1Rkmht7O0bbPa6JotbnwLL5jVTtINQt2a3r16qD6pxFEob6/r70zwo6yrJvU4kwjjxBGVKsKS5KbXytPAEZtIfs2XHvwOkESzUHGlPWx53hz0jNrxtcBcPwNB7YJx5IyAV2gaIb2agzJvuijFp3NjreMhnS2sR/72hnw/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715464223; c=relaxed/simple;
	bh=ICEk74Sd965LZZkvCHu5P/530bI8+KH4Tquu1irfYWA=;
	h=Date:To:From:Subject:Message-Id; b=PTeM6cVdvRCWLHBgbTu//CivvuZ4WhnnehSbnHUZ9tKgciweQ/bD4pZonBX9cjoOYqxZB21VTIUEQoaHbq1XVpf23WN7AOndcCbom0vm2SDfM9+6XRDuR0c5KqSl/Wfv3NmT9A1MNGKQlmOQU8FezJ8SJxtwhMrmw+lCS2okptA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V2BG7CVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V2BG7CVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC41C2BBFC;
	Sat, 11 May 2024 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715464223;
	bh=ICEk74Sd965LZZkvCHu5P/530bI8+KH4Tquu1irfYWA=;
	h=Date:To:From:Subject:From;
	b=V2BG7CVdSKa8cNtcC/U/R3J8O/DeckoklDdz2gLnxGyjaCzIKV+87vMHdhjPB+zQY
	 W2xroLDCJhEfSMkJ0VQH99AegTNwExzX+Phvmy3Wp7cMYSl0gVhSe6OzQvvCDrOdXO
	 NKjXAinOyVxGSGOcaLPRza9JWfecACIZ43MxT2WQ=
Date: Sat, 11 May 2024 14:50:23 -0700
To: mm-commits@vger.kernel.org,yujie.liu@intel.com,usama.anjum@collabora.com,pedro.falcato@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-mm-mseal-read-only-elf-memory-segment-fix-3.patch removed from -mm tree
Message-Id: <20240511215023.8FC41C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest mm/mseal: fix compile warning
has been removed from the -mm tree.  Its filename was
     selftest-mm-mseal-read-only-elf-memory-segment-fix-3.patch

This patch was dropped because it was folded into selftest-mm-mseal-read-only-elf-memory-segment.patch

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: selftest mm/mseal: fix compile warning
Date: Sat, 20 Apr 2024 00:35:15 +0000

fix compile warning reported by test robot

Link: https://lkml.kernel.org/r/20240420003515.345982-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/r/202404190226.OfJOewV8-lkp@intel.com/
Suggested-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    3 +--
 tools/testing/selftests/mm/seal_elf.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftest-mm-mseal-read-only-elf-memory-segment-fix-3
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -79,7 +79,7 @@ static unsigned long get_vma_size(void *
 		return 0;
 
 	while (fgets(line, sizeof(line), maps)) {
-		if (sscanf(line, "%lx-%lx %4s", &addr_start, &addr_end, &protstr) == 3) {
+		if (sscanf(line, "%lx-%lx %4s", &addr_start, &addr_end, protstr) == 3) {
 			if (addr_start == (uintptr_t) addr) {
 				size = addr_end - addr_start;
 				if (protstr[0] == 'r')
@@ -208,7 +208,6 @@ static u64 set_pkey_bits(u64 reg, int pk
 
 static void set_pkey(int pkey, unsigned long pkey_value)
 {
-	unsigned long mask = (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE);
 	u64 new_pkey_reg;
 
 	new_pkey_reg = set_pkey_bits(__read_pkey_reg(), pkey, pkey_value);
--- a/tools/testing/selftests/mm/seal_elf.c~selftest-mm-mseal-read-only-elf-memory-segment-fix-3
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -105,7 +105,6 @@ static void test_seal_elf(void)
 	int ret;
 	FILE *maps;
 	char line[512];
-	int size = 0;
 	uintptr_t  addr_start, addr_end;
 	char prot[5];
 	char filename[256];
@@ -136,7 +135,7 @@ static void test_seal_elf(void)
 	 */
 	while (fgets(line, sizeof(line), maps)) {
 		if (sscanf(line, "%lx-%lx %4s %*x %*x:%*x %*u %255[^\n]",
-			&addr_start, &addr_end, &prot, &filename) == 4) {
+			&addr_start, &addr_end, prot, filename) == 4) {
 			if (strlen(filename)) {
 				/*
 				 * seal the mapping if read only.
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mseal-wire-up-mseal-syscall.patch
mseal-add-mseal-syscall.patch
selftest-mm-mseal-memory-sealing.patch
mseal-add-documentation.patch
selftest-mm-mseal-read-only-elf-memory-segment.patch
selftest-mm-mseal-read-only-elf-memory-segment-fix-4.patch

