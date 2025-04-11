Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E1220B7F1
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 22:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744411806; cv=none; b=ZbFxBwvkk8mdkaPkzfCnk1IFmieAHhvrnwvz5PTR6r86gwEI4hKz4VImXSQGjlnn7T6RAq+mRBdmhOvonj0/q3/DXCJGKM8ZoNarwj0QAsv/pytqSiU5FCvz3BE6skepxe7BGamLxTeObZ/XTmSYIqnbz7OB7w+IS+NtRVu3gc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744411806; c=relaxed/simple;
	bh=micdLYmXUVnGIjKf8vBxf0Y7ttxRPEaMu+NOsv+aFdY=;
	h=Date:To:From:Subject:Message-Id; b=p2/4Z5JMEhTCKKf/Ix+KkfAPhnPp6WJceRMnL6bFdb6ecx3Sos2JiWAOEBV0h6t/HHUzfd7WgPTkuz/bpT2zc2FJgl/J8UTSUb/CrzwXzvHzCeNL9S5paSpW6ySGnOhscEC/WM8bCsj3OaFxqywqDlty0Ke8mpUUoxnawR2dP/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XENABpgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XENABpgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8708C4CEE5;
	Fri, 11 Apr 2025 22:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744411805;
	bh=micdLYmXUVnGIjKf8vBxf0Y7ttxRPEaMu+NOsv+aFdY=;
	h=Date:To:From:Subject:From;
	b=XENABpgQij5uFlm9kJLlbD4rVAi2pOQSmW12RB7jndCOnel3PaMDei1ts/UjXI1+y
	 vJuvG98idUoqYS6kbTYjdLP/2OIE9mBmZWAJdkwNL1QFx6QZ0hkxc0fsaajAaQgC0b
	 VyuqAQShIxJavN2o3Fd5WVflgQW/e2OC/91C8qVY=
Date: Fri, 11 Apr 2025 15:50:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-memory-advice-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250411225005.D8708C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add memory advice section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-memory-advice-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-memory-advice-section.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add memory advice section
Date: Fri, 11 Apr 2025 08:27:24 +0100

The madvise code straddles both VMA and page table manipulation.  As a
result, separate it out into its own section and add maintainers/reviewers
as appropriate.

We additionally include the mman-common.h file as this contains the shared
madvise flags and it is important we maintain this alongside madvise.c.

Link: https://lkml.kernel.org/r/20250411072724.10841-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/MAINTAINERS~maintainers-add-memory-advice-section
+++ a/MAINTAINERS
@@ -15569,6 +15569,20 @@ F:	mm/vma.h
 F:	mm/vma_internal.h
 F:	tools/testing/vma/
 
+MEMORY MAPPING - MADVISE (MEMORY ADVICE)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	David Hildenbrand <david@redhat.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Jann Horn <jannh@google.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/uapi/asm-generic/mman-common.h
+F:	mm/madvise.c
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-add-give_up_on_oom-option-on-modify-merge-use-in-uffd-release.patch
maintainers-add-memory-advice-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch

