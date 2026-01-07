Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B9334C988
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802365; cv=none; b=NEKL+XeVGEHFzSDijXOvltykbpi1nn29IeVrOTH2Rz6Jo33x4MhHr6gJOtTZll3GprLDSXvVhYPgNQDvq8nxzhAnwK5JzBI+XrZqXGN/RxxMfbxcdBC17lsLVtwYGOGXuNcBUlfDT0X3dozImn2xuiwjaxhVUd72cH779eNdPcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802365; c=relaxed/simple;
	bh=GIr1v7b2oPGLAGtWW52SlxsYqTw9sUiuOo5A5yUBiJc=;
	h=Date:To:From:Subject:Message-Id; b=aCQCRNYGgzZHwPn/0mNPjaatstsYNXSFLpbN14RuoiPmgCVNWofNng3c401YNSRWwlwZXCw/+NOILpnIrAtAQANZjL5Sj9JwE1Wh+XvYqmkFH/HoIr/KVDtmaAzRyr5PZedNJsfiGK6XWiv42WWvYkZaB2ly/W+AMb1I31DuO3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QFQVZwee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QFQVZwee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE299C4CEF1;
	Wed,  7 Jan 2026 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767802364;
	bh=GIr1v7b2oPGLAGtWW52SlxsYqTw9sUiuOo5A5yUBiJc=;
	h=Date:To:From:Subject:From;
	b=QFQVZweefyjwY4Tg5sc3uQJxjNZok0912sjd4iC0J+b8Bet3a0D27xgU+idanALlq
	 6gMafmu3sBAryrU5d+HDOZbI9EwUVUjxe9yfEGz9lD9U3Jk4FPVw39Y8wR6hKY+0Io
	 +VMSNAVa2pcyMpd/YOa0X9iHJnLkO17bCaxTroRU=
Date: Wed, 07 Jan 2026 08:12:43 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,tmgross@umich.edu,ojeda@kernel.org,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-export-vrealloc_node_align_noprof.patch added to mm-new branch
Message-Id: <20260107161243.DE299C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: export vrealloc_node_align_noprof
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-export-vrealloc_node_align_noprof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-export-vrealloc_node_align_noprof.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Alice Ryhl <aliceryhl@google.com>
Subject: vmalloc: export vrealloc_node_align_noprof
Date: Wed, 07 Jan 2026 15:16:42 +0000

This symbol is used from the Nova driver, so it needs to be exported to
avoid a build failure when building Nova as a module.

ERROR: modpost: "vrealloc_node_align_noprof" [drivers/gpu/nova-core/nova_core.ko] undefined!
ERROR: modpost: "vrealloc_node_align_noprof" [samples/rust/rust_dma.ko] undefined!

This error is only triggered if helpers are inlined into Rust.  Otherwise,
Nova will call the exported symbol

	rust_helper_vrealloc_node_align()

instead. There is no Fixes: tag as that feature is still WIP.

I used non-GPL EXPORT_SYMBOL to match the rest of the file, but let me
know if I should use EXPORT_SYMBOL_GPL.

Link: https://lkml.kernel.org/r/20260107-export-vrealloc_node_align_noprof-v1-1-a581bec13054@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~vmalloc-export-vrealloc_node_align_noprof
+++ a/mm/vmalloc.c
@@ -4362,6 +4362,7 @@ need_realloc:
 
 	return n;
 }
+EXPORT_SYMBOL(vrealloc_node_align_noprof);
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
 #define GFP_VMALLOC32 (GFP_DMA32 | GFP_KERNEL)
_

Patches currently in -mm which might be from aliceryhl@google.com are

vmalloc-export-vrealloc_node_align_noprof.patch

