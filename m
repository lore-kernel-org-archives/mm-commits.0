Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABCC2192EB
	for <mm-commits@vger.kernel.org>; Thu, 27 Mar 2025 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743097788; cv=none; b=W+e+PsNHgnOtUksZgP8cJP6r0Ut3jCudipqpjpGqroSvTBWL4JnPnw3G+tnklZziVwOceJdL2B9qHLmGxFcLQexXbT5CsawVe22mqdxuyJGsnbFd784DNBYXKLkPArMsvZ6pb6v7k/O2bJQZhO1oVBOLwWOhcP/Y7f5K07suQME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743097788; c=relaxed/simple;
	bh=mno6GR/OFDaBI26DURJneBtPDFYQ8Rq/Fsg/AHF51rE=;
	h=Date:To:From:Subject:Message-Id; b=Rkr1KiTvmsgnj7td/NH+Uk6JGJCYokl3AyAOWHE7lGAmrIq1ts6k13dhqgZyhDICUFaJqBScn+cllk0PMLDgjnPgxAgGVDplyaB6qoSqCQWPGMuPOb4w7tcSLs8MchFkCQsFjkWz61clOKPgyXoDAYjqsdtPUrrzRZxCu2ms4bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FV67FBnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FV67FBnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040C9C4CEDD;
	Thu, 27 Mar 2025 17:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743097788;
	bh=mno6GR/OFDaBI26DURJneBtPDFYQ8Rq/Fsg/AHF51rE=;
	h=Date:To:From:Subject:From;
	b=FV67FBnT2agaot0ngXQyuVixL2Rmt95hSdYeHbokGMT+MoYpycTHPqN1vKGIRxyTm
	 YpGCBahVkMFoQqt3ELLzR6TAB2c7bhCQOrnVIwbvMatQ03lxWNSbVvYsVEQSbLfCT+
	 3hepEj0Vpdw6HMPmY4jM7jtc0fsfDYREnkbag2Tc=
Date: Thu, 27 Mar 2025 10:49:47 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,mhocko@suse.com,dan.j.williams@intel.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mm-add-entry-for-secretmem.patch added to mm-unstable branch
Message-Id: <20250327174948.040C9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mm: add entry for secretmem
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-mm-add-entry-for-secretmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mm-add-entry-for-secretmem.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: mm: add entry for secretmem
Date: Wed, 26 Mar 2025 23:55:41 +0200

Link: https://lkml.kernel.org/r/20250326215541.1809379-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS~maintainers-mm-add-entry-for-secretmem
+++ a/MAINTAINERS
@@ -15218,6 +15218,14 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - SECRETMEM
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Mike Rapoport <rppt@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/secretmem.h
+F:	mm/secretmem.c
+
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-init-holes-in-the-end-of-the-memory-map-for-flatmem.patch
memblock-dont-release-high-memory-to-page-allocator-when-highmem-is-off.patch
maintainers-fixup-userfaultfd-entry.patch
maintainers-mm-add-entry-for-execmem.patch
maintainers-mm-add-entry-for-numa-memblocks-and-numa-emulation.patch
maintainers-mm-add-entry-for-secretmem.patch

