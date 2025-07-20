Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DC9C120
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977350; cv=none; b=CgUi3IAVZ9HggPVbRfNR1D2EW8lnSDiJek5Jtw2pZWJihHW4qfXAZv6zezZ4Clwnxqh9KKRWT9g93RltXdRrkmHK66hSL+VbyvlyKZXzYAcBMoMaromvb21nk7H2AJuu7FKAHUSHZ+Nz7FgW2+D9+564vmk8UB0rHCxIRkRbsrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977350; c=relaxed/simple;
	bh=CNL3bctpSFjEQ6m5ZrI88vrEM/SSGdvLVUASK0MknKY=;
	h=Date:To:From:Subject:Message-Id; b=AjjU3ybunggdohAzEEQNLx6mZbvqITtAuGGlc2SYJJJmA4cCradh6cB2gE3mNx5wV2iefB2LAkdMbapp9IKlABFscUSVnhn5sdVpu1G0Oppzbnd1dw5ZeVZbdlrgspxfwH9GwqL5uVrjKI7hLSICOAZfdM8jPoUZxtThiv1n+HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=esBtl474; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="esBtl474"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D174C4CEE3;
	Sun, 20 Jul 2025 02:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977349;
	bh=CNL3bctpSFjEQ6m5ZrI88vrEM/SSGdvLVUASK0MknKY=;
	h=Date:To:From:Subject:From;
	b=esBtl474u2GxeHKbBqxWQHW6bqTk9QFJXztTECtpMWcWTx43TNUb/9TA0r4LwJI1p
	 1vjhG4ZwF4LI1Mx1SgUwpnV1qfhXbz5PCoHez6W8Jf0E2RTbYCRQhO+kAukaUGMAcr
	 tAFK+tHo1EMkoR44I985zYVcMGE+5sv4++lePC1o=
Date: Sat, 19 Jul 2025 19:09:09 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,prudo@redhat.com,piliu@redhat.com,mhocko@suse.cz,ltao@redhat.com,dyoung@redhat.com,ddutile@redhat.com,david@redhat.com,bhe@redhat.com,jbohac@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-implement-crashkernel-cma-reservation.patch removed from -mm tree
Message-Id: <20250720020909.9D174C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: implement crashkernel cma reservation
has been removed from the -mm tree.  Its filename was
     x86-implement-crashkernel-cma-reservation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiri Bohac <jbohac@suse.cz>
Subject: x86: implement crashkernel cma reservation
Date: Thu, 12 Jun 2025 12:20:04 +0200

Implement the crashkernel CMA reservation for x86:
- enable parsing of the cma suffix by parse_crashkernel()
- reserve memory with reserve_crashkernel_cma()
- add the CMA-reserved ranges to the e820 map for the crash kernel
- exclude the CMA-reserved ranges from vmcore

Link: https://lkml.kernel.org/r/aEqp1LD2og4QeBw9@dwarf.suse.cz
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Tao Liu <ltao@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |   26 ++++++++++++++++++++++----
 arch/x86/kernel/setup.c |    5 +++--
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/crash.c~x86-implement-crashkernel-cma-reservation
+++ a/arch/x86/kernel/crash.c
@@ -163,10 +163,10 @@ static struct crash_mem *fill_up_crash_e
 		return NULL;
 
 	/*
-	 * Exclusion of crash region and/or crashk_low_res may cause
-	 * another range split. So add extra two slots here.
+	 * Exclusion of crash region, crashk_low_res and/or crashk_cma_ranges
+	 * may cause range splits. So add extra slots here.
 	 */
-	nr_ranges += 2;
+	nr_ranges += 2 + crashk_cma_cnt;
 	cmem = vzalloc(struct_size(cmem, ranges, nr_ranges));
 	if (!cmem)
 		return NULL;
@@ -184,6 +184,7 @@ static struct crash_mem *fill_up_crash_e
 static int elf_header_exclude_ranges(struct crash_mem *cmem)
 {
 	int ret = 0;
+	int i;
 
 	/* Exclude the low 1M because it is always reserved */
 	ret = crash_exclude_mem_range(cmem, 0, SZ_1M - 1);
@@ -198,8 +199,17 @@ static int elf_header_exclude_ranges(str
 	if (crashk_low_res.end)
 		ret = crash_exclude_mem_range(cmem, crashk_low_res.start,
 					      crashk_low_res.end);
+	if (ret)
+		return ret;
 
-	return ret;
+	for (i = 0; i < crashk_cma_cnt; ++i) {
+		ret = crash_exclude_mem_range(cmem, crashk_cma_ranges[i].start,
+					      crashk_cma_ranges[i].end);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int prepare_elf64_ram_headers_callback(struct resource *res, void *arg)
@@ -373,6 +383,14 @@ int crash_setup_memmap_entries(struct ki
 		ei.type = E820_TYPE_RAM;
 		add_e820_entry(params, &ei);
 	}
+
+	for (i = 0; i < crashk_cma_cnt; ++i) {
+		ei.addr = crashk_cma_ranges[i].start;
+		ei.size = crashk_cma_ranges[i].end -
+			  crashk_cma_ranges[i].start + 1;
+		ei.type = E820_TYPE_RAM;
+		add_e820_entry(params, &ei);
+	}
 
 out:
 	vfree(cmem);
--- a/arch/x86/kernel/setup.c~x86-implement-crashkernel-cma-reservation
+++ a/arch/x86/kernel/setup.c
@@ -599,7 +599,7 @@ static void __init memblock_x86_reserve_
 
 static void __init arch_reserve_crashkernel(void)
 {
-	unsigned long long crash_base, crash_size, low_size = 0;
+	unsigned long long crash_base, crash_size, low_size = 0, cma_size = 0;
 	bool high = false;
 	int ret;
 
@@ -608,7 +608,7 @@ static void __init arch_reserve_crashker
 
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 				&crash_size, &crash_base,
-				&low_size, NULL, &high);
+				&low_size, &cma_size, &high);
 	if (ret)
 		return;
 
@@ -618,6 +618,7 @@ static void __init arch_reserve_crashker
 	}
 
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
+	reserve_crashkernel_cma(cma_size);
 }
 
 static struct resource standard_io_resources[] = {
_

Patches currently in -mm which might be from jbohac@suse.cz are


