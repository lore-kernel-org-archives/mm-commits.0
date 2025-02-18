Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BEE1D63E8
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739920479; cv=none; b=qkLXuTtyDO0an/9gA/qhlOv2h+/0OtPaEwdhTxTGFPJmRE99zjWxKmjW+sqqDBkfoY+ekx14uFJX1ctQcW1osETLF5He2iJsjnu6M6SOYi5ak6UzO3xNmu0ZLEhrjVytcYeqo4RkKBFRkSCuFhtSOEo/F24ikWRPyIIg9JpaYzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739920479; c=relaxed/simple;
	bh=3GRcB0qVtBsYrwo4fnGaBkShkr915wndde7DKbkEzTU=;
	h=Date:To:From:Subject:Message-Id; b=j7rkaEcH27dQUAaoZMP0hGyR14M8mzIvwK3RRP9QKjkPb42a0qG+DH9AtEuK8acDHqbPBV1fDB8aldaXwHcSjyoek4soyMvtDopsQehPEo20piWGjfjas3vda1pWGfWimdNLyieVCar802ILRCe10Cmp6zkZ6fcVnvNskQP1OSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XYGdNwmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XYGdNwmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88A5C4CEE2;
	Tue, 18 Feb 2025 23:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739920478;
	bh=3GRcB0qVtBsYrwo4fnGaBkShkr915wndde7DKbkEzTU=;
	h=Date:To:From:Subject:From;
	b=XYGdNwmvLlG+yItxzwMNJVJsXyZmagm8cUgF8LfOp18YQJFVfEMkEqN/Bm1ieuP2I
	 Qbz6ddK6aLlb50U4KXxXY1CGpNMv2ssBomKumnGFRA0sSXcB/A/Bz8eU5fGynHif05
	 xYroIVNkzWvXdms/Wfeu9w/YV7jSzPMYAEMtcdB8=
Date: Tue, 18 Feb 2025 15:14:38 -0800
To: mm-commits@vger.kernel.org,sw@simonwunderlich.de,quic_skakitap@quicinc.com,qmo@kernel.org,othacehe@gnu.org,nao.horiguchi@gmail.com,kees@kernel.org,gregkh@linuxfoundation.org,eugen.hristev@linaro.org,elder@kernel.org,antonio@mandelbit.com,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-remove-never-used-parityio-email.patch added to mm-nonmm-unstable branch
Message-Id: <20250218231438.A88A5C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: remove never used @parity.io email
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-remove-never-used-parityio-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-remove-never-used-parityio-email.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mailmap: remove never used @parity.io email
Date: Tue, 18 Feb 2025 19:05:55 +0200

As this employment lasted only four months and was never used over here,
let's just rip it off for good.

Link: https://lkml.kernel.org/r/20250218170557.68371-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Eugen Hristev <eugen.hristev@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mathieu Othacehe <othacehe@gnu.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 -
 1 file changed, 1 deletion(-)

--- a/.mailmap~mailmap-remove-never-used-parityio-email
+++ a/.mailmap
@@ -303,7 +303,6 @@ Jan Glauber <jan.glauber@gmail.com> <jgl
 Jan Kuliga <jtkuliga.kdev@gmail.com> <jankul@alatek.krakow.pl>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
-Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@parity.io>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are

mailmap-remove-never-used-parityio-email.patch

