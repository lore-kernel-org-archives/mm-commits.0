Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181BBBA2D
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132491; cv=none; b=BuNNTlOdNpBnOXuSFc9AOLhYzmPA91RXgeqBsGHIsClpZ1AW/MrX1M/JW+YpPnrwWV1Ygm5f+z4dxV3HY7uT0NDuMxW33kyHU9gWkGQPS2eSzt1v8J4UAhTtGZI7fcJimotGvjs4fRPCOPQzZjpyDTE8G59Ucq4LSDnSWZDlclY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132491; c=relaxed/simple;
	bh=Ja0aEZEx0rpomXYa1ys3ky3JCwbETNfPn2ddPjZfaYA=;
	h=Date:To:From:Subject:Message-Id; b=oFQeiccuOf2MhnHG1P/xKabWmG36r38oZZmPVdctmcNoHOj5fJHQ9gmST+Z+cbGXF2rOTSsihcZXFqT2+Tv4KnWDwecUU26HERs2sCzwp3AiZDMqhZ7mbM8vZKT7um8dydpLgbMexD0maNKjHekytPhpMyjjPs3+FZWPffjlIDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WeQoru3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WeQoru3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87356C4CEEA;
	Tue,  4 Mar 2025 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741132490;
	bh=Ja0aEZEx0rpomXYa1ys3ky3JCwbETNfPn2ddPjZfaYA=;
	h=Date:To:From:Subject:From;
	b=WeQoru3EuGUIX+0uXlvCVYZhil91jVTQikf+K96oFtHdkGymN3V4EgO+tBvQtb9Z0
	 QxZJyc3tsC5RwvGYl5HieKZ+zbPP7aBpiTnp50j8ztPsH87gH554H8xeAodhNLLOkM
	 53EVsVaesg4HVUBfKyb8DNkIC+wnT8F4IPS2ev48=
Date: Tue, 04 Mar 2025 15:54:50 -0800
To: mm-commits@vger.kernel.org,rick.p.edgecombe@intel.com,kirill.shutemov@linux.intel.com,jxgao@google.com,ebiederm@xmission.com,dave.hansen@intel.com,bhe@redhat.com,Ashish.Kalra@amd.com,yan.y.zhao@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch added to mm-nonmm-unstable branch
Message-Id: <20250304235450.87356C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core: accept unaccepted kexec segments' destination addresses
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch

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
From: Yan Zhao <yan.y.zhao@intel.com>
Subject: kexec_core: accept unaccepted kexec segments' destination addresses
Date: Fri, 13 Dec 2024 17:54:49 +0800

In TDX, to run a linux guest, TDs (hardware-isolated VMs) must accept
before accessing private memory.  Accessing private memory before
acceptance is considered a fatal error and may result in the termination
of the TD.

The "accepting memory" operation in guest includes the following steps:
- trigger a VM-exit
- the host OS allocates a physical page and requests hardware to map the
  physical page to the GPA.
- initialize memory content to 0.
- encrypt the memory

For a Linux guest, eagerly accepting all memory during kernel boot can
slow down the boot process and cause unnecessary memory occupation on the
host for pages that may never be accessed.  Therefore, Linux guests
usually opt for a lazy mode to delay page acceptance operations by not
moving the pages to the buddy allocator's freelists.  Instead, the kernel
tracks memory in 4M units and places them in a zone->unaccepted_pages list
if any page in the entire 4M range is in an unaccepted state (even if part
of the memory range may have been accepted by firmware or the kernel). 
When the kernel does not have enough free pages, it will move memory from
the zone->unaccepted_pages list and accept it, ensuring that the memory is
accepted before moving it to the freelists and being available to the
buddy allocator.

The kexec segments' destination addresses are not allocated by the buddy
allocator.  Instead, they are searched from normal system RAM (top-down or
bottom-up) and exclude driver-managed memory, ACPI, persistent, and
reserved memory...  Although these addresses may fall within the memory
range managed by the buddy allocator (which must be in an accepted state),
they could also be outside that range and in an unaccepted state.

Since the kexec code will access the segments' destination addresses
during the kexec process by swapping their content with the segments'
source pages, it is necessary to accept the memory before performing the
swap operations.

Accept the destination addresses during the kexec load, immediately after
they pass sanity checks.  This ensures the code is located in a common
place shared by both the kexec_load and kexec_file_load system calls.

This will not conflict with the accounting in try_to_accept_memory_one()
since the accounting is set during kernel boot and decremented when pages
are moved to the freelists.  There is no harm in invoking accept_memory()
on a page before making it available to the buddy allocator.

No need to worry about re-accepting memory since accept_memory() checks
the unaccepted bitmap before accepting a memory page.

Although a user may perform kexec loading without ever triggering the
jump, it doesn't impact much since kexec loading is not in a
performance-critical path.  Additionally, the destination addresses are
always searched and found in the same location on a given system.

Changes to the destination address searching logic to locate only memory
in either unaccepted or accepted status are unnecessary and complicated.

Link: https://lkml.kernel.org/r/20241213095449.881-1-yan.y.zhao@intel.com
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jianxiong Gao <jxgao@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/kexec_core.c~kexec_core-accept-unaccepted-kexec-segments-destination-addresses
+++ a/kernel/kexec_core.c
@@ -210,6 +210,16 @@ int sanity_check_segment_list(struct kim
 	}
 #endif
 
+	/*
+	 * The destination addresses are searched from system RAM rather than
+	 * being allocated from the buddy allocator, so they are not guaranteed
+	 * to be accepted by the current kernel.  Accept the destination
+	 * addresses before kexec swaps their content with the segments' source
+	 * pages to avoid accessing memory before it is accepted.
+	 */
+	for (i = 0; i < nr_segments; i++)
+		accept_memory(image->segment[i].mem, image->segment[i].memsz);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from yan.y.zhao@intel.com are

kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch

