Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48253A55
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 01:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757122499; cv=none; b=Tgr+ntNFS9NMaS9DoRq3uaEcxzqA7LF043bOWY6NPK18GwK7r2oUaUzfPvuAn5Q8e14tJP7JY5I9y/ULIPEPuTuZtOYaIxkMiJ1qvy3PgFupU00FqQi3Ry8a3cZ4lkDXidzygDyadJ9iFFeHIQS5EdrLZ0VHIP/dARtFmyfPaSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757122499; c=relaxed/simple;
	bh=QyeNqFb5MgAB61t9n0RgGIaAWzAbfVVGAuSsD19hrt8=;
	h=Date:To:From:Subject:Message-Id; b=ZcYxOR5Sy5fdiYtXGKCe14nBS7o9bkiMDKnQkg52Xt40xOBLFY/8jcmkDQfmGDzTWulwCjVU5nLRNiYW49R+QUOlF1quoDYOS0IEfaLWliPa3grQVWQWaIyDIh0QS7ya+AaJmdm86iteC+I5m3kZzsHxa1CpjXLJQ/qtffcSl/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Toz4ZOJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Toz4ZOJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C73C4CEF1;
	Sat,  6 Sep 2025 01:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757122498;
	bh=QyeNqFb5MgAB61t9n0RgGIaAWzAbfVVGAuSsD19hrt8=;
	h=Date:To:From:Subject:From;
	b=Toz4ZOJ8VgI4K47Xr6zFkBud85uxIn4YnDcUaSxQwExQgSqhH6anWFj2FSfqR6rwV
	 OQJ+e8SiIuR42p9uBqfCpPxcJZd/rYlpQkGmjeZJ1WIoi8fXz293LYxR2Ju62gRbxN
	 I4rdS9lO1w3cycbEvyKWX1Tu74ClDgCK7MPZTM1g=
Date: Fri, 05 Sep 2025 18:34:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-tree-entry-to-numa-memblocks-and-emulation-block.patch added to mm-hotfixes-unstable branch
Message-Id: <20250906013458.C1C73C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add tree entry to numa memblocks and emulation block
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-tree-entry-to-numa-memblocks-and-emulation-block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-tree-entry-to-numa-memblocks-and-emulation-block.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add tree entry to numa memblocks and emulation block
Date: Fri, 5 Sep 2025 12:15:57 +0300

Link: https://lkml.kernel.org/r/20250905091557.3529937-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-tree-entry-to-numa-memblocks-and-emulation-block
+++ a/MAINTAINERS
@@ -16127,6 +16127,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
 F:	include/linux/numa_memblks.h
 F:	mm/numa.c
 F:	mm/numa_emulation.c
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-entry-to-numa-memblocks-and-emulation-block.patch
kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch

