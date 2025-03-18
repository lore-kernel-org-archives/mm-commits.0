Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9201E4B2
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 02:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742266340; cv=none; b=jNLRRSkopeLYCDVDbRyAZyjvOWztFprEJZxPHddyzlajP3HEOx2PZHVhP3Lha1cywd7YcoejjZkMi19z1b0xHGeIARTj/5tjYtDzVsdyrvfFtSAHkj6mcsQGc6wJm1XgOdra9AkwaurjwM/6P63C6QvTcb+0D7oaHmpS89Z3kfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742266340; c=relaxed/simple;
	bh=6LBcN4hqE158t69ewJI60J2iyitg0h13/sp1kgqE05U=;
	h=Date:To:From:Subject:Message-Id; b=IVPRrfA3J6jmy6veaZZuGJ9n4ydVdMUoX/ZyQT/Vi77NJV+aaLsRa/WIeWFgkkgvgcf25HYNblVx44m+0YwDusder1Ni0YLGx+kVIxCFlVtu0tG3J11Lv3pR8s1MUeTWEotK1Vm1JQOsGE8mf7ocbhxWu5W8K+DB9bK0JXnSK+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EoSFG3+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EoSFG3+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEC2C4CEE3;
	Tue, 18 Mar 2025 02:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742266339;
	bh=6LBcN4hqE158t69ewJI60J2iyitg0h13/sp1kgqE05U=;
	h=Date:To:From:Subject:From;
	b=EoSFG3+tkYB0DwnRy2keULvfZZPaxbWNaD8plTA0QmYOOLtTUgls862rl+SV+TZJO
	 AkOeFiXSk2lNVrgDsNVXnBGgiR+kt2rouZm2WFSCjxUBDNcpU/fNm2imFT9+/Ui93R
	 B/dRDqRimLILxAHE0sf5WZUUZVnU5zsqFCs1B5zY=
Date: Mon, 17 Mar 2025 19:52:18 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,surenb@google.com,pasha.tatashin@soleen.com,kirill.shutemov@linux.intel.com,jeffxu@chromium.org,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,andrii@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-add-unaccepted-meminfo-entry.patch added to mm-unstable branch
Message-Id: <20250318025219.5FEC2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MM documentation: add "Unaccepted" meminfo entry
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-add-unaccepted-meminfo-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-add-unaccepted-meminfo-entry.patch

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
From: Nico Pache <npache@redhat.com>
Subject: MM documentation: add "Unaccepted" meminfo entry
Date: Mon, 17 Mar 2025 17:04:03 -0600

Commit dcdfdd40fa82 ("mm: Add support for unaccepted memory") added a
entry to meminfo but did not document it in the proc.rst file.

This counter tracks the amount of "Unaccepted" guest memory for some
Virtual Machine platforms, such as Intel TDX or AMD SEV-SNP.

Add the missing entry in the documentation.

Link: https://lkml.kernel.org/r/20250317230403.79632-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/filesystems/proc.rst~documentation-add-unaccepted-meminfo-entry
+++ a/Documentation/filesystems/proc.rst
@@ -1081,6 +1081,7 @@ Example output. You may not have all of
     FilePmdMapped:         0 kB
     CmaTotal:              0 kB
     CmaFree:               0 kB
+    Unaccepted:            0 kB
     HugePages_Total:       0
     HugePages_Free:        0
     HugePages_Rsvd:        0
@@ -1255,6 +1256,8 @@ CmaTotal
               Memory reserved for the Contiguous Memory Allocator (CMA)
 CmaFree
               Free remaining memory in the CMA reserves
+Unaccepted
+              Memory that has not been accepted by the guest
 HugePages_Total, HugePages_Free, HugePages_Rsvd, HugePages_Surp, Hugepagesize, Hugetlb
               See Documentation/admin-guide/mm/hugetlbpage.rst.
 DirectMap4k, DirectMap2M, DirectMap1G
_

Patches currently in -mm which might be from npache@redhat.com are

meminfo-add-a-per-node-counter-for-balloon-drivers.patch
balloon_compaction-update-the-nr_balloon_pages-state.patch
hv_balloon-update-the-nr_balloon_pages-state.patch
xen-balloon-update-the-nr_balloon_pages-state.patch
documentation-add-unaccepted-meminfo-entry.patch

