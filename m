Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5E01DA316
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720035272; cv=none; b=NpeogKBlKzHqUSZk5Ptlou3jKtGxemFFM10ai5ZrGt9u0Un7quFrQW7b+pbqHkcs9wM4cI/gxJ5aDw5l1oBBe8/Ra4p4YNGs0CSTKGJQdB0HTzpFcD/2iSfxH8nj7PCjRYAB3yhQzFMFuH1CiXRlsm32y3ejuzdO+IEhb3W7QjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720035272; c=relaxed/simple;
	bh=WC7uaOeUO2aCPuWvGriUKrxYsFePOa7W3OTWcKqNbGw=;
	h=Date:To:From:Subject:Message-Id; b=jxE/MUBMpPBpN/AtJrQ9OAl4ICsZ1Qg7gn8v246v/QM+dmouahNmktLqR0dq3SZNC14BpjmTtxoKvVM82sHqkreC3Z1AW5A8CNj7rutiyXkiZLR0I4CIEgcKDDomp0eSEzSk/BWVmsaoWxrppyiydDQWo36+0wUD5LvnwzjyN1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jneW5SU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jneW5SU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DAAC2BD10;
	Wed,  3 Jul 2024 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720035272;
	bh=WC7uaOeUO2aCPuWvGriUKrxYsFePOa7W3OTWcKqNbGw=;
	h=Date:To:From:Subject:From;
	b=jneW5SU283ZPcF0Xl6ZLX5nESF9DA8AMismap+loy8U1tkUXACIsgz45KRTnBWarB
	 HCovxDaaEvIf8UPtuNt8PFlk89ZBY3oflfCVOhcVN7X0B899A4fx9k4Do8N9cAvg1X
	 bPzIYxCD8WZEHomIdoIm3jjDPcHJdAQFI+gfKBh4=
Date: Wed, 03 Jul 2024 12:34:32 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-unexport-vmf_insert_mixed_mkwrite.patch added to mm-unstable branch
Message-Id: <20240703193432.84DAAC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: unexport vmf_insert_mixed_mkwrite
has been added to the -mm mm-unstable branch.  Its filename is
     mm-unexport-vmf_insert_mixed_mkwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-unexport-vmf_insert_mixed_mkwrite.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport vmf_insert_mixed_mkwrite
Date: Tue, 2 Jul 2024 09:23:27 +0200

vmf_insert_mixed_mkwrite is only used by the built-in DAX code.

Link: https://lkml.kernel.org/r/20240702072327.1640911-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-unexport-vmf_insert_mixed_mkwrite
+++ a/mm/memory.c
@@ -2533,7 +2533,6 @@ vm_fault_t vmf_insert_mixed_mkwrite(stru
 {
 	return __vm_insert_mixed(vma, addr, pfn, true);
 }
-EXPORT_SYMBOL(vmf_insert_mixed_mkwrite);
 
 /*
  * maps a range of physical memory into the requested pages. the old
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-vmf_insert_mixed_mkwrite.patch

