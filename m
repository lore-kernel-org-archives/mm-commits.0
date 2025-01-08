Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F242594B3;
	Wed,  8 Jan 2025 04:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311207; cv=none; b=EIbw0SW3WySwpZBCdY/39EE16fzS7s9iI1B9cMPJTHK+KdL4eENNNEYdNWO9QXJwmeKHpw4wu0m5ZNAMMTuDyTxrPQbbgyuLx0EUS3SQ57reRz7xLOyp5cfLSfk99I6Gg3S/GWoelNDXO2RddNBgS/oRKoLPQ79Q64dO3dKmuUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311207; c=relaxed/simple;
	bh=u9zHp+Wp6GYH38QTg6h3Jpfap6SRiDKYatMY/bg8K3w=;
	h=Date:To:From:Subject:Message-Id; b=W8UEhAEnTs7VVEmasllJ7amRv8jDrNPcz3/bCYI8hWNsMaj55NAwc3zrugqJvUmtWBq9sHHg+b4aptx+1lkMyhNqFKSgLauOR7Bjp+pHFNyvpspQEht0ATppnphUlu9WBfYJLjcMIXXF2kcGRM1PPYlU8brHlemD6OcAe+b0zW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M/gUHxKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M/gUHxKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE71C4CED0;
	Wed,  8 Jan 2025 04:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736311206;
	bh=u9zHp+Wp6GYH38QTg6h3Jpfap6SRiDKYatMY/bg8K3w=;
	h=Date:To:From:Subject:From;
	b=M/gUHxKET0aCgFQb7y2qdkusI5l+8rR0/HsdIhYGp1C8WcNgK1xvcz7xaKIF2GIbk
	 DEuzQivL8VTSvFAqEWMBLDoQdi+iVhrhwNFPEtXhQyIR5nmjMgymmLN3I0XxjRni6v
	 CxuWZFsOzsu6ENffdkgb7KqNk7dHnSPMcHE+8pSs=
Date: Tue, 07 Jan 2025 20:40:06 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,shuah@kernel.org,oliver.sang@intel.com,dev.jain@arm.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-virtual_address_range-avoid-reading-vvar-mappings.patch added to mm-hotfixes-unstable branch
Message-Id: <20250108044006.CCE71C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: virtual_address_range: avoid reading VVAR mappings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-virtual_address_range-avoid-reading-vvar-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-virtual_address_range-avoid-reading-vvar-mappings.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: virtual_address_range: avoid reading VVAR mappings
Date: Tue, 07 Jan 2025 16:14:46 +0100

The virtual_address_range selftest reads from the start of each mapping
listed in /proc/self/maps.

However not all mappings are valid to be arbitrarily accessed.  For
example the vvar data used for virtual clocks on x86 can only be accessed
if 1) the kernel configuration enables virtual clocks and 2) the
hypervisor provided the data for it, which can only determined by the VDSO
code itself.

Since commit e93d2521b27f ("x86/vdso: Split virtual clock pages into
dedicated mapping") the virtual clock data was split out into its own
mapping, triggering faulting accesses by virtual_address_range.

Skip the various vvar mappings in virtual_address_range to avoid errors.

Link: https://lkml.kernel.org/r/20250107-virtual_address_range-tests-v1-2-3834a2fb47fe@linutronix.de
Fixes: e93d2521b27f ("x86/vdso: Split virtual clock pages into dedicated mapping")
Fixes: 010409649885 ("selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202412271148.2656e485-lkp@intel.com
Cc: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-avoid-reading-vvar-mappings
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -116,10 +116,11 @@ static int validate_complete_va_space(vo
 
 	prev_end_addr = 0;
 	while (fgets(line, sizeof(line), file)) {
+		int path_offset = 0;
 		unsigned long hop;
 
-		if (sscanf(line, "%lx-%lx %s[rwxp-]",
-			   &start_addr, &end_addr, prot) != 3)
+		if (sscanf(line, "%lx-%lx %4s %*s %*s %*s %n",
+			   &start_addr, &end_addr, prot, &path_offset) != 3)
 			ksft_exit_fail_msg("cannot parse /proc/self/maps\n");
 
 		/* end of userspace mappings; ignore vsyscall mapping */
@@ -135,6 +136,10 @@ static int validate_complete_va_space(vo
 		if (prot[0] != 'r')
 			continue;
 
+		/* Only the VDSO can know if a VVAR mapping is really readable */
+		if (path_offset && !strncmp(line + path_offset, "[vvar", 5))
+			continue;
+
 		/*
 		 * Confirm whether MAP_CHUNK_SIZE chunk can be found or not.
 		 * If write succeeds, no need to check MAP_CHUNK_SIZE - 1
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib.patch
selftests-mm-virtual_address_range-avoid-reading-vvar-mappings.patch

