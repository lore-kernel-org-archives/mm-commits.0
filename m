Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE312336ED2
	for <mm-commits@vger.kernel.org>; Mon,  1 Dec 2025 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764609053; cv=none; b=QGDIgHVYJbSPLGSvkXFcc6MCNbioIl2YnXoJCYBng9tal1El9WcuSFUDAJJrdLhj1JPutNJYwETWqj4gSf+nAguXNhFRk6+UgI+y5F+nAs6EixzRJhwIIgswWf2gsA6KDy3XTjXod2WalG/Gej0r+3Jrra8IIZfY7YtJPSl1J1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764609053; c=relaxed/simple;
	bh=4CopsYAQW1YCS03VSQqWaZ7RGf6B6hFAAuvpgCGU8xU=;
	h=Date:To:From:Subject:Message-Id; b=rp6MA/lEKZqc4FJ7b70svG6EoHosLI82lAK5x1pcbF/L0VpdLnS29axXb/3xY8xFWhFyjoW06KpWQbicFIs0ygAfClA+3rgn3qSk8eru4qWAnKAhiG359EXYHb572m1Zwn06kLUuhWostyuK3eiVjgg4V86xoS/7pjafEj/7cPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VLF89cml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VLF89cml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DE7C4CEF1;
	Mon,  1 Dec 2025 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764609052;
	bh=4CopsYAQW1YCS03VSQqWaZ7RGf6B6hFAAuvpgCGU8xU=;
	h=Date:To:From:Subject:From;
	b=VLF89cmlsaTDadJqvLxchcR8K+Joajt3uLqaklY2XdzZ7XQgxi4zQUzPrD7Fg3QFS
	 jEM/cJBrVDGLkRyGiekBQT1wgzejHa3aoEHYRuFjQ6jgjyNuoEkiWtEX+vxUko9tJe
	 GP2jVKDKOrD6Q7y40pnbJIVGJvEF6+s90Dyn0/VI=
Date: Mon, 01 Dec 2025 09:10:52 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,aliceryhl@google.com,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-config-option-typo-in-header-file.patch added to mm-unstable branch
Message-Id: <20251201171052.A2DE7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix CONFIG_STACK_GROWSUP typo in mm.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-config-option-typo-in-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-config-option-typo-in-header-file.patch

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
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: mm: fix CONFIG_STACK_GROWSUP typo in mm.h
Date: Mon, 1 Dec 2025 13:29:22 +0100

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
refactors the header file include/linux/mm.h.  In that step, it introduces
a typo in an ifdef, referring to a non-existing config option
STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.

Fix this typo in the mm header file.

Link: https://lkml.kernel.org/r/20251201122922.352480-1-lukas.bulwahn@redhat.com
Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-fix-config-option-typo-in-header-file
+++ a/include/linux/mm.h
@@ -438,7 +438,7 @@ enum {
 #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
 #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
 #define VM_STACK	INIT_VM_FLAG(STACK)
-#ifdef CONFIG_STACK_GROWS_UP
+#ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
 #else
 #define VM_STACK_EARLY	VM_NONE
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are

mm-fix-config-option-typo-in-header-file.patch

