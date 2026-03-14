Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BA03793CA
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 23:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773530468; cv=none; b=g0Y5eb1dfhwWEjtYU4A/e1z2wQTkehOQHbwgOG+EXD5WWlsOYdqIg5jwwrs0qXFUeyI6p1X3wnC10DxngDHUXlNngl2QPo8P2lXEO0WsO4U7y7Ao8jidU+WG7mUDthcziYKZoD785HOQ50ACWuo45NattrT7seRdozZaJnO1RlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773530468; c=relaxed/simple;
	bh=N9l9co0YhDjBgdoCM7CTnagCi4+FZe/6tORLg4jMems=;
	h=Date:To:From:Subject:Message-Id; b=QlP3N7BgYcgrdTkn6bdmpZYE+TLdc2rh+eNmuRJPXJrm69wLz+vxAzxt6myUJLITcA34HWeiBP63YDgWj2oYmxyufcriYIYA4h1RTM2pZnCGoVBE8IB2P3UF9hJKfUusuGFTZJ2DajSFhyGOnU4SA15uioHuRltyS/idriej0cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jdKa+vHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jdKa+vHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C989EC116C6;
	Sat, 14 Mar 2026 23:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773530467;
	bh=N9l9co0YhDjBgdoCM7CTnagCi4+FZe/6tORLg4jMems=;
	h=Date:To:From:Subject:From;
	b=jdKa+vHGMs6bJRvzIImSa8wCua3Srp14j2hbnlZar/ssiVZBBGirbzbdBRnOVXX/Q
	 gdqlf0B9zgSiS56qgbmiJyOcVVR6oHGMPueyLT9hOMEnGjQ8h0eZJhwKj2yud3iBZV
	 KixU2pQUtV/QklVnbYFcHtaM0WeMpCO3qxBm8ki4=
Date: Sat, 14 Mar 2026 16:21:07 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mmap_action_simple_ioremap-fix.patch added to mm-new branch
Message-Id: <20260314232107.C989EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-mmap_action_simple_ioremap-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-mmap_action_simple_ioremap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_action_simple_ioremap-fix.patch

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
Subject: mm-add-mmap_action_simple_ioremap-fix
Date: Sat Mar 14 04:19:36 PM PDT 2026

randyfy mmap_prepare.rst

Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/mmap_prepare.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/filesystems/mmap_prepare.rst~mm-add-mmap_action_simple_ioremap-fix
+++ a/Documentation/filesystems/mmap_prepare.rst
@@ -127,7 +127,7 @@ pointer. These are:
 * mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remaps
   the entire mapping from ``start_pfn`` onward.
 
-* `mmap_action_simple_ioremap()` - Sets up an I/O remap from a specified
+* mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
   physical address and over a specified length.
 
 **NOTE:** The ``action`` field should never normally be manipulated directly,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-various-small-mmap_prepare-cleanups-fix.patch
mm-add-mmap_action_simple_ioremap-fix.patch
mm-add-mmap_action_map_kernel_pages-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

