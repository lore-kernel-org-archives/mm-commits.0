Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BB141C89
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 18:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718736297; cv=none; b=Zdj6AObuhddI2ZJfMztqmEg2Qj2Ejn42pOFVireJcs7e+6RS1YQmzjJyc3ZFJxRyj5Bky49SZ31ZNhLuVB3wj/qIQEyYyDVlFEUHZkzS38H0QxbhKPKMjR8+9KxE6p4vslF52fXQyUWRBUJmYIfLl0u8Nozenng3tLRN1dh17qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718736297; c=relaxed/simple;
	bh=k09IT1IIqjO9OkEKJ70tO10O/taBpsx8xxaF8HtXD80=;
	h=Date:To:From:Subject:Message-Id; b=DjrcCVpDdeoAcFfLlVTD6OzdfOi6sxPmRJuwC34ih1UDJToWXI2v64TyLtXxtgfPMJC9e/lilV6EaOf8PWbAdbvmHhhlTovJPTP0xlaNuYpWRQItvvaq5B2+SUdeZLm6s85psIJKyFK+RkujUWv06GQTPttlyzuRlLoiScyIVmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n3X7lXIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n3X7lXIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CC2C3277B;
	Tue, 18 Jun 2024 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718736297;
	bh=k09IT1IIqjO9OkEKJ70tO10O/taBpsx8xxaF8HtXD80=;
	h=Date:To:From:Subject:From;
	b=n3X7lXIx0pGv/CgwQiy6HYY5afl/Okz7FtVhcmA3v8GS0mWBiFpzC9kADDB6znB3s
	 VSSDZbLFujFvoxzEZrt2NotawEG6EfqJcVgwjji2Vun0tJfkK7cgddmrKcN22Oqp2d
	 Xxye6sabPVJiqTAtkEwOEwYFZ2Sh5uW9aVYu+XEQ=
Date: Tue, 18 Jun 2024 11:44:56 -0700
To: mm-commits@vger.kernel.org,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-tpm-device-driver-update-the-w-tag.patch added to mm-hotfixes-unstable branch
Message-Id: <20240618184457.24CC2C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: TPM DEVICE DRIVER: update the W-tag
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-tpm-device-driver-update-the-w-tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-tpm-device-driver-update-the-w-tag.patch

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
Subject: MAINTAINERS: TPM DEVICE DRIVER: update the W-tag
Date: Tue, 18 Jun 2024 16:35:56 +0300

Git hosting for the test suite has been migrated from Gitlab to Codeberg,
given the "less hostile environment".

Link: https://lkml.kernel.org/r/20240618133556.105604-1-jarkko@kernel.org
Link: https://codeberg.org/jarkko/linux-tpmdd-test
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-tpm-device-driver-update-the-w-tag
+++ a/MAINTAINERS
@@ -22746,7 +22746,7 @@ M:	Jarkko Sakkinen <jarkko@kernel.org>
 R:	Jason Gunthorpe <jgg@ziepe.ca>
 L:	linux-integrity@vger.kernel.org
 S:	Maintained
-W:	https://gitlab.com/jarkkojs/linux-tpmdd-test
+W:	https://codeberg.org/jarkko/linux-tpmdd-test
 Q:	https://patchwork.kernel.org/project/linux-integrity/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git
 F:	Documentation/devicetree/bindings/tpm/
_

Patches currently in -mm which might be from jarkko@kernel.org are

maintainers-tpm-device-driver-update-the-w-tag.patch

