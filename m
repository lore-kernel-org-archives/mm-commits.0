Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E5C1F37D3
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 22:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755382895; cv=none; b=W5iRK5mj6DnPjWo8Vb+UQlppndIpqWuIjzZVmbdtOv3hw6w2wtCNT1vnVp5EKA0EsS9KzwvWailRMgTdvgzzNFbCvneYncMZVgAUDj+nDaIdzyT6V5ihcxngtqU3xQG4BVMR9f94uVmdAo4vuxptDkAWyocEWZeR/Y5Mt+3LiDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755382895; c=relaxed/simple;
	bh=Pjz9EaUEv34N/y24qDfRmXftaawzMpdO4gwMWwsam8M=;
	h=Date:To:From:Subject:Message-Id; b=SF6mlgQDGmXzvGAveFzWk+UjA2wRM99ICrtRAUnXzx2SMcOzQOoNqMD2Bc2N2FD8kjDDuPl6edCyo8UTpyAfp6WoLLjFwgZWNT2CILWkzTft/F4WfWcBuzBfpsONxjGLO249cREJgjNid24dNci059ecTYo3047QQXWwXdvSnsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tueO7H4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tueO7H4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBE9C4CEEF;
	Sat, 16 Aug 2025 22:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755382894;
	bh=Pjz9EaUEv34N/y24qDfRmXftaawzMpdO4gwMWwsam8M=;
	h=Date:To:From:Subject:From;
	b=tueO7H4vbNuRkIg7BN0e93cY/EIfRSH/nEQWCpC4Y5WKg4d6c6Aeg30aGeR70b88r
	 6nLTHDHXgdYw7ecbcYSHbawKbfGuP/wH22bKOr1rmYH7L6d/9Ce4pLKolWakctRav2
	 5AviI2gGnDk4eP1EOog5XM7z0/kIteaJ9tBBAxvQ=
Date: Sat, 16 Aug 2025 15:21:34 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.se,vbabka@suse.cz,urezki@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kent.overstreet@linux.dev,jannh@google.com,herbert@gondor.apana.org.au,dakr@kernel.org,aliceryhl@google.com,ojeda@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-add-support-for-numa-ids-in-allocations-fix.patch added to mm-unstable branch
Message-Id: <20250816222134.AEBE9C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: alloc: fix missing import needed for `rusttest`
has been added to the -mm mm-unstable branch.  Its filename is
     rust-add-support-for-numa-ids-in-allocations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-add-support-for-numa-ids-in-allocations-fix.patch

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

rust-add-support-for-numa-ids-in-allocations-fix.patch

