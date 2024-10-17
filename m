Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB561D79B6
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 21:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729199721; cv=none; b=IQDbDrKzRQWmEdI6j3SOLkeLSc+gK4QcRFPLOYih91VomaRIKOXA9+o+QhQTDsFs47SST4UdI3xl04I6RaDWxy+Oh65dLzS/UmxdBAQET50rLZZoSVMaegKmx+XHKVcvnMzxZMEU4sfzAY2vAGVSWDM3cpJ7ogEtJaffXTgKUJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729199721; c=relaxed/simple;
	bh=QkZ6Co7nfMWTKfUKJc/AgxObf1GaVSZ6kQz1PHWlSt8=;
	h=Date:To:From:Subject:Message-Id; b=QSYGiv+wPslzydKTTIHPzurc09Wq0vCxH/xlTICKi1TzJGnJf89nYg1y95BLZUdhRcAvq99RhegFKh/pfUT4QxDnwWhkwxM04LHbll4oauoWXbaI042Y/hFnvzE65VxIhNsm2+G73BZNKeTbJdw5+DaN3BXPLxGIWBC1eU539Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQ1dQNA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQ1dQNA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F947C4CECE;
	Thu, 17 Oct 2024 21:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729199720;
	bh=QkZ6Co7nfMWTKfUKJc/AgxObf1GaVSZ6kQz1PHWlSt8=;
	h=Date:To:From:Subject:From;
	b=qQ1dQNA0UgqdaQ1Y2iM74/eOEbU3s5V4pNaUML1kUrkRAHjxoVQPYSS3hJE/JWCmN
	 Kt/+khNeSYf2T/i8DuzTcGT4m0zEx+LdgyjXFZ6Zo6Xk4MHmZa+DompwLohDUIbkj6
	 p6BmKqAAvizQLqYGUgqCWLrE7FokjBnkWWmVTIo0=
Date: Thu, 17 Oct 2024 14:15:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch added to mm-unstable branch
Message-Id: <20241017211520.0F947C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: fix phys_addr_t size on 64-bit systems
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools: testing: fix phys_addr_t size on 64-bit systems
Date: Thu, 17 Oct 2024 17:56:38 +0100

The phys_addr_t size is predicated on whether CONFIG_PHYS_ADDR_T_64BIT is
set or not.

In the VMA tests, virt_to_phys() from tools/include/linux casts a volatile
void * pointer to phys_addr_t, if CONFIG_PHYS_ADDR_T_64BIT is not set,
this will be 32-bit and trigger a warning.

Obviously this might also lead to truncation, which we would rather avoid.

Fix this by adjusting the generation of generated/bit-length.h to generate
a CONFIG_PHYS_ADDR_T{bits}BIT define.

This does result in the generation of the useless CONFIG_PHYS_ADDR_T_32BIT
define for 32-bit systems, but this should have no effect, and makes
implementation of this easier.

This resolves the issue and the warning.

Link: https://lkml.kernel.org/r/20241017165638.95602-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/shared.mk |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/shared/shared.mk~tools-testing-fix-phys_addr_t-size-on-64-bit-systems
+++ a/tools/testing/shared/shared.mk
@@ -69,6 +69,7 @@ generated/bit-length.h: FORCE
 	@if ! grep -qws CONFIG_$(LONG_BIT)BIT generated/bit-length.h; then   \
 		echo "Generating $@";                                        \
 		echo "#define CONFIG_$(LONG_BIT)BIT 1" > $@;                 \
+		echo "#define CONFIG_PHYS_ADDR_T_$(LONG_BIT)BIT 1" > $@;     \
 	fi
 
 FORCE: ;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

