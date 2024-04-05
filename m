Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE49D172BAC
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712341105; cv=none; b=Ww2PpT6z+2oXE0wchbyziAm2eLAwDT9ZfFA2DDClxFvwNCsubjpVbpvsstDn2leehL/Gt4wQKrcXyNfDan2Fn/V1ezW/yTESFVWOeYciip7o7itRxEy7kqgJ8IGaUOw/isSrzHApm+Mai3FcbzjmMut3B+wMYsn9J6i87kcb+9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712341105; c=relaxed/simple;
	bh=iGb8d6WPUnfjm6a11waJbNUslZ8BxhZaQGypLLtpPps=;
	h=Date:To:From:Subject:Message-Id; b=m5Ya2Kak9Kmnk35bUL/UiXKxCs1sYRKyWYEk92Y2O3O5lG7F9d3liOAvvJyVYEGLG8vNMAwGUtWuNjbpb58gFkPRK/T9Ip/cUgEs0s3E6LVHJv0u7iMa+Za8c24OEXtxpvTpsx0yFC5WQOtQcz3TRJP1Plx5/bNdXJzl9csoQhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k9nXUgX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k9nXUgX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBE2C433F1;
	Fri,  5 Apr 2024 18:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712341104;
	bh=iGb8d6WPUnfjm6a11waJbNUslZ8BxhZaQGypLLtpPps=;
	h=Date:To:From:Subject:From;
	b=k9nXUgX+VqsVZaTSrsceQWCBBl0ebcO3WLCbttTPWQRsoVl1yuFX+YMU41KfdNC5Z
	 PZPlAzAGbaYV7ay8Cw6bMvCHgOQPJqpmBSQaB6fe0m3l5/EzvPczUYqtQMG/iXjnF1
	 k+piFzVf639tnbXDXtRctkhThWjSzBhYJtCnFbqU=
Date: Fri, 05 Apr 2024 11:18:23 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-lockdep-warning-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240405181824.3CBE2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmalloc-fix-lockdep-warning-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-fix-lockdep-warning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-lockdep-warning-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-fix-lockdep-warning-fix
Date: Fri Apr  5 11:16:02 AM PDT 2024

fix comment typos, per Baoquan

Cc: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-lockdep-warning-fix
+++ a/mm/vmalloc.c
@@ -1064,10 +1064,9 @@ repeat:
 	}
 
 	/*
-	 * Check if found VA exists, it might it is gone away.
-	 * In this case we repeat the search because a VA has
-	 * been removed concurrently thus we need to proceed
-	 * with next one what is a rare case.
+	 * Check if found VA exists, it might have gone away.  In this case we
+	 * repeat the search because a VA has been removed concurrently and we
+	 * need to proceed to the next one, which is a rare case.
 	 */
 	if (va_start_lowest) {
 		vn = addr_to_node(va_start_lowest);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-fix-lockdep-warning-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

