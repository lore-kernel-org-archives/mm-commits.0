Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA30155A46
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 22:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712181873; cv=none; b=MX4nOFZBXP6N9Xg+nWBGzUYWaF7yzISvJzIyVrb1tKwom1OPANcRmyKUJb8p8a4aZ8kB2kTJNgFgOvTS9pdk0MaRGoKk96pBk8sV8kTRvekW/WxvMPnq+UQwoRkAfyuqqnlGQevLamfL9XMGY+Sitn1qn+0oVjOvTfIgZIzHlqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712181873; c=relaxed/simple;
	bh=70yo3YNIOlxV6B88LZSxrBdVWN5BPH1QwuVLp30G7/8=;
	h=Date:To:From:Subject:Message-Id; b=CRa05rLTI5fZ/BQXC5YdTxLydeXCzMj1wjZGFVC3WnzuH3H4wWgsHpXBeWxk7BeirWUwx/OEHrkeGNM4vwiilktsAWAbWY6fgs6HQDXpAJ9YbMIRsDnGWuBkgQLmlMcPjnnk3HUmZnO2wMIeOfCU5RfJdDWanSBSdPewPY02o7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MwPrDAlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MwPrDAlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D26FC433F1;
	Wed,  3 Apr 2024 22:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712181873;
	bh=70yo3YNIOlxV6B88LZSxrBdVWN5BPH1QwuVLp30G7/8=;
	h=Date:To:From:Subject:From;
	b=MwPrDAlfz/Y/icfODcUp95ETaNXCL2goBfQU5OVft2LeW9efI8OJHNL0PgnVqqqOs
	 D9T1JGCWPHtGBAxjLCsMQLRKSNiEr1NcMI7+IzeuVAyGzHkiab2Sis5kNXuwOcjhge
	 fSZygTdco7YLhNFQFv8UqIxwsZv1GjGhs4Rw6cyE=
Date: Wed, 03 Apr 2024 15:04:32 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-missing-vmalloch-includes-fix-3.patch added to mm-unstable branch
Message-Id: <20240403220433.0D26FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix-missing-vmalloch-includes-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     fix-missing-vmalloch-includes-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-missing-vmalloch-includes-fix-3.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: fix-missing-vmalloch-includes-fix-3
Date: Wed, 3 Apr 2024 14:12:40 -0700

fix loongarch build

Link: https://lkml.kernel.org/r/20240403211240.GA307137@dev-arch.thelio-3990X
Signed-off-by: Nathan Chancellor <nathan@kernel.org> 
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/addrspace.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/include/asm/addrspace.h~fix-missing-vmalloch-includes-fix-3
+++ a/arch/loongarch/include/asm/addrspace.h
@@ -11,6 +11,7 @@
 #define _ASM_ADDRSPACE_H
 
 #include <linux/const.h>
+#include <linux/sizes.h>
 
 #include <asm/loongarch.h>
 
_

Patches currently in -mm which might be from nathan@kernel.org are

fix-missing-vmalloch-includes-fix-3.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix-2.patch

