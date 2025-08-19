Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91962257458
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646607; cv=none; b=HIDMzUuQfWHH1MRM4Hh4zUCRWbsGdZi/SOmN9FivbvllopwLHX3Kvpfh9gWC4kxrnb38r/390cPU01FNhxkHAKgEMLh8NPPHXDxj3CRwWqWnrYQFcUECanWgSooEgfIhtUAwb62NZr1yNJ+D1RCmYbKdZomEIrvAt/fhDa4uFgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646607; c=relaxed/simple;
	bh=1VRN8/mU5Ii/3eeQ3zVq9t4AOKe7MOKv6zM/Jt58tFA=;
	h=Date:To:From:Subject:Message-Id; b=Sr+qvzXERyC2OVjB5mgu82f/Igs+O1SHCVwZ+pFC2MKfZf2HTtKepcex/cvBhEA7rEoh2xOw8eYZ0pbSIXvdP+G4ehn2DI6L3542o4lx1zQjKmyxVTIDjdfwwFioHYSVUtYcx7ZUh7U/mMMFBU6ySD0P/LN2AhI212nwfO+vplU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bxG98Ebw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bxG98Ebw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66091C4CEF1;
	Tue, 19 Aug 2025 23:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646607;
	bh=1VRN8/mU5Ii/3eeQ3zVq9t4AOKe7MOKv6zM/Jt58tFA=;
	h=Date:To:From:Subject:From;
	b=bxG98Ebw2I5ZuEu/UGDyly8A4M5g0HekR0KCmzCLJ1cBYLZ/E0idWbAV3Z4+0hxwI
	 WT9c3i26tp78mBv1BeVqHwb3fRglCm6XODvjRzx/FAHr+fGGlX9pYInohXx2NJaGVB
	 280Fvkhga7WPqXjlJoyXk+DNL972YD34dxE2dygA=
Date: Tue, 19 Aug 2025 16:36:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,liam.howlett@oracle.com,dakr@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-rust-add-pagers-to-memory-management-rust.patch removed from -mm tree
Message-Id: <20250819233647.66091C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rust: add page.rs to MEMORY MANAGEMENT - RUST
has been removed from the -mm tree.  Its filename was
     mm-rust-add-pagers-to-memory-management-rust.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: mm: rust: add page.rs to MEMORY MANAGEMENT - RUST
Date: Thu, 14 Aug 2025 07:54:54 +0000

The page.rs file currently isn't included anywhere, and I think it's a
good fit for the MEMORY MANAGEMENT - RUST entry.  The file was originally
added for use by Rust Binder, but I believe there is also work to use it
in the upcoming scatterlist abstractions.

Link: https://lkml.kernel.org/r/20250814075454.1596482-1-aliceryhl@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~mm-rust-add-pagers-to-memory-management-rust
+++ a/MAINTAINERS
@@ -16248,8 +16248,10 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	rust/helpers/mm.c
+F:	rust/helpers/page.c
 F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
+F:	rust/kernel/page.rs
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from aliceryhl@google.com are


