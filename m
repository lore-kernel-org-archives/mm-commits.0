Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8619143867
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 23:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720136898; cv=none; b=eWOLKJfvRwrkKnSoujhqoSlECAKBWxnk3Evnb5zM01SD6H4l7cMUDteniAls0de7lDltwDR5cdh+SXD5soZg1ZymQIEi5pWms/F7ZHYhxETwgk/Gi0DeN7+/mOHLRGdxe3Qdd4+gHtT2t//aw/SbfZpXaxzN14tvthqa87yswKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720136898; c=relaxed/simple;
	bh=sHcd64YaZdYaaLuj219u1LOfunyMx9SYIhUOJqSzWmk=;
	h=Date:To:From:Subject:Message-Id; b=M1J8Rku6KlFsw664SMObpduB88kNGXAcRj6LSd84wtEwHCaH1dZ/R+hZM6DZ5jvi6ExXc9mh0d84kJ26CISTmp2fgkBMUnkOgR/Foisy0bA/CNGBsaGdb4df2XBsuDy4wmaDeC8FbLwOoYs6pugfLXtcOIpLoyMnb77itlm8Kts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S0ps/S5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S0ps/S5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45097C3277B;
	Thu,  4 Jul 2024 23:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720136898;
	bh=sHcd64YaZdYaaLuj219u1LOfunyMx9SYIhUOJqSzWmk=;
	h=Date:To:From:Subject:From;
	b=S0ps/S5phvayZ+F1inzp0SmPpsAaj4cfFtxbwgZc17vW3kaIWdgyqQ7Vn4HQJUVV8
	 InPnoJlIAveeJQQxjRksy+YnC+S2YiVucTpKQLS7q89eG5DSzz0S76xHIWGj2m1Pv7
	 sddF/fB4UNkpurHfHKXEZTK95pHf8kBjWFtBy7x4=
Date: Thu, 04 Jul 2024 16:48:17 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch removed from -mm tree
Message-Id: <20240704234818.45097C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

This patch was dropped because it was folded into mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
Date: Thu Jun 27 04:39:10 PM PDT 2024

apply fixups per "mm: gup: do not call try_grab_folio() in slow path".

Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
+++ a/mm/gup.c
@@ -3859,14 +3859,15 @@ long memfd_pin_folios(struct file *memfd
 				    next_idx != folio_index(fbatch.folios[i]))
 					continue;
 
-				folio = try_grab_folio(&fbatch.folios[i]->page,
-						       1, FOLL_PIN);
-				if (!folio) {
+				if (try_grab_folio(fbatch.folios[i],
+						       1, FOLL_PIN)) {
 					folio_batch_release(&fbatch);
 					ret = -EINVAL;
 					goto err;
 				}
 
+				folio = fbatch.folios[i];
+
 				if (nr_folios == 0)
 					*offset = offset_in_folio(folio, start);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch

