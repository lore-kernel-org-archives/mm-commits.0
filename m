Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27911F4C8C
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741900932; cv=none; b=HUhtmtW7eHoh+pEzfgSnyP8CeM4xs8mD2S+wHxpM9N6qDgulyzx/7NF90Uv5NgJYzWi2E4wgl9y90v0UJ72+vg9Fmgtyh1T5pdIrXUt8PMk0xmy0PfXItSm3psIhf4lZVKYRMWK9MXyAZrwJMWwBnFrjsYSrj6OcBXzGaCD8QLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741900932; c=relaxed/simple;
	bh=soKoXa/UhLRqIsmTyznV3E+/Y30YM33373dWB2C261k=;
	h=Date:To:From:Subject:Message-Id; b=VNofzRcOUtmLMbrIFiUeqT9WHwnn7tRO9MD5V1paNcOMUc9Eje0QwayYfwKY2EDyoFvbjy/gy11DnbZBoAPKiwNA5l1yoVXT0tktnlI0SPDh+gnLkRoEax1ax9A2v+ldg4UGuXwMZYUNoSaVP4ziXv5jdddtTv58kSFtJE+At7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A59Zn6mK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A59Zn6mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C7DC4CEDD;
	Thu, 13 Mar 2025 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741900931;
	bh=soKoXa/UhLRqIsmTyznV3E+/Y30YM33373dWB2C261k=;
	h=Date:To:From:Subject:From;
	b=A59Zn6mKCnGoCZPLLkAJqL9bgnme18C5CKYMjg3WjbcwFe89GvbkMCWkL9cGLeS25
	 obdYA7jJHuSENyNZaC09QYKNtLcc9b0WY8Tec+ZU8us8QGE+0QmcbsTACSPCekAs8/
	 O1sS77nL/STHdDYqfQAk5B0DqQVNsiUdOpM/qe18=
Date: Thu, 13 Mar 2025 14:22:10 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,jxgao@google.com,ebiederm@xmission.com,dave.hansen@linux.intel.com,bhe@redhat.com,Ashish.Kalra@amd.com,yan.y.zhao@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch added to mm-nonmm-unstable branch
Message-Id: <20250313212211.37C7DC4CEDD@smtp.kernel.org>
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
Date: Fri, 7 Mar 2025 10:44:11 +0200

The UEFI Specification version 2.9 introduces the concept of memory
acceptance: some Virtual Machine platforms, such as Intel TDX or AMD
SEV-SNP, require memory to be accepted before it can be used by the guest.

Accepting memory is expensive.  The memory must be allocated by the VMM
and then brought to a known safe state: cache must be flushed, memory must
be zeroed with the guest's encryption key, and associated metadata must be
manipulated.  These operations must be performed from a trusted
environment (firmware or TDX module).  Switching context to and from it
also takes time.

This cost adds up.  On large confidential VMs, memory acceptance alone can
take minutes.  It is better to delay memory acceptance until the memory is
actually needed.

The kernel accepts memory when it is allocated from buddy allocator for
the first time.  This reduces boot time and decreases memory overhead as
the VMM can allocate memory as needed.

It does not work when the guest attempts to kexec into a new kernel.

The kexec segments' destination addresses are not allocated by the buddy
allocator.  Instead, they are searched from normal system RAM (top-down or
bottom-up) and exclude driver-managed memory, ACPI, persistent, and
reserved memory.  Unaccepted memory is normal system RAM from kernel point
of view and kexec can place segments there.

Kexec bypasses the code path in buddy allocator where memory gets accepted
and it leads to a crash when kexec accesses segments' memory.

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

Changes to the destination address searching logic to locate only memory in
either unaccepted or accepted status are unnecessary and complicated.

[kirill.shutemov@linux.intel.com: update the commit message]
Link: https://lkml.kernel.org/r/20250307084411.2150367-1-kirill.shutemov@linux.intel.com
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jianxiong Gao <jxgao@google.com>
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

