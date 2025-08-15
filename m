Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB39C8EB
	for <mm-commits@vger.kernel.org>; Fri, 15 Aug 2025 00:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755219247; cv=none; b=XMEni2LH1P1F4Nu887+rg1yud5yzOL8oT0qNTP1GQnDWVHomShy8DqRfOwTnadEJpXJfe53fE+W3IJUFNIjp9g8AxkJfiYT2U8TdqowP3KeknuNELOpYRukH//qqn+n/kYvSKKeRvz4GAuwtP0zLHDKR1GQzul0is4kVMjh2wPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755219247; c=relaxed/simple;
	bh=7u9wJrkw0OKK+COehko2yqgqLY9BpydVqcLGrNBQ0UY=;
	h=Date:To:From:Subject:Message-Id; b=TUgdFn4mnQO+Cr+/BHcIwJAEdV5ShAurpJX26E4QNmilMYzqCxqlOk6FTQwf6SfEFJ/d3BfNe0hpJ+wj65IZYIojWEe+TW/HzrfkSSZPIicZL2F2pVxP4VxgNB1UySQ6TFMQdA+c/1kPwNAHsVD5Gls7wwR8EhWgOodfBeG0G2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1FzoyQsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1FzoyQsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F68EC4CEED;
	Fri, 15 Aug 2025 00:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755219247;
	bh=7u9wJrkw0OKK+COehko2yqgqLY9BpydVqcLGrNBQ0UY=;
	h=Date:To:From:Subject:From;
	b=1FzoyQsOnOFjZSV4glmw++gAtEuRlslV0IpPp+eHO2LpnGIyPjXL3XtTMp6JLn3j/
	 rqUQ3zFay6g4O8Pq2kIgkAOL47yuq8quAHlr65r2Px1l3sE9yeXY988jXqXsUzbTei
	 +nhMxgm9ONXp5JzDwWGGxsVqLVRhksJYOu67I73s=
Date: Thu, 14 Aug 2025 17:54:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,liam.howlett@oracle.com,dakr@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rust-add-pagers-to-memory-management-rust.patch added to mm-hotfixes-unstable branch
Message-Id: <20250815005407.2F68EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rust: add page.rs to MEMORY MANAGEMENT - RUST
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-rust-add-pagers-to-memory-management-rust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rust-add-pagers-to-memory-management-rust.patch

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
@@ -16252,8 +16252,10 @@ S:	Maintained
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

mm-rust-add-pagers-to-memory-management-rust.patch

