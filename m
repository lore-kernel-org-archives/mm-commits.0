Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68B355F36
	for <mm-commits@vger.kernel.org>; Sun, 26 Apr 2026 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777201775; cv=none; b=FWmLkU9Z1lJvf/BmMDsM6FwHbfePf1wlcOViqXym03Bfyl1EwWbfrR1rOl80l0VAaYReHiH+urv8SYOf13RQrghxio1gVO73nR5fvoxLQXm9lOBeLqr/FJkgZzg150NlUgAieKqd8ryVpWA39zxUjZlcBe8mtN5/GT22bjPNiYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777201775; c=relaxed/simple;
	bh=YgfXa9z7N44537WR+lnP3SeRcTl5t6LlI2VTd5t4wu8=;
	h=Date:To:From:Subject:Message-Id; b=UbK5JpCiYS7O+wbubiZMzveyr/9hL56hkCTDSb1BTRGREwcdjAUaocRDpkGXSjwr57UyKpJ4TnrCa+UyNwlnQKa09ly8bmJXUEM48uUdUedcbrlY5YMlInsyb+y6x/95c9oSTv1+ukRoHXuLtabuGhFLoU9/IK+rh5nSigb/1dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uKM8U0Cm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uKM8U0Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7BCC2BCAF;
	Sun, 26 Apr 2026 11:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777201775;
	bh=YgfXa9z7N44537WR+lnP3SeRcTl5t6LlI2VTd5t4wu8=;
	h=Date:To:From:Subject:From;
	b=uKM8U0Cm0gIYefi+De9+odQPSmG/+q/GkbSRN8WMsxc98zrawK1LSG9LcnkArPkAs
	 L2tI3g6l32S2yVkCkz6SsUB/gHmCdR78UCC87ZquOc2xUafwO223q/Pcx1D1SJO8Ji
	 nkSa9EHK8RJT5SH0o34ZVQrxivRsd+es/xB6BO60=
Date: Sun, 26 Apr 2026 04:09:34 -0700
To: mm-commits@vger.kernel.org,msalter@redhat.com,david.laight.linux@gmail.com,chmh0624@gmail.com,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch added to mm-new branch
Message-Id: <20260426110935.6B7BCC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix
has been added to the -mm mm-new branch.  Its filename is
     include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix
Date: Sun Apr 26 04:00:43 AM PDT 2026

convert set_fixmap_io() also

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Min-Hsun Chang <chmh0624@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fixmap.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/asm-generic/fixmap.h~include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix
+++ a/include/asm-generic/fixmap.h
@@ -102,8 +102,10 @@ set_fixmap_offset_nocache(enum fixed_add
 /*
  * Some fixmaps are for IO
  */
-#define set_fixmap_io(idx, phys) \
-	__set_fixmap(idx, phys, FIXMAP_PAGE_IO)
+static inline void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
+{
+	__set_fixmap(idx, phys, FIXMAP_PAGE_IO);
+}
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_GENERIC_FIXMAP_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch
proc-rewrite-next_tgid-fix.patch

