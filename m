Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548871EC013
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 21:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725399323; cv=none; b=YWClQ8PwPk2LPhNKj1j7nXpuqXm1mUFtRIKbClbgAhX5m+Anw3dc/XA+N/mmz6UmkhaqS/ss3A8ocy5GiwzgMaiA19PWXYnUP+m7V5KHdEQdSR+DsLf8+VJGnaf+RfNcb54PnZZjz9cSFXjvKXwbuBE5WsSaZT62XXVNIytC9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725399323; c=relaxed/simple;
	bh=yEYjcYtaimQ+gzVAVSQfUSbu4ud9vOzwiNR464/6OF4=;
	h=Date:To:From:Subject:Message-Id; b=MjCsA/Q5aOulQ/gPph9jZBwjBrn6z0uf2yJSRyzEY+FVj8Xo+qTa4z8lgsXeSvRnwhLikQf7FTlzsXKDyMN3rjblTPgYhpeiwmY34CSotS8QhuBAO2yLWJBVSvXqSqvgG/AcBF2fa6IDxdHv24UrppJxdUZZTRfpnOdYUcT3gBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ghDPc7Kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ghDPc7Kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4A8C4CEC4;
	Tue,  3 Sep 2024 21:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725399322;
	bh=yEYjcYtaimQ+gzVAVSQfUSbu4ud9vOzwiNR464/6OF4=;
	h=Date:To:From:Subject:From;
	b=ghDPc7KtotyPHrNTibyGTFS+yo97JTYEUMS+K2E1KPGkeJuvnTPG9bOVRFalmO0h7
	 Qh7KTTX6LEdjT76SaRDfEmE1cvYQnmkDFO6CJW7vPYRpYBa2D44I9Zv5WdLyJl21Rs
	 OIdBCjqMql456qrDKov9DFu2zKzNhA+R7IvLw/14=
Date: Tue, 03 Sep 2024 14:35:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch added to mm-hotfixes-unstable branch
Message-Id: <20240903213522.AE4A8C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix memfd_pin_folios alloc race panic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch

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
From: Steve Sistare <steven.sistare@oracle.com>
Subject: mm/gup: fix memfd_pin_folios alloc race panic
Date: Tue, 3 Sep 2024 07:25:21 -0700

If memfd_pin_folios tries to create a hugetlb page, but someone else
already did, then folio gets the value -EEXIST here:

        folio = memfd_alloc_folio(memfd, start_idx);
        if (IS_ERR(folio)) {
                ret = PTR_ERR(folio);
                if (ret != -EEXIST)
                        goto err;

then on the next trip through the "while start_idx" loop we panic here:

        if (folio) {
                folio_put(folio);

To fix, set the folio to NULL on error.

Link: https://lkml.kernel.org/r/1725373521-451395-6-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/gup.c~mm-gup-fix-memfd_pin_folios-alloc-race-panic
+++ a/mm/gup.c
@@ -3705,6 +3705,7 @@ long memfd_pin_folios(struct file *memfd
 					ret = PTR_ERR(folio);
 					if (ret != -EEXIST)
 						goto err;
+					folio = NULL;
 				}
 			}
 		}
_

Patches currently in -mm which might be from steven.sistare@oracle.com are

mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch
mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch
mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch
mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch
mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch

