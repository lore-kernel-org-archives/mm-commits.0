Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AD11EB37
	for <mm-commits@vger.kernel.org>; Mon,  1 Apr 2024 16:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989660; cv=none; b=qWNXFZ07EIQ75K/xKuR6KaUAgND2sTcUlMBYYSpiz/HH7DyEReADK9mCZtG/prpAtYD/mEki91o3uVI6g7TKVhOjdISrVNHBhVnmu6+hcni1oZI7TluxZgXQvJwNAaWVM1N0PJ1VagN3jvHX3tPNEuiVTPr+UBUX8I4wi2Z+C2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989660; c=relaxed/simple;
	bh=67BU/CAI8IR8zyvUCx6lOMBVR+n/slJvfjIduDo8zqM=;
	h=Date:To:From:Subject:Message-Id; b=BG2uN6qbJCupOIBWwuUD3qqmHs6fwE6t3BxoZ2rXRAX6NdmMXbhdT/DTBUrEgge2gqgO7rELGDGy/ZrzGE3cLTVCrfcNQ4KkP4k/BzP1sD3LFB3nVQi2H0d9JWOEunjCUf3LIUCstGYzvm0bh1NbcV9qHXn1lJN3PVQucJdwHQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JF5TqTDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JF5TqTDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F73C433F1;
	Mon,  1 Apr 2024 16:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711989660;
	bh=67BU/CAI8IR8zyvUCx6lOMBVR+n/slJvfjIduDo8zqM=;
	h=Date:To:From:Subject:From;
	b=JF5TqTDkb7TONpG+jBA5D/bYV3+8lDbRBs9e5f/kxOhoHDHBWIHmnrQs3BefwZxYB
	 m6O3OU9iwbobWdx6PIxO7rp++Uu0iKjLWCG3/tEc8LyntnGiHA1zcCvOo3hX13Cloh
	 B/CYPE2eb/gRPHM/wuoIsG6X6jLxV+LyQ1dsdL9g=
Date: Mon, 01 Apr 2024 09:40:59 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,hch@lst.de,fei1.li@intel.com,david@redhat.com,dave.hansen@linux.intel.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix-2.patch added to mm-unstable branch
Message-Id: <20240401164100.02F73C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix-2.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix-2
Date: Thu, 28 Mar 2024 08:25:58 -0700

memtype.c needs highmem.h

Link: https://lkml.kernel.org/r/20240328152558.GA2652500@dev-arch.thelio-3990X
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fei Li <fei1.li@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/mm/pat/memtype.c~mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix-2
+++ a/arch/x86/mm/pat/memtype.c
@@ -39,6 +39,7 @@
 #include <linux/pfn_t.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/fs.h>
 #include <linux/rbtree.h>
 
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix-2.patch

