Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651E125CC7D
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740608746; cv=none; b=HZ6h46gkLxiFlXCgjdnOU2j5KRTZ1ZHC8rHZ4i7l4VuAWO5W8NJJNz2XT1uRkMEVthRBs+0B9gKqeQiK8sDqU1RM1ubIEaOdvv/uAnucSaudrbGDtmab5waJhVANS4hgi5ilGp5d/9S0lPaoozDtPZXgRLAA5Fl6FKcvyXjgitc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740608746; c=relaxed/simple;
	bh=by7Ja8st0HSF2BZWFILUS2gor8nygEWtBGSVqL6dGIw=;
	h=Date:To:From:Subject:Message-Id; b=ZGFmbu6PQUriO1PRbgHesIRPhzoRciz/hZgNQTE2EjCakrM9z/b2cVk29zIJLdrDZ6nkaYJsW8HaK6UUMkgJ5jCXiQKvbEdb+7NZCsIiw3/iKdTVd0AZbsgm70jXtImX8+Zmo+VYrWOOdEwbE5UspQSuZxE0As7bmffKVYIr/xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=roPAKkcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="roPAKkcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E22C4CED6;
	Wed, 26 Feb 2025 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740608745;
	bh=by7Ja8st0HSF2BZWFILUS2gor8nygEWtBGSVqL6dGIw=;
	h=Date:To:From:Subject:From;
	b=roPAKkcrOdjeu79nXELxSzjV24tPyw8vpBgZrpCKO7guM7vGu9eSrWnZabJGIPvyh
	 jzTKsdh5wNw7t/Sd9GqAwfcPOmRgnOT0CPnYs89aJvtvk4FN6YtXfQZNd1bqhxAdz0
	 jc6XcJ+ppgmnl+JYBOypL+3HQExip3r6zBHjW7sk=
Date: Wed, 26 Feb 2025 14:25:45 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch added to mm-unstable branch
Message-Id: <20250226222545.C5E22C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: arm64: drop PTDUMP config options from ptdump.rst
has been added to the -mm mm-unstable branch.  Its filename is
     docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: docs: arm64: drop PTDUMP config options from ptdump.rst
Date: Wed, 26 Feb 2025 17:54:02 +0530

Both GENERIC_PTDUMP and PTDUMP_CORE are not user selectable config
options.  Just drop these from documentation.

Link: https://lkml.kernel.org/r/20250226122404.1927473-4-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Steven Price <steven.price@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/arch/arm64/ptdump.rst |    2 --
 1 file changed, 2 deletions(-)

--- a/Documentation/arch/arm64/ptdump.rst~docs-arm64-drop-ptdump-config-options-from-ptdumprst
+++ a/Documentation/arch/arm64/ptdump.rst
@@ -22,8 +22,6 @@ offlining of memory being accessed by th
 In order to dump the kernel page tables, enable the following
 configurations and mount debugfs::
 
- CONFIG_GENERIC_PTDUMP=y
- CONFIG_PTDUMP_CORE=y
  CONFIG_PTDUMP_DEBUGFS=y
 
  mount -t debugfs nodev /sys/kernel/debug
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

configs-drop-generic_ptdump-from-debugconfig.patch
arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch
docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch
mm-make-debug_wx-depdendent-on-generic_ptdump.patch
mm-rename-generic_ptdump-and-ptdump_core.patch

