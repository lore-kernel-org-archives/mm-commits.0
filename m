Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF54B2D47F6
	for <mm-commits@vger.kernel.org>; Mon, 20 Oct 2025 18:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760986043; cv=none; b=DGxa15zqnAxcdNV58X+bGbXe4Xo6VkBgZ0hiLCkjKuI6E/4+bh2x0VM/27YAooexwSf4r0qEdwDsXShaq2v0YexWmapYZoLoXV9R2GnqneBjcsq27o8posmCJeA/A1N+yJMM/E6ibUvpdVpoJPJ3NfQq4aLDwtzActn8EAntqdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760986043; c=relaxed/simple;
	bh=wd2IYQ7/PXr1wmHxkjbG25QigdAdFJ0jpBXNm19wtOU=;
	h=Date:To:From:Subject:Message-Id; b=A7XRmpywa1jACIn5G8RbqUYA5U8ArlQFVOBhk7UA1d/l4lVw3VrrpBK/d7A26C9HNHmZVnbHuVPZobYS8cFgzrxI2xi107Q3tTDBqKFsA6187TOasy903PfuVp43O0DKNPCM6Cp8Em5EBXaujL534IThGcxuuxmlwEEoXBFfWu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khfP4pNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khfP4pNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECADC116B1;
	Mon, 20 Oct 2025 18:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760986042;
	bh=wd2IYQ7/PXr1wmHxkjbG25QigdAdFJ0jpBXNm19wtOU=;
	h=Date:To:From:Subject:From;
	b=khfP4pNoJjl+eUXfn6VDXsMkIIYqj1aA6ZeTq7G9EtZeP5y2lU7f407ndjLhciXai
	 W828QhERFWR5SxNDAiK8F2OFWL6nBCFmlNtTB3nXACHZCceWLR0BDdmX6zp5sfiO6s
	 J01K68gLPRgJm/2YErAbw5hV4uCG082Gw/urUEqg=
Date: Mon, 20 Oct 2025 11:47:21 -0700
To: mm-commits@vger.kernel.org,bagasdotme@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-do-not-choose-swap-device-according-to-numa-node-fix-2.patch added to mm-unstable branch
Message-Id: <20251020184722.4ECADC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc: clean up the relics of swap_numa
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-do-not-choose-swap-device-according-to-numa-node-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-do-not-choose-swap-device-according-to-numa-node-fix-2.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: doc: clean up the relics of swap_numa
Date: Mon, 20 Oct 2025 11:37:09 +0800
Content-type: text/plain

The doc swap_numa.rst has been removed in mm-new commit 9e1d0b5b7f28
("mm/swap: do not choose swap device according to numa node").  Clean up
the rest in mm/index.rst.

Link: https://lkml.kernel.org/r/aPWvfu5MQROcWKOf@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/index.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/admin-guide/mm/index.rst~mm-swap-do-not-choose-swap-device-according-to-numa-node-fix-2
+++ a/Documentation/admin-guide/mm/index.rst
@@ -39,7 +39,6 @@ the Linux memory management.
    shrinker_debugfs
    slab
    soft-dirty
-   swap_numa
    transhuge
    userfaultfd
    zswap
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap-do-not-choose-swap-device-according-to-numa-node.patch
mm-swap-do-not-choose-swap-device-according-to-numa-node-fix-2.patch
mm-swap-select-swap-device-with-default-priority-round-robin.patch

