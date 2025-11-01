Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3642219A8E
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 04:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761971379; cv=none; b=eCLAGH2RFAs7O1eAeu5zxOq7NDbT9gEezeKmjGCTgIJHD1VnHjZX3Y91nH2MVWYCn+i8x7wF5Oqyd2riI2ggxqs7mawkCBIU7yLqgfiAMdTcDM88bPL44Qjj0Q5ypm8PrRnkK4KJkRhSHdJd2vkFU4loB8zzYs5lLdtw+XW8v9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761971379; c=relaxed/simple;
	bh=uDdYDY/GSSYHkRgmcO9CRsFqqpDtY4KPToxBD3PgwJI=;
	h=Date:To:From:Subject:Message-Id; b=qQJT+4BF+j7ZcDNVUYgXgUBlvyQ9zL/SE3EMntLUgkKotPZ+C3lfcTmV7s5okMAX9VQXVtSQjmqyvGS0v4W39ONmozJe5nFqwfXd3S9j3igpSRjmX9A/llSEMWv90SARX3s0YbLmALcyyA6YflQA8AlUy5hIjyLj4HnlhmjSiVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iuGUM5WU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iuGUM5WU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4244EC4CEF1;
	Sat,  1 Nov 2025 04:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761971378;
	bh=uDdYDY/GSSYHkRgmcO9CRsFqqpDtY4KPToxBD3PgwJI=;
	h=Date:To:From:Subject:From;
	b=iuGUM5WUwc77USb4KGIIb5nwLRFFs9TAhqIyFhplUVjrmd2Gj3HSBVbJ/X99D6O4M
	 RWj+IWQUGrZul5p3dW2XrJGd7jv2mMjHXlU0sO/5CgCzIE/4i7ubCcbGX15H+Iuj4L
	 +PJk8AWMIWHZVmdy2wopX/FQOFjIjKT0/HWCOsKY=
Date: Fri, 31 Oct 2025 21:29:37 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,skhawaja@google.com,rdunlap@infradead.org,pratyush@kernel.org,pasha.tatashin@soleen.com,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,graf@amazon.com,dmatlack@google.com,corbet@lwn.net,brauner@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20251101042938.4244EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix.patch

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
From: Mike Rapoport <rppt@kernel.org>
Subject: liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
Date: Wed, 29 Oct 2025 10:48:11 +0200

fix KEXEC_HANDOVER_DEBUG Kconfig dependency

Link: https://lkml.kernel.org/r/aQHUyyFtiNZhx8jo@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/Kconfig.kexec~liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
+++ a/kernel/Kconfig.kexec
@@ -111,7 +111,7 @@ config KEXEC_HANDOVER
 
 config KEXEC_HANDOVER_DEBUG
 	bool "Enable Kexec Handover debug checks"
-	depends on KEXEC_HANDOVER_DEBUGFS
+	depends on KEXEC_HANDOVER
 	help
 	  This option enables extra sanity checks for the Kexec Handover
 	  subsystem. Since, KHO performance is crucial in live update
_

Patches currently in -mm which might be from rppt@kernel.org are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix.patch

