Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E8F13C9DE
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713994280; cv=none; b=laCuhXGyWD29seCKV6G6Z5MycOj6oW1RuN9BVlmZAI1IwlmssR6WD8Wml3L0krCXKIOJet+G/omRzPf+Og50AjzUOZVFFHXTtNfOTONtp9R7dq4y5H18Wpe7QAJvDcR96Mjbt9fwIxQ1f8RGDUlp7tHF8Mfz1hgz8c2Iy4+FY4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713994280; c=relaxed/simple;
	bh=GSEXcO1jZjA7mGuBh+4QfpG2QqoKW4Cgwldmuhsam1k=;
	h=Date:To:From:Subject:Message-Id; b=eg8Ds0DzEb5mpSOsqxffJgj5mro8N9zKF5qMcI0A2O+SsbCpyxxIrDoJY1oWYE0uliRvrU9NdBlaJ5ZYpBWfPwsM3DIJ16LStlZCsLY6M0oEWMCj2Xr+18aGC2G2D2LXEeGIpVXy1S2wfuwVTME1OlBzQ0or8aIMgn2QTm+qIvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ou16m4gS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ou16m4gS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB5BC2BD10;
	Wed, 24 Apr 2024 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713994280;
	bh=GSEXcO1jZjA7mGuBh+4QfpG2QqoKW4Cgwldmuhsam1k=;
	h=Date:To:From:Subject:From;
	b=Ou16m4gSSEqzf4buIFCw/rUVzQ5CZ4ALQCndNUV9Cvwtgvz4VJTGCreBT05bJ9+EC
	 koX0lOyt7cS5v1bvO4wo07RJaTSwemzZ4vHsPz2ST9YrVZbkarXnJ/mB3+QcW4eLaR
	 e3JOMP5ehlgTonfExDCGXKa0H0kMZdlrhaeaCPy8=
Date: Wed, 24 Apr 2024 14:31:19 -0700
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,pmenzel@molgen.mpg.de,peterhuewe@gmx.de,jgg@ziepe.ca,James.Bottomley@HansenPartnership.com,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-urls-for-keys-keyrings_integrity-and-tpm-device-driver.patch added to mm-hotfixes-unstable branch
Message-Id: <20240424213120.1CB5BC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update URL's for KEYS/KEYRINGS_INTEGRITY and TPM DEVICE DRIVER
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-urls-for-keys-keyrings_integrity-and-tpm-device-driver.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-urls-for-keys-keyrings_integrity-and-tpm-device-driver.patch

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
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: MAINTAINERS: update URL's for KEYS/KEYRINGS_INTEGRITY and TPM DEVICE DRIVER
Date: Wed, 24 Apr 2024 00:45:49 +0300

Add TPM driver test suite URL to the MAINTAINERS files and move the wiki
URL to more appropriate location.

Link: https://gitlab.com/jarkkojs/linux-tpmdd-test
Link: https://kernsec.org/wiki/index.php/Linux_Kernel_Integrity
Link: https://lkml.kernel.org/r/20240423214549.8242-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-urls-for-keys-keyrings_integrity-and-tpm-device-driver
+++ a/MAINTAINERS
@@ -12042,6 +12042,7 @@ M:	Mimi Zohar <zohar@linux.ibm.com>
 L:	linux-integrity@vger.kernel.org
 L:	keyrings@vger.kernel.org
 S:	Supported
+W:	https://kernsec.org/wiki/index.php/Linux_Kernel_Integrity
 F:	security/integrity/platform_certs
 
 KFENCE
@@ -22420,7 +22421,7 @@ M:	Jarkko Sakkinen <jarkko@kernel.org>
 R:	Jason Gunthorpe <jgg@ziepe.ca>
 L:	linux-integrity@vger.kernel.org
 S:	Maintained
-W:	https://kernsec.org/wiki/index.php/Linux_Kernel_Integrity
+W:	https://gitlab.com/jarkkojs/linux-tpmdd-test
 Q:	https://patchwork.kernel.org/project/linux-integrity/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git
 F:	Documentation/devicetree/bindings/tpm/
_

Patches currently in -mm which might be from jarkko@kernel.org are

maintainers-update-urls-for-keys-keyrings_integrity-and-tpm-device-driver.patch

