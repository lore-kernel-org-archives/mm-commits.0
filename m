Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E782F3E
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 21:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749331454; cv=none; b=Z/yjtCYpC41nUQzF3qc+Wk1hb/ZcSrZbDFe5QO5mxnz7sqMgiPZvtEgObK4i3/zyPwkJjHGaEDa+NuuhsGrdIDsQsf55PUDiT/GX/sR5AaRG8f+S9XrL7SvPHxCtU7whIjVHF5VCIqbTz0Bou/B8WiI0CFwgRKgt8bc9oE4n7DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749331454; c=relaxed/simple;
	bh=UIqbq7bYlnwDe/fbt37q2JMCcejCDjdEEwmW4s33LFs=;
	h=Date:To:From:Subject:Message-Id; b=UpsNo9vORMJXA9UukFSmZuyOIHxoj+gHbfJIO+9QzOwJicqefLXTxZubX2hkLCvGjSE8rGIt3z0dGpKoABsp8+kikqQ+fpxrk3Jo6iLDjie+okU7WJypC7hdMSSgvux7fXWW5h3X46vXAFxgbSYvB2rUQ3JXKiLzJ2mmTHLQ148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H3e10aEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H3e10aEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13874C4CEE4;
	Sat,  7 Jun 2025 21:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749331454;
	bh=UIqbq7bYlnwDe/fbt37q2JMCcejCDjdEEwmW4s33LFs=;
	h=Date:To:From:Subject:From;
	b=H3e10aExx5wm0LBYNsnwaSUNUAXJYZk/rKx8AXWg+KS1EM/sSPqCs408Ywhd6Sm2l
	 AnO9SAkXoHayUgoCxEinCb9bicaG7ha9YYUdL4tyyk49Ypqf2sPL79y/zPDr4nJfQg
	 T0gbNnGO71x8rmJgiFtTviJ6jusr99OYwm10anFE=
Date: Sat, 07 Jun 2025 14:24:13 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,wangfushuai@baidu.com,tz2294@columbia.edu,npache@redhat.com,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,andrii@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-proc-update-vmflags-documentation-in-smaps-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250607212414.13874C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-proc-update-vmflags-documentation-in-smaps-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-proc-update-vmflags-documentation-in-smaps-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-proc-update-vmflags-documentation-in-smaps-fix.patch

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
Subject: docs-proc-update-vmflags-documentation-in-smaps-fix
Date: Sat Jun  7 02:20:52 PM PDT 2025

add "dp" (VM_DROPPABLE), per Tal

Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mariano Pache <npache@redhat.com>
Cc: wangfushuai <wangfushuai@baidu.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/filesystems/proc.rst~docs-proc-update-vmflags-documentation-in-smaps-fix
+++ a/Documentation/filesystems/proc.rst
@@ -610,6 +610,7 @@ encoded manner. The codes are the follow
     ss    shadow/guarded control stack page
     sl    sealed
     lf    lock on fault pages
+    dp    always lazily freeable mapping
     ==    =======================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

