Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D94140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189495; cv=none; b=XkuQPBMLCRFTFlplvoePPhY0YGcOV1VgLpDp8aO2qnlY9JKFTDVnwxzdoK1XC71cHdNnXHigTm3hcFkxW3r0GLwQ+3OZXaSOTA+YP2cYfWPLY4d7hbXrkttWZo0ZoD8PvtTALJqLEj4fn5400SIiMXs6QWszYsCIq9KyxC0gwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189495; c=relaxed/simple;
	bh=Ug+ezvnLNqo0z6yyXeDEjBMeDfK1uybZVCZJJZAThfU=;
	h=Date:To:From:Subject:Message-Id; b=fWZBLRl5wGm7j2WfGwCv27xAQk0pfMM1XUhxdhRaIYT+gFkvToG+C+2+Pmgm7F0TXi3Gb6X14eco7bW0lHFOD1cP097HKcwRHzZRgopEqmrRnWCK9Fcc/IWOkmmmkFlAgaBdZDJZXk79KpObnurZJ32qGSvJZSdUwydjWZ7xCWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rXichRxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rXichRxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E00C4CEEC;
	Mon, 17 Mar 2025 05:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189494;
	bh=Ug+ezvnLNqo0z6yyXeDEjBMeDfK1uybZVCZJJZAThfU=;
	h=Date:To:From:Subject:From;
	b=rXichRxdnbli9C0aD27JZAqCDn+f8MYUUOZI3vzPJktSVAVUrikVdx+Rqa1bTxPdd
	 vUJ2CKgDFbHXivRBxI1OvSw2dooN/DRz9M5oAPbg4Iz+tf8eySH/P0Th4M/m45t273
	 d30JP6XhddWS0nRsdq6/K4WPSl6pyUDvlNQSTQlk=
Date: Sun, 16 Mar 2025 22:31:33 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-let-arch-decide-usable-memory-range-in-reserved-area.patch removed from -mm tree
Message-Id: <20250317053134.63E00C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: let arch decide usable memory range in reserved area
has been removed from the -mm tree.  Its filename was
     crash-let-arch-decide-usable-memory-range-in-reserved-area.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: crash: let arch decide usable memory range in reserved area
Date: Fri, 31 Jan 2025 17:08:26 +0530

Although the crashkernel area is reserved, on architectures like PowerPC,
it is possible for the crashkernel reserved area to contain components
like RTAS, TCE, OPAL, etc.  To avoid placing kexec segments over these
components, PowerPC has its own set of APIs to locate holes in the
crashkernel reserved area.

Add an arch hook in the generic locate mem hole APIs so that architectures
can handle such special regions in the crashkernel area while locating
memory holes for kexec segments using generic APIs.  With this, a lot of
redundant arch-specific code can be removed, as it performs the exact same
job as the generic APIs.

To keep the generic and arch-specific changes separate, the changes
related to moving PowerPC to use the generic APIs and the removal of
PowerPC-specific APIs for memory hole allocation are done in a subsequent
patch titled "powerpc/crash: Use generic APIs to locate memory hole for
kdump.

Link: https://lkml.kernel.org/r/20250131113830.925179-4-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    9 +++++++++
 kernel/kexec_file.c   |   12 ++++++++++++
 2 files changed, 21 insertions(+)

--- a/include/linux/kexec.h~crash-let-arch-decide-usable-memory-range-in-reserved-area
+++ a/include/linux/kexec.h
@@ -205,6 +205,15 @@ static inline int arch_kimage_file_post_
 }
 #endif
 
+#ifndef arch_check_excluded_range
+static inline int arch_check_excluded_range(struct kimage *image,
+					    unsigned long start,
+					    unsigned long end)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_KEXEC_SIG
 #ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
 int kexec_kernel_verify_pe_sig(const char *kernel, unsigned long kernel_len);
--- a/kernel/kexec_file.c~crash-let-arch-decide-usable-memory-range-in-reserved-area
+++ a/kernel/kexec_file.c
@@ -464,6 +464,12 @@ static int locate_mem_hole_top_down(unsi
 			continue;
 		}
 
+		/* Make sure this does not conflict with exclude range */
+		if (arch_check_excluded_range(image, temp_start, temp_end)) {
+			temp_start = temp_start - PAGE_SIZE;
+			continue;
+		}
+
 		/* We found a suitable memory range */
 		break;
 	} while (1);
@@ -497,6 +503,12 @@ static int locate_mem_hole_bottom_up(uns
 			temp_start = temp_start + PAGE_SIZE;
 			continue;
 		}
+
+		/* Make sure this does not conflict with exclude range */
+		if (arch_check_excluded_range(image, temp_start, temp_end)) {
+			temp_start = temp_start + PAGE_SIZE;
+			continue;
+		}
 
 		/* We found a suitable memory range */
 		break;
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are


