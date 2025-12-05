Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8224D1F8755
	for <mm-commits@vger.kernel.org>; Fri,  5 Dec 2025 20:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764965711; cv=none; b=e3OILCYEPTC08urXngWSDkL+13ASml/5zYvNk700/o91vne75vAcymzCb3nw8zQO7u7UG92UEOUb1Ss4zJuGOf2movmO4Cz3XZkqBzVYI1qBhjb/EPaZ31ekPVRZVji+dOte+4oHgHqLHxEM6OQwskHveTEna/zGQYnnRIVoBdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764965711; c=relaxed/simple;
	bh=JG6wzWmeKFHcbhAx1CqxmixBMr/FiR1X3x2mFn21rhU=;
	h=Date:To:From:Subject:Message-Id; b=lERHe4+WSSQkSTmIInJUC4cQUuHE7xl0hIMsCh5PcVWKO6DoNNf6LyGzooITub7/BkjZvv4InQdm/wqFHAPzYf5k4gqbbRgVmQteUNkBe0UNK1q4qEqn+N+PxGGG4g94+3UUYE4ZV/3oU8+2LtBWMfHigTqIOV/AdOCreoC0Cw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OA1kJxqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OA1kJxqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D83EC4CEF1;
	Fri,  5 Dec 2025 20:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764965710;
	bh=JG6wzWmeKFHcbhAx1CqxmixBMr/FiR1X3x2mFn21rhU=;
	h=Date:To:From:Subject:From;
	b=OA1kJxqSvAGjyuX0oGRzZlgavB7vbW144qQV4ZhVP6NHHA/B/eXg6M9FZd119jDo9
	 Xoh0yCHxZDqHxxtw9WUsDPtT6yAs9FycHdn6uK5cN5Ot1Bt91LoGX9NHQK8A6eSGfo
	 Y2xRAq32y6H/w2HtrZGMrjZg4yRrsdwMos70JkKM=
Date: Fri, 05 Dec 2025 12:15:09 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,oliver.sang@intel.com,mhocko@suse.com,liam.howlett@oracle.com,jhubbard@nvidia.com,david.laight.linux@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch added to mm-unstable branch
Message-Id: <20251205201510.3D83EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid use of BIT() macro for initialising VMA flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: avoid use of BIT() macro for initialising VMA flags
Date: Fri, 5 Dec 2025 17:50:37 +0000

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
how VMA flags are declared, utilising an enum of VMA bit values and
ifdef-fery VM_xxx flag declarations via macro.

As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
the newly introduced VMA bit numbers.

However, use of this macro results in apparently unfortunate macro
expansion and resulted in a performance degradation.This appears to be due
to the (__force int), which is required for the sparse typechecking to
work.

Avoid macro expansion issues by simply using 1UL << bitnum.

Link: https://lkml.kernel.org/r/20251205175037.1287366-1-lorenzo.stoakes@oracle.com
Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202512041634.150c7e4f-lkp@intel.com
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-avoid-use-of-bit-macro-for-initialising-vma-flags
+++ a/include/linux/mm.h
@@ -395,7 +395,8 @@ enum {
 #undef DECLARE_VMA_BIT
 #undef DECLARE_VMA_BIT_ALIAS
 
-#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
+#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
+
 #define VM_READ		INIT_VM_FLAG(READ)
 #define VM_WRITE	INIT_VM_FLAG(WRITE)
 #define VM_EXEC		INIT_VM_FLAG(EXEC)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch

