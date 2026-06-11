Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F0B409E1B;
	Thu, 11 Jun 2026 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781197027; cv=none; b=J0NIn37iBUsOUqTwLGD5aNYiM879XhzlKILAKQnYbqRGjCpW7fX4xZhDhBpQeon7iy3XFfo3wmIhB5Uc2lxCaVJUxGgaf40NGTFht+1L1LFz5x75hLJaXI3z0R7n46R5bXlXSYHAABsf2YWsEhSjl3qipRLQN1ptt4EmnMYAW7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781197027; c=relaxed/simple;
	bh=2aZVq+ET4HMbKAAl5quJjiT0IOH+ArAwSdVxujmsH0o=;
	h=Date:To:From:Subject:Message-Id; b=KXxVRiWtOt8HiuN/0MMI2laK1AaaxeYzPRycLOG4yWJZ+D70f8dstLHcjAKqZVGwES2kg7B5NM4ZdfFjy0gUCMiqvVuSr1ZFQY8jHn46gQKJi2eosSAgTU86AComL55aIoW1G+CB06FOdGMr+Kpys4QwfmvqYRgCIuarzQ2F5W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NJLvE4JV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NJLvE4JV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F0D1F00893;
	Thu, 11 Jun 2026 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781197025;
	bh=fYZVN/8JrHXaEblKO/3T5yNJmci1vcoU7gZXoqwKlwc=;
	h=Date:To:From:Subject;
	b=NJLvE4JVb9W/Px1ktCgY/JumZNGbkLiMfmdPGfyfCjXSXi1r9QRMk0jDMwVIOF1WX
	 ojJIQXElF2jRel5bt3zF+np4/+/x93M5SJ8Fz130I6a3p8phH65BtgBaD9L2AoWA7g
	 dUZ8dbQVBjjtHJeU3NHC+XykQF8TcnfJvv6lKkls=
Date: Thu, 11 Jun 2026 09:57:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,aliceryhl@google.com,enelsonmoore@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch added to mm-unstable branch
Message-Id: <20260611165705.A2F0D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix CONFIG_STACK_GROWSUP typo in tools/testing/vma/include/dup.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: mm: fix CONFIG_STACK_GROWSUP typo in tools/testing/vma/include/dup.h
Date: Wed, 10 Jun 2026 18:22:44 -0700

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
refactored the header file include/linux/mm.h.  In that step, it
introduced a typo in an ifdef, referring to a non-existing config option
STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.

Commit 40a4af52e047 ("mm: fix CONFIG_STACK_GROWSUP typo in mm.h") fixed
this typo in the mm.h header file, but did not update the copy of the code
in tools/testing/vma/include/dup.h.  Update this copy as well.

Commit message adapted from the above-referenced fix to mm.h.

Link: https://lore.kernel.org/20260611012258.432043-1-enelsonmoore@gmail.com
Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/vma/include/dup.h~mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph
+++ a/tools/testing/vma/include/dup.h
@@ -243,7 +243,7 @@ enum {
 #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
 #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
 #define VM_STACK	INIT_VM_FLAG(STACK)
-#ifdef CONFIG_STACK_GROWS_UP
+#ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
 #else
 #define VM_STACK_EARLY	VM_NONE
_

Patches currently in -mm which might be from enelsonmoore@gmail.com are

mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch

