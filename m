Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52335C148
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 02:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718160222; cv=none; b=tS/s9RaJbBo2dx4ERiz4NmotQUi4oCNo0RjRZdOrWNNnp5nAqXEjpDLanRC9UFZjiBGGWXNiPdOGYmryBUVDbNQdcU6LBadopiXphOavrxsSz423w/NRGaQ3jfm7zz1wFTf0rA29Az2dUVzQImg7ajhP574iu1J1/WMOOhEJSHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718160222; c=relaxed/simple;
	bh=5SZ8+ALeUB9+DRxId4Yrn67Iq6uSBUVV+ebBFQRvf0E=;
	h=Date:To:From:Subject:Message-Id; b=bZZumUELRY2CZbP/RzN4P8yNoYWkzMALMi/kpQeq9Jf0WHhihDanETki8R6ELRzFZlWjrVMEYfbRnPqUoqa0nwpMO/x/7rR7VEVpExfDOXwxZJ34b3I+sa8SIkwKay9NhvWMwX/vMGNBAG33HL3ipIBePU5zCoh+CEwQZwpNXvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HyRQ4+XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HyRQ4+XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADB4C2BD10;
	Wed, 12 Jun 2024 02:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718160221;
	bh=5SZ8+ALeUB9+DRxId4Yrn67Iq6uSBUVV+ebBFQRvf0E=;
	h=Date:To:From:Subject:From;
	b=HyRQ4+XI7Xsik+huj/cchOwX81vHWm8u7ti0chNoiZHXQ73Pie6yekfqEJcP3Abn7
	 qNRno5zda6cmX7Z3TnZt8qqbyXyahoBs/OrknPyC9NBDkj1OlizQK59AGYP/9DZhcc
	 5KDwQMPrEROjo96ZwxT6YHvabjMJieyApXUoBvcs=
Date: Tue, 11 Jun 2024 19:43:41 -0700
To: mm-commits@vger.kernel.org,samuel.holland@sifive.com,rppt@kernel.org,pmladek@suse.com,paulmck@kernel.org,hca@linux.ibm.com,arnd@arndb.de,aquini@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240612024341.BADB4C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix
Date: Tue Jun 11 07:39:46 PM PDT 2024

default to `y' if 32-bit, per Rafael

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/Kconfig~mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix
+++ a/arch/Kconfig
@@ -1048,7 +1048,7 @@ config ARCH_MMAP_RND_BITS_DEFAULT
 
 config FORCE_MAX_MMAP_RND_BITS
 	bool "Force maximum number of bits to use for ASLR of mmap base address"
-	default n
+	default y if !64BIT
 	help
 	  ARCH_MMAP_RND_BITS and ARCH_MMAP_RND_COMPAT_BITS represent the number
 	  of bits to use for ASLR and if no custom value is assigned (EXPERT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix.patch
writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch

