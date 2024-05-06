Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057CD2913
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955325; cv=none; b=IDsEb0RFZkoJgG1glCQ2CnWejIAR8OYa1gXQOzygDaTO0jFjhYTFfqsUAF6F/MxptUFDPFXKalpVA8FdCEr8r/HwIS9BgIGr5E1Y19qVE76dp0xHah3LWlYKNdufxavXZRiMks/WWHv9xbPdjnU9bcgz5MG3pmKhXQtyW7sfFnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955325; c=relaxed/simple;
	bh=4Xo9PIH9B0JjD8Vg87c/zQNIsDh0lzLrUIxt7vFX/m8=;
	h=Date:To:From:Subject:Message-Id; b=R0BEUasK6sZKsqkL9NLlBeb55pXkxGfzFAGfYGdFoqM/unBl4Iuf1qFVFce2rZvA+0B3sWn6I0j6m6KVoIMM9oJM1nveCu7GhOCgOLTnRwpvRKCtmctfW0XnVoTpgctlXVA1OzGYz+8Sr83abMoq2/UVP5PJH77fx2E1ncmjNME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KGjbb/vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KGjbb/vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B3BC113CC;
	Mon,  6 May 2024 00:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955324;
	bh=4Xo9PIH9B0JjD8Vg87c/zQNIsDh0lzLrUIxt7vFX/m8=;
	h=Date:To:From:Subject:From;
	b=KGjbb/vldZ2+13JIPOiuZm22hTm8jM8dUz1gSTK2I2WVoFSpBOp4H4C8cEEyEtGAM
	 pBYDIhu6J7HKICEnGre4P16wndttiqSNGUZ/ZSYcXkryMTsYizCQ5DGDSeML+VB+ba
	 GOjfEeHGI4nUtZHtE33x9U2RmZK4Ejvr6SSMdnVA=
Date: Sun, 05 May 2024 17:28:43 -0700
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,pmenzel@molgen.mpg.de,peterhuewe@gmx.de,jgg@ziepe.ca,James.Bottomley@HansenPartnership.com,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-urls-for-keys-keyrings_integrity-and-tpm-device-driver.patch removed from -mm tree
Message-Id: <20240506002844.69B3BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update URL's for KEYS/KEYRINGS_INTEGRITY and TPM DEVICE DRIVER
has been removed from the -mm tree.  Its filename was
     maintainers-update-urls-for-keys-keyrings_integrity-and-tpm-device-driver.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


