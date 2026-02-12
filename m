Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323471D5147;
	Thu, 12 Feb 2026 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770914563; cv=none; b=lwUzatE2XkuccFpxMMKPrh2lZx2OrbJJG6jfhHdiDzLEkXdkwgb69D+lFy7OKrbobcdkFILKnHyvepLPmma0uiR75tW49RtXwzwXRT+/uEki7nLtwXuQXKwFTP8Efk9rkcjItq9t0wjSgpDZ3la1Dy7Nsli1yEP224y/OqIon48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770914563; c=relaxed/simple;
	bh=WhZpuSHX1sSbe0t81qtmtbXIroXon1S0Cvw8CYIh/UM=;
	h=Date:To:From:Subject:Message-Id; b=nuSeHSxfdW1GzZOpDZjvexjYqUuMuZPdqfTdHkY81RW5JNoT9XdtROHMCQTuFsqRa77hcY1ARtn9t5fq7ADuKgSZCrcDqrNHDacQq4Lt3ZaG32HDfPRkh5RA0wtbP60v74rt6qWAGUZPwHWJvsP3C5l6sxAm0OfUetGMXWDYCv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DejPidrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DejPidrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AA1C4CEF7;
	Thu, 12 Feb 2026 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770914562;
	bh=WhZpuSHX1sSbe0t81qtmtbXIroXon1S0Cvw8CYIh/UM=;
	h=Date:To:From:Subject:From;
	b=DejPidrfVKJjrEnhoTuzb69pD2rX7OAilex+r7dKxIlnfY3qh5TTUIZnJfMeD0+OW
	 DAPCoVU9g5XpxcarygHi+sIONbnsvMwUAjsTg/ycB+nSOTbDDiUb3aD+KisoOrMY0y
	 r5jyZGbXeRBjt63GlVd/G0fzuwUAntI9zxaOdNgA=
Date: Thu, 12 Feb 2026 08:42:42 -0800
To: mm-commits@vger.kernel.org,zkabelac@redhat.com,urezki@gmail.com,stable@vger.kernel.org,sj@kernel.org,hch@lst.de,hch@infradead.org,mpatocka@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-__gfp_retry_mayfail-in-vmalloc.patch added to mm-hotfixes-unstable branch
Message-Id: <20260212164242.B6AA1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow __GFP_RETRY_MAYFAIL in vmalloc
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-allow-__gfp_retry_mayfail-in-vmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-__gfp_retry_mayfail-in-vmalloc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Date: Thu, 12 Feb 2026 17:33:30 +0100 (CET)

The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
breaks the device mapper VDO target.  The VDO target calls vmalloc with
__GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed flags.

There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so
let's add this flag to GFP_VMALLOC_SUPPORTED.

Link: https://lkml.kernel.org/r/ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com
Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.19]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-allow-__gfp_retry_mayfail-in-vmalloc
+++ a/mm/vmalloc.c
@@ -3928,6 +3928,7 @@ fail:
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
 				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 
_

Patches currently in -mm which might be from mpatocka@redhat.com are

mm-allow-__gfp_retry_mayfail-in-vmalloc.patch

