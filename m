Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA92B25FA0A
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801347; cv=none; b=vFqx+mA5Che9aBkRNkyryo0obH9tZMLD1xW2bGUFy29e6E4ihSPjVvf09XhomhPY7u1UTxNn5e3CVeM1rdhUR5BCprKM015YmiELVLU29Jg8tL8bpZlgLqDm6vt63tAlCnP/hJOXXPyBptXJEBpUaNilH1JZikNTu+Qlj7kH6KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801347; c=relaxed/simple;
	bh=iatAuDds2bsmHMB7x9P/fuJ2xpzHJB05C6qFJYWitVQ=;
	h=Date:To:From:Subject:Message-Id; b=W98ioh8gY5swTdiMDJ1bYKLPlAh9aJVxyLeMaruiRYQkh5pwcSUKjT4BORRZAsH6pJ6pBGIDmdhJJrrytFdriXRkQkFzLXYdY15uzoz19QohbRePS+jNmfLD94l2haV/hE2Fc37Lx2HmUe/kn190iu563v3O1AqEzmSJ8O3doug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kdhXJ8Gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kdhXJ8Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17D0C4CEEB;
	Sat, 13 Sep 2025 22:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801346;
	bh=iatAuDds2bsmHMB7x9P/fuJ2xpzHJB05C6qFJYWitVQ=;
	h=Date:To:From:Subject:From;
	b=kdhXJ8GdBFN+99HHk0aRIUWrV6ThQriFqsdjXYAbyMnlURvpnlAkEb+JF46eTwniY
	 J9++g0pJ9pouiE+XjmVb3eH7EyEibbm21TmOF1OpY6FgLdqpQF4AGhx6h28uzbnZmU
	 biJl16+7O16N/oXmtUc4Pn0slQixerdDHALOfkSk=
Date: Sat, 13 Sep 2025 15:09:06 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.se,vbabka@suse.cz,urezki@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kent.overstreet@linux.dev,jannh@google.com,herbert@gondor.apana.org.au,dakr@kernel.org,aliceryhl@google.com,ojeda@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] rust-add-support-for-numa-ids-in-allocations-fix.patch removed from -mm tree
Message-Id: <20250913220906.C17D0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: alloc: fix missing import needed for `rusttest`
has been removed from the -mm tree.  Its filename was
     rust-add-support-for-numa-ids-in-allocations-fix.patch

This patch was dropped because it was folded into rust-add-support-for-numa-ids-in-allocations.patch

------------------------------------------------------
From: Miguel Ojeda <ojeda@kernel.org>
Subject: rust: alloc: fix missing import needed for `rusttest`
Date: Sat, 16 Aug 2025 23:02:14 +0200

There is a missing import of `NumaNode` that is used in the `rusttest`
target:

    error[E0412]: cannot find type `NumaNode` in this scope
      --> rust/kernel/alloc/allocator_test.rs:43:15
       |
    43 |         _nid: NumaNode,
       |               ^^^^^^^^ not found in this scope
       |
    help: consider importing this struct
       |
    12 + use crate::alloc::NumaNode;
       |

Thus fix it by adding it.

Link: https://lkml.kernel.org/r/20250816210214.2729269-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jann Horn <jannh@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/alloc/allocator_test.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/alloc/allocator_test.rs~rust-add-support-for-numa-ids-in-allocations-fix
+++ a/rust/kernel/alloc/allocator_test.rs
@@ -9,7 +9,7 @@
 
 #![allow(missing_docs)]
 
-use super::{flags::*, AllocError, Allocator, Flags};
+use super::{flags::*, AllocError, Allocator, Flags, NumaNode};
 use core::alloc::Layout;
 use core::cmp;
 use core::ptr;
_

Patches currently in -mm which might be from ojeda@kernel.org are

rust-add-support-for-numa-ids-in-allocations.patch

