Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87E923ABA7
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 01:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776217320; cv=none; b=bXEw6AK4VsciYHY9R/sUYgnZXWGwGah1UC9uL0JfUrtb7u9sTrk8ZNNaWAUF6baflHV1k33v8P6GHxQU4J7b5XiuTIbChGZfmdDROiJu0GzBqVe5g7Z9hGHi8utx1q0KH3O03K6Hwd5CBwvW6NEKarTpR4ISG3fPO3LP3zpxsG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776217320; c=relaxed/simple;
	bh=Sg9evujlkjsHpsbkqbvetDQhInWQeXg0kn6qhmLjNGI=;
	h=Date:To:From:Subject:Message-Id; b=I2PnUROoxRFG068PX1HGEtYNAqxY13dj9NYUsPnlS2yggQl27J2vV0R5LCUpYL989Iaqu6xFizKDdyjsq6uUMmC3tNOR7fPjXmDhMx5xo+ZtbZ/zzEg+a37pnltCpCV+/570tFp3zJidsjwWrydvsRn1K4uiyodjHTF2jQUAmbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nZKBa0YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nZKBa0YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE743C19425;
	Wed, 15 Apr 2026 01:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776217319;
	bh=Sg9evujlkjsHpsbkqbvetDQhInWQeXg0kn6qhmLjNGI=;
	h=Date:To:From:Subject:From;
	b=nZKBa0YOPcgXgPXYN8VJANulVaiK3V3UHPX4wZHHWvWsagbA03qx4L0bGkFTHCMo9
	 ITAn5Xx/Fp01u63Rkz6R1PEj+i4jLeMv8nKcbIccJAR2lLfqZgdMvml94cEZjInD9z
	 HGhK9NuDLYRhpvkKsmPGYe6tsqEE65KCroLx/w94=
Date: Tue, 14 Apr 2026 18:41:55 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,david@kernel.org,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-drop-include-linux-liveupdate-from-live-update.patch added to mm-unstable branch
Message-Id: <20260415014158.CE743C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-drop-include-linux-liveupdate-from-live-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-drop-include-linux-liveupdate-from-live-update.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE
Date: Tue, 14 Apr 2026 12:17:20 +0000

The directory does not exist any more.

Link: https://lkml.kernel.org/r/20260414121752.1912847-4-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-drop-include-linux-liveupdate-from-live-update
+++ a/MAINTAINERS
@@ -14816,7 +14816,6 @@ F:	Documentation/mm/memfd_preservation.r
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/kho/abi/
 F:	include/linux/liveupdate.h
-F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
 F:	lib/tests/liveupdate.c
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-update-kho-and-live-update-maintainers.patch
maintainers-drop-include-linux-kho-abi-from-kho.patch
maintainers-drop-include-linux-liveupdate-from-live-update.patch

