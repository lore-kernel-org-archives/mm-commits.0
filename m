Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF5B13F42A
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 21:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720214687; cv=none; b=kAvTIQZrXlYMTQrKl5Bx4Ck4nCy2/2SM7mNTEMHYvNIN53QulKmnCUnzenC+cpHthc1+6sUf6hOLhyrxQiNh9ZNwPkSrJEBU2lt3KMm82J4naVDgyJTvcz3mMyZgg4BYOuFheFb8BV2zTmqvzQgUg27/Y5UQcmhH4+o4HDb1kNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720214687; c=relaxed/simple;
	bh=lKokglWlunWWNhqV+ZuwvDrx9z/xbVxh95AhT44Fdos=;
	h=Date:To:From:Subject:Message-Id; b=e/NC6wjxsv6CZDlTdyP2opIWMqeV57eMUIiGfofptpM8SDd5TsUs4Zd2lAHYgaEs0Bt9DBq5gW7xSmokNIDSC4oXhzIsL3O3Kjr3ERmqF4XNQvRDH8vy3xCB1hCEi2bQh7wC8kdOTO3UxhR7y6S7EP7vbyiVn7ef5V+WN+03LQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pHBsTX87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pHBsTX87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DDBC116B1;
	Fri,  5 Jul 2024 21:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720214687;
	bh=lKokglWlunWWNhqV+ZuwvDrx9z/xbVxh95AhT44Fdos=;
	h=Date:To:From:Subject:From;
	b=pHBsTX874iq2mpUsp/SyC50SeL3VtRRqoxZhXM+HejIeCzUUaS4UG4IFVdgO/a8MU
	 S/SUgJ7MOJakJhwIVqXW5x17gLri4Ucj++s09LppW/kmm8lPOw/+n9v61+kraoiUp5
	 zDn8EEqvEtsOjpZVnlmQVYqCeBIoep91C4zwPM30=
Date: Fri, 05 Jul 2024 14:24:46 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,sj@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch added to mm-unstable branch
Message-Id: <20240705212447.53DDBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
Date: Fri Jul  5 02:15:29 PM PDT 2024

improve the CONFIG_MMU=n situation, per SeongJae

Cc: SeongJae Park <sj@kernel.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
+++ a/mm/gup.c
@@ -3859,9 +3859,9 @@ long memfd_pin_folios(struct file *memfd
 				    next_idx != folio_index(fbatch.folios[i]))
 					continue;
 
-				folio = try_grab_folio_fast(&fbatch.folios[i]->page,
-						       1, FOLL_PIN);
-				if (!folio) {
+				folio = page_folio(&fbatch.folios[i]->page);
+
+				if (try_grab_folio(folio, 1, FOLL_PIN)) {
 					folio_batch_release(&fbatch);
 					ret = -EINVAL;
 					goto err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch

