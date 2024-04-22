Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5927C18EA1
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 21:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713820963; cv=none; b=b5eJuF0eoOMkDFE0Ct49EhnqDKKAjLyYzlEUZw6ZEU0y/DjQFc/SH+0rwSrHKIDL5YoHHhOyy/+7iyxx6WRVh1PUMG+nyFVXGTY7uVh67AjMsYbRDC20Avyi93Ik6T1AMRJPyaXjurmtJ9zekoAY5cPm77wID2PyUHvPnn5MMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713820963; c=relaxed/simple;
	bh=m4mUfbEnwlqaJBzkppconhdOv/gH3uaR3D3SRzslP8M=;
	h=Date:To:From:Subject:Message-Id; b=XCGnhBaz5jfIiclMoxq7JdEACRnwTmC/hsY563qllssLcKDknvccJSPbaJxCOiTRdsztENcLqYHx5aGyMJnZDo9Nv5KfF5D9Nakur8aeiC+7HNPcbmLLIqUu1uIdgPUbHK3Jq2I9/xqt9auO2MhsXQCqjwNQ4mKnD4aMJAZwGEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JRcDLanX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JRcDLanX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C932DC113CC;
	Mon, 22 Apr 2024 21:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713820962;
	bh=m4mUfbEnwlqaJBzkppconhdOv/gH3uaR3D3SRzslP8M=;
	h=Date:To:From:Subject:From;
	b=JRcDLanX3q/jewARI1Ujd0Vj796uEu3V4HW3XFtgcKnUkT0X+OSuHXSEPIK+viZie
	 RrXARVtEQegW5NVh6RaiZ6XSnFQCUGdjTaPXXgZ999+iDbPjoEh34+vPNpIGP5kOau
	 o/ykOq1JhrReuYHMWGSz6oBSDHClKJ69xiZd7txw=
Date: Mon, 22 Apr 2024 14:22:42 -0700
To: mm-commits@vger.kernel.org,yujie.liu@intel.com,usama.anjum@collabora.com,pedro.falcato@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-mseal-read-only-elf-memory-segment-fix-3.patch added to mm-unstable branch
Message-Id: <20240422212242.C932DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest mm/mseal: fix compile warning
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-mseal-read-only-elf-memory-segment-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-mseal-read-only-elf-memory-segment-fix-3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
selftest-mm-mseal-read-only-elf-memory-segment-fix.patch
selftest-mm-mseal-read-only-elf-memory-segment-fix-3.patch

