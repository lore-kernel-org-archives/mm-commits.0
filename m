Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C698029BD88;
	Thu,  9 Apr 2026 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748704; cv=none; b=RMyrSAA+yjQrCTCLPZZk08a/KhmkuAr3ifyGWaviJ95VldKXpg9IIEE/BHyhbImHh9FpExCwM9TANg/sWtvluZJdgvT+oLyDuDeQfbHvvmRjcJ7Ca9irKAdDWYJP7pSorz3J1rj6aHmPHnRbS9+lsmRvr0xScmQEAAOrw5u0yLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748704; c=relaxed/simple;
	bh=GXb38/8kmmIkGibUBkdCq0JFtA/Ytsfe7Gls0P00Heg=;
	h=Date:To:From:Subject:Message-Id; b=KRrtv3fwEOhcwca0p7A/ybB2nI+KbwTUnGWQh40/BZjBQqcU8FDcQgCkvuk5cQcMwofgr0nvnb8KYygl2F00M6wTyK9pNZVdic/JxMUmZmYPZudqX3Qz1bc3Pp50suWNmIIKDFYtBpDKk9IXLqspLgLkCv54xSmmZNiHwImPz9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c6gj7kPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c6gj7kPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE91C4CEF7;
	Thu,  9 Apr 2026 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775748704;
	bh=GXb38/8kmmIkGibUBkdCq0JFtA/Ytsfe7Gls0P00Heg=;
	h=Date:To:From:Subject:From;
	b=c6gj7kPLYolTNkMG4JqfS3cfUniQRVHou3ROU7dk5iUplUkjsOlnzfrohfseQOFaq
	 irxi1P1cMfJ742Es+aZPO6j37IPTOlkYcKS5U2Hx1rOoEhWED7WJIDDV0pU2hzDkM0
	 4Oy5qFlRGUAHV/2uz9zSXtAUS/UtMX9JgMcmUGLQ=
Date: Thu, 09 Apr 2026 08:31:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,fvdl@google.com,david@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-early-boot-crash-on-parameters-without-=-separator.patch added to mm-unstable branch
Message-Id: <20260409153144.6AE91C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix early boot crash on parameters without '=' separator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-early-boot-crash-on-parameters-without-=-separator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-early-boot-crash-on-parameters-without-=-separator.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/hugetlb: fix early boot crash on parameters without '=' separator
Date: Thu, 9 Apr 2026 12:54:40 +0200

If hugepages, hugepagesz, or default_hugepagesz are specified on the
kernel command line without the '=' separator, early parameter parsing
passes NULL to hugetlb_add_param(), which dereferences it in strlen() and
can crash the system during early boot.

Reject NULL values in hugetlb_add_param() and return -EINVAL instead.

Link: https://lkml.kernel.org/r/20260409105437.108686-4-thorsten.blum@linux.dev
Fixes: 5b47c02967ab ("mm/hugetlb: convert cmdline parameters from setup to early")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-early-boot-crash-on-parameters-without-=-separator
+++ a/mm/hugetlb.c
@@ -4226,6 +4226,9 @@ static __init int hugetlb_add_param(char
 	size_t len;
 	char *p;
 
+	if (!s)
+		return -EINVAL;
+
 	if (hugetlb_param_index >= HUGE_MAX_CMDLINE_ARGS)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-hugetlb-fix-early-boot-crash-on-parameters-without-=-separator.patch

