Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555223191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486704; cv=none; b=EM11260Dpa36V+xvBreq9EeoCSNaNI8AUXiZpA3MJyJhziLv4lTZCINtAgr/oF2pM7w7Gy6kimnXjy/+3OQnILPeM7D7kqtZXw6lcJM3E8Tx9UZfcVxq9wtCWJcb6+TXArO9PqUrxd6M8WfLTCVJNE+xAwU/byWabTySnJYXyNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486704; c=relaxed/simple;
	bh=yQ0/jQOwMXm125Gw7MAyA3c+z/0+HqXusNv6Ig1b/lM=;
	h=Date:To:From:Subject:Message-Id; b=iEjon97dyGr4k559/p4eL5TmtDj1dg3bZZpGrqrt6jf3Bs7S+KZpk16yy1zlxp5DyJRqmElSNQGTPmMSXuq8YRZ6QZT11q1iiQ/uinH4Z7A/yj1mHIPoGVoF0O/zcUDPz9Ov5GBaW41VbhVMHPPTy6Y6zWDL6cWQG2JCROJ6s2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B/CLqEGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B/CLqEGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D44EC116C6;
	Tue, 27 Jan 2026 04:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486704;
	bh=yQ0/jQOwMXm125Gw7MAyA3c+z/0+HqXusNv6Ig1b/lM=;
	h=Date:To:From:Subject:From;
	b=B/CLqEGN9bC68hHB+ypuKLu4dGU9R3dS03Q2qY8Ma5eoEuW6ewePOWk9QsvZ7xmUI
	 gNaCD+WECIuf0xJFprYWDI+KVB8wz3DKZJXviwyACEgH/tj5czdFmOZklMhmq28Qip
	 Cph5kjXjXv4OdMasD2iyO0XBNfUfcPOvFuV1xk4A=
Date: Mon, 26 Jan 2026 20:05:03 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,tmgross@umich.edu,ojeda@kernel.org,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-export-vrealloc_node_align_noprof.patch removed from -mm tree
Message-Id: <20260127040504.2D44EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: export vrealloc_node_align_noprof
has been removed from the -mm tree.  Its filename was
     vmalloc-export-vrealloc_node_align_noprof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
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
@@ -4370,6 +4370,7 @@ need_realloc:
 
 	return n;
 }
+EXPORT_SYMBOL(vrealloc_node_align_noprof);
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
 #define GFP_VMALLOC32 (GFP_DMA32 | GFP_KERNEL)
_

Patches currently in -mm which might be from aliceryhl@google.com are

maple_tree-update-mas_next-docs.patch

