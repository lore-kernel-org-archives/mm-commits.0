Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D8F21858D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188490; cv=none; b=pBOsv/Mx+d2m5+U7ON9mFVxTbsEfBFHFewCuoXb8AzU+8ImcbvgsegbeJ6ecMhXtXyC4VC1KLx3pes84ykz8pnDv6t3EE3kJPEQstQJmoYsE71VrTIowxtzkiGp6PSJmcvbSK50qdO/hwE1TVupEQqZpt//U9d+BqtkLvbghFbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188490; c=relaxed/simple;
	bh=jWlkXJfTvTFW+87bhv2yxOIMvmUyiQUQNaX+RSEqYOg=;
	h=Date:To:From:Subject:Message-Id; b=aJbxXDOlRjSrcsv4gzsI5bScl50nQ7kjefrj+QeoLn1plmufpje+yjXJXs/ljeGNUltAKJtvAIw3YJWYx+bT1E/gbtXHLifDZP9MUSv0DyrxSv+aw+GRUN6MCOmHZeuxI4Ry3uy/tqFRed0TTRYYTmPMLS557XUqZZ2CHqfEQWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZRNLxn6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZRNLxn6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29929C4CEEC;
	Mon, 17 Mar 2025 05:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188490;
	bh=jWlkXJfTvTFW+87bhv2yxOIMvmUyiQUQNaX+RSEqYOg=;
	h=Date:To:From:Subject:From;
	b=ZRNLxn6fSNX6eniID3GRJDW8XztannRAeF8TqXlBj9Bq3QvH913VNOqSCBePFLlSq
	 X2ayK3SQBtaI7Tbrpk5UOk34cCy/EkTtdBxaTZ+Ep9prY1ga1PNTw1TWjbGRiEOCMG
	 aAu96rgd7EHHk/HRs4I3RXMwPJ4PJOBuWNZzCYE0=
Date: Sun, 16 Mar 2025 22:14:49 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] configs-drop-generic_ptdump-from-debugconfig.patch removed from -mm tree
Message-Id: <20250317051450.29929C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: configs: drop GENERIC_PTDUMP from debug.config
has been removed from the -mm tree.  Its filename was
     configs-drop-generic_ptdump-from-debugconfig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: configs: drop GENERIC_PTDUMP from debug.config
Date: Wed, 26 Feb 2025 17:54:00 +0530

Patch series "mm: Rework generic PTDUMP configs", v3.

The series reworks generic PTDUMP configs before eventually renaming them
after some basic cleanups first.


This patch (of 5):

The platforms that support GENERIC_PTDUMP select the config explicitly. 
But enabling this feature on platforms that don't really support - does
nothing or might cause a build failure.  Hence just drop GENERIC_PTDUMP
from generic debug.config

Link: https://lkml.kernel.org/r/20250226122404.1927473-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20250226122404.1927473-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/debug.config |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/configs/debug.config~configs-drop-generic_ptdump-from-debugconfig
+++ a/kernel/configs/debug.config
@@ -73,7 +73,6 @@ CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_VM_PGFLAGS=y
 CONFIG_DEBUG_VM_RB=y
 CONFIG_DEBUG_VM_VMACACHE=y
-CONFIG_GENERIC_PTDUMP=y
 CONFIG_KASAN=y
 CONFIG_KASAN_GENERIC=y
 CONFIG_KASAN_INLINE=y
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


