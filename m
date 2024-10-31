Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60F441760
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 01:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730338316; cv=none; b=Q0N1Ir9H9LdIUVopJ7UvI1rAkCQeVIhmAO4ZavlrZ1TymrxcoMSle3sUa/wSeyP0Q7qsUOfmukvmfM3r8afSoZxx2ZCdpRFDI5WkTJmLSexlJmMee9YjktrKyRKygCwr3UGVjvZmufuGOPN1yqhNGZKjQx5+9PeWdRjvw/QoCn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730338316; c=relaxed/simple;
	bh=wK/x3QPlTS0Ki/mQauCSnGwWPeugb8MR+Ug74ReaGeQ=;
	h=Date:To:From:Subject:Message-Id; b=IY47zylf5pygk4+tleSSIqA4yYsM+cFKl2oMhnJYBZNxYURdHFzK+Qyfp7C/RMkx8+7Z5W/LKhtUYdUx7HIjtL4IJqcOhhT6irHs1rF5V1bMX6O9O0At63UJ2a0Fm2xIPqCX0KWaQfOY9QiGGxTAmFc8X41lfXwoXMMwzyouUVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hlJfTh85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hlJfTh85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548FDC4CECE;
	Thu, 31 Oct 2024 01:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730338315;
	bh=wK/x3QPlTS0Ki/mQauCSnGwWPeugb8MR+Ug74ReaGeQ=;
	h=Date:To:From:Subject:From;
	b=hlJfTh85y/8GoLYqljFOu9Ds8371wdPoO5QWrW0cBqV88PDH1Z3uVJ8Qe31Jb/Mas
	 Jf2/5TcmXo2kFYMevHa3FxATHXYj18zkZExD4o2SeMNVFFxOehrhMjjSZIyT9FAioC
	 wKBLXNTmmu+7IDTqb39zhpSfog4JaGJyj7W3nynA=
Date: Wed, 30 Oct 2024 18:31:54 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-swpin-counters-v2.patch added to mm-unstable branch
Message-Id: <20241031013155.548FDC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-per-order-mthp-swpin-counters-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-swpin-counters-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-swpin-counters-v2.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm-add-per-order-mthp-swpin-counters-v2
Date: Thu, 31 Oct 2024 12:34:23 +1300

add a blank line in doc

Link: https://lkml.kernel.org/r/20241030233423.80759-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-per-order-mthp-swpin-counters-v2
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -533,6 +533,7 @@ anon_fault_fallback_charge
 zswpout
 	is incremented every time a huge page is swapped out to zswap in one
 	piece without splitting.
+
 swpin
 	is incremented every time a huge page is swapped in from a non-zswap
 	swap device in one piece.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-fix-pswpin-counter-for-large-folios-swap-in.patch
mm-add-per-order-mthp-swpin-counters.patch
mm-add-per-order-mthp-swpin-counters-v2.patch

