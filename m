Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D41217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188493; cv=none; b=rZ0qtDhGgBDsuvJipCc/llK/fmdEI9S7EsqIo1FUR14yJUMWa7V9aD6Sp7dooTLjQxI2ihy/L6n7Q6tACbuFQ+f7G7E/HgHcasbdsJ/boSZt7r000nxmJvO7CcRbHCqiNxeOjOUpXd5iB4221HHd6pKJ6uUG1HsXkFphAbTIR9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188493; c=relaxed/simple;
	bh=W/CVh3k2H9Z+Bp6uHmp8d1L7wwu0jrEwX/8kvbmS2/8=;
	h=Date:To:From:Subject:Message-Id; b=YWQoMiLbqyj+KxNUpDtSKH0ULE2eMdslEV+lAfL7lodBvmcQM7o/JMwkUf0SAbT1/Rhvo6reXi3TKYH0X12Ys7e47dVoS9xuWINbVc8vKDGf+yI533s1KH6Dh/vINuEUa68/YW3x+q4APorUgvxpYOogEqCfQ8NuqnbkGbwAavI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aJba7EB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aJba7EB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D18C4CEEC;
	Mon, 17 Mar 2025 05:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188493;
	bh=W/CVh3k2H9Z+Bp6uHmp8d1L7wwu0jrEwX/8kvbmS2/8=;
	h=Date:To:From:Subject:From;
	b=aJba7EB3fpT//4w9h0Fnfa0rsVdsm79J/YoNtvL/DzT9TtYB2KYciZnNHiwxv8Vds
	 h1h9IKs2ceYvwKc6kMyG2DTBjybJzNt6zTd7qj6zxfXAVevwluMqrxDviHababI7Wc
	 qT1DSygD8MaytCfKSniB2+UqeCZQoqezEqbBm1mQ=
Date: Sun, 16 Mar 2025 22:14:52 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch removed from -mm tree
Message-Id: <20250317051453.39D18C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: arm64: drop PTDUMP config options from ptdump.rst
has been removed from the -mm tree.  Its filename was
     docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


