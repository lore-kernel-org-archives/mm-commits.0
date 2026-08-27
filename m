Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2E5222599
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 03:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787800267; cv=none; b=G19LKgkcqlp1igBdezyFHkhWv65G513zn78+QHIsPGbNk6cdmSCZ1+O/7zGQV4v8eFipbsRbyTTUjnmDlHXDWJJ4oPB2jMqjTbGf6OZkCWCFh1R89x7sYjFGNPtd0o+QUhRDyKcmY8k8cyOk/1jCyZhtF3pGe0+aHsDQQUNQt6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787800267; c=relaxed/simple;
	bh=4/jKTI5GRWVE/HQb7HNCLzixcU49uZ96b7h3LZSswNo=;
	h=Date:To:From:Subject:Message-Id; b=M1tsFCB1Qz37N6HQSRQ0g90TeeLiiuWw6ZwjwEQMylLAkNuHhCRi/F5kUGMNrieFu+gNDgZxwdd8BwekURyyf6NRDb+9eRwbn32pStXWwUkWD2aEtHX/xCZlq9LqBYZuHrLcjnoRKjZA2iD71QjbQNdi8C2Ef0E9eHu49SpT4e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WvQriOsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WvQriOsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7551F000E9;
	Thu, 27 Aug 2026 03:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787800265;
	bh=Y4a9sFIavde71Ds3tDiViJrSsobOfeILck5jo7x0svU=;
	h=Date:To:From:Subject;
	b=WvQriOsPg/0xGxn1ckgZlpWP8XZ75EcEQH6brlxz/hILND0EktmZussEhx5y5Rbd4
	 Ej7NZSm6bxJdHo4F1RUUhzAWYVE/+r+xdq3YZ7tmSvx+iV8f5UgfZZdbUDRGgH2oSu
	 p5OMFFrr5mPxZVCPAqoHJic+Xm20cb1AdRGdzPt0=
Date: Wed, 26 Aug 2026 20:11:04 -0700
To: mm-commits@vger.kernel.org,yury.khrustalev@arm.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,david@kernel.org,hemanth.selam@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-the-local-pkey_unrestricted-fallback.patch added to mm-new branch
Message-Id: <20260827031105.5C7551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove the local PKEY_UNRESTRICTED fallback
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-the-local-pkey_unrestricted-fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-the-local-pkey_unrestricted-fallback.patch

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
From: Hemanth Selam <hemanth.selam@gmail.com>
Subject: selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Date: Tue, 25 Aug 2026 21:47:15 +0530

pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
already known, a stopgap from when the generic definition was still under
review.  It has been merged since, commit 6d61527d931b ("mm/pkey: Add
PKEY_UNRESTRICTED macro"), so the guard is never taken and the FIXME can
be honoured.

The definition comes from tools/include/uapi/asm-generic/mman-common.h via
TOOLS_INCLUDES, which commit e076eaca5906 ("selftests: break the
dependency upon local header files") added so that the mm selftests build
without "make headers".  It is reached through the <asm-generic/mman.h>
that the system <asm/mman.h> includes.  Building the pkey tests with
KHDR_INCLUDES pointing at an empty directory confirms that; emptying
TOOLS_INCLUDES as well is what makes the macro go missing.

No functional change intended.

Assisted-by: Cursor:claude-opus-5
Link: https://lore.kernel.org/20260825161715.2807297-1-hemanth.selam@gmail.com
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-helpers.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-remove-the-local-pkey_unrestricted-fallback
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -114,13 +114,6 @@ void record_pkey_malloc(void *ptr, long
 #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
 #endif
 
-/*
- * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
- */
-#ifndef PKEY_UNRESTRICTED
-#define PKEY_UNRESTRICTED 0x0
-#endif
-
 #ifndef set_pkey_bits
 static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
 {
_

Patches currently in -mm which might be from hemanth.selam@gmail.com are

selftests-mm-remove-the-local-pkey_unrestricted-fallback.patch

