Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D365D1714C6
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739852917; cv=none; b=gxMP+EPbz4rBUJ2a3hY1g/OXKXD48t9cHQ/aW089Ic2A7ejtpaLHXc35bj0CdQ/sx/OjCxtNuyiqTK6rdM7KKq2nyqExi2TFXo/KzidNboJ5Mbem+904VsNfxRn9cCd+WgpABNOAqPT8oMIzLLU3jSKmvlfAghqcg3/SGWBXINo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739852917; c=relaxed/simple;
	bh=RDjRElPz0BV7qL3RrW/fCS5MMZkm4q3ZWTBkhQyJ7Js=;
	h=Date:To:From:Subject:Message-Id; b=lYfhDX1HBr0Lzdb72ahDgbgloh8hABf1QjQOuDrtG1AHN7kpaWc7/PBduLpzHy6XOuUu5eLgHjppvcD9rlWZ1QEntF/w8493fXGKFUKkc9kP0tkk8KMQqIEzlWLhi3Tdo0MLvEmaIe+Apbc0a3AWYTF6bCUn7+bLPMrb0l6KJH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gs9O7hRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gs9O7hRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CB0C4CEE2;
	Tue, 18 Feb 2025 04:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739852917;
	bh=RDjRElPz0BV7qL3RrW/fCS5MMZkm4q3ZWTBkhQyJ7Js=;
	h=Date:To:From:Subject:From;
	b=Gs9O7hRrpTk+gnpxLnb0Rl8+K0SmJRiPY5PGLN6bYtwL0iJralHY04DFrWLX4UTmN
	 wboHdoOK/xhBbHIsdEss65phxOPwNVlV0RR493/go5ruk151QXQKLPAnhZs3u11B9V
	 hJi/5LfGZQnotGJDn24Nz5IbCI5YmQQ7fxHQ63Us=
Date: Mon, 17 Feb 2025 20:28:36 -0800
To: mm-commits@vger.kernel.org,ujwal.kundur@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-fix-doc-link-to-fault-injectionrst.patch added to mm-hotfixes-unstable branch
Message-Id: <20250218042837.36CB0C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: fix doc link to fault-injection.rst
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     documentation-fix-doc-link-to-fault-injectionrst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-fix-doc-link-to-fault-injectionrst.patch

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
From: Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Documentation: fix doc link to fault-injection.rst
Date: Sat, 15 Feb 2025 16:21:07 +0530

Fix incorrect reference to fault-injection docs

Link: https://lkml.kernel.org/r/20250215105106.734-1-ujwal.kundur@gmail.com
Signed-off-by: Ujwal Kundur <ujwal.kundur@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~documentation-fix-doc-link-to-fault-injectionrst
+++ a/lib/Kconfig.debug
@@ -2103,7 +2103,7 @@ config FAIL_SKB_REALLOC
 	  reallocated, catching possible invalid pointers to the skb.
 
 	  For more information, check
-	  Documentation/dev-tools/fault-injection/fault-injection.rst
+	  Documentation/fault-injection/fault-injection.rst
 
 config FAULT_INJECTION_CONFIGFS
 	bool "Configfs interface for fault-injection capabilities"
_

Patches currently in -mm which might be from ujwal.kundur@gmail.com are

documentation-fix-doc-link-to-fault-injectionrst.patch

