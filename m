Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75265588F
	for <mm-commits@vger.kernel.org>; Tue,  4 Feb 2025 00:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738630547; cv=none; b=GljHzcYwzKLTYtOyCJRBNXh8bQGXWlC5fw5qbAhrgFpdvS7pLV060i0ytGCY0gEm6mXZMBTv1BF5fvzvU7Ve9Iz76+HfJsGuWqEi8xKjxnGW1xKfs8MxHZGzdaubQzsre8hvQTagq45RxggQ5SMfOFx8TNw2CzlS8zEdlguhxRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738630547; c=relaxed/simple;
	bh=gBH9P2pG3dAx+XuBZt1ZJhYNC0p1Cu4G2p65lERq2qc=;
	h=Date:To:From:Subject:Message-Id; b=S4Orut6RlOm/UHZqZrue3ZlXLD1499iKBy+9hcVBWUhv3v2aOQLK3lMkxdIKm9wfWy9wmGmP5BUhUDT3G6VhYDHYdHdFm+ggJchWJQ18m9+YrE2KSbLAw+5OWRw8xrdcjIwdji4qk3fJFjPFgmeOGitpWdmw3lTcrr5payBLv/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ou+kCY5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ou+kCY5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC46C4CEE0;
	Tue,  4 Feb 2025 00:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738630547;
	bh=gBH9P2pG3dAx+XuBZt1ZJhYNC0p1Cu4G2p65lERq2qc=;
	h=Date:To:From:Subject:From;
	b=Ou+kCY5mqNdzYb/3wsfg4R6lr1zNbRbq9hVijHFRy/NyeNhvyjOgc7fsRQjldbdUa
	 ttSsD+xUqXcdP7xkahYfjQYbE/YNudQ1fC2TKJTT26rJVwLq2ef1v+AiWBuvPHu/bM
	 zUi/TXac9YDo2uWW5D7dcK3th80Hj8pW2eEm4kbY=
Date: Mon, 03 Feb 2025 16:55:46 -0800
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-let-arch-decide-usable-memory-range-in-reserved-area.patch added to mm-nonmm-unstable branch
Message-Id: <20250204005547.0FC46C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: let arch decide usable memory range in reserved area
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-let-arch-decide-usable-memory-range-in-reserved-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-let-arch-decide-usable-memory-range-in-reserved-area.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

kexec-initialize-elf-lowest-address-to-ulong_max.patch
crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch
crash-let-arch-decide-usable-memory-range-in-reserved-area.patch
powerpc-crash-use-generic-apis-to-locate-memory-hole-for-kdump.patch
powerpc-crash-preserve-user-specified-memory-limit.patch
powerpc-insert-system-ram-resource-to-prevent-crashkernel-conflict.patch
powerpc-crash-use-generic-crashkernel-reservation.patch

