Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A42405E5;
	Sat,  9 Aug 2025 00:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754700097; cv=none; b=YeTnNihlL7mGOUYxpjdvESK0obwUdg1YjzG5ogdIDem3HqH9Q/tiMipSaj9He9DY5NFICWCCEKtly3jMwH8Fax/xHtCTZMtt4zWqbeQjQbZSoBtfsTyHTXVgzxK1PdOEbGiFbcuRLxYkk/7GBZw8ri5uNPnDZsaJt471Bf0M+yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754700097; c=relaxed/simple;
	bh=M+P/bVO3okiIMlGCLuo756jEAZQN0ezu4duPwESeLuk=;
	h=Date:To:From:Subject:Message-Id; b=ErXa5+qKkI8TEe3899Jec4eek7RzkpdQ4Eu5EpIFZbSfidm0TJ/RBRe9+tjQ0RJOpNyF4QNY4AC8bSeL+Dlcl0otaIGMO8+aRPe8t6gTGTpi12m83lSejbbALQzMA9R5kBpOOjzFtoaAGLjPy640fGxxWaKqX27oReAteMtubwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qegoOqUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qegoOqUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D224FC4CEED;
	Sat,  9 Aug 2025 00:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754700096;
	bh=M+P/bVO3okiIMlGCLuo756jEAZQN0ezu4duPwESeLuk=;
	h=Date:To:From:Subject:From;
	b=qegoOqUpX/Q5ub0Alcm/7sykj6k0T4z34vd6bjLxK479kctx/VLq3PO6frT74sFhC
	 IMLEsf6Frmef5XrxtKyRoShJi/khajLcvYYnM1g7fpgSqQ6MmKJoRUKH19dlOn7C+z
	 xhsKxPmyYQ/7B8PJtzdf9wPSeFbflwimW8KcYslQ=
Date: Fri, 08 Aug 2025 17:41:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,changyuanl@google.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-mm-dont-allow-deferred-struct-page-with-kho.patch added to mm-hotfixes-unstable branch
Message-Id: <20250809004136.D224FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: mm: don't allow deferred struct page with KHO
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-mm-dont-allow-deferred-struct-page-with-kho.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-mm-dont-allow-deferred-struct-page-with-kho.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: mm: don't allow deferred struct page with KHO
Date: Fri, 8 Aug 2025 20:18:03 +0000

KHO uses struct pages for the preserved memory early in boot, however,
with deferred struct page initialization, only a small portion of memory
has properly initialized struct pages.

This problem was detected where vmemmap is poisoned, and illegal flag
combinations are detected.

Don't allow them to be enabled together, and later we will have to teach
KHO to work properly with deferred struct page init kernel feature.

Link: https://lkml.kernel.org/r/20250808201804.772010-3-pasha.tatashin@soleen.com
Fixes: 990a950fe8fd ("kexec: add config option for KHO")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/Kconfig.kexec~kho-mm-dont-allow-deferred-struct-page-with-kho
+++ a/kernel/Kconfig.kexec
@@ -97,6 +97,7 @@ config KEXEC_JUMP
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select DEBUG_FS
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-init-new_physxa-phys_bits-to-fix-lockdep.patch
kho-mm-dont-allow-deferred-struct-page-with-kho.patch
kho-warn-if-kho-is-disabled-due-to-an-error.patch

