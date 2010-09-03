From: akpm@linux-foundation.org
Subject: + m68knommu-fix-missing-linker-segments.patch added to -mm tree
Date: Fri, 03 Sep 2010 15:02:26 -0700
Message-ID: <201009032202.o83M2QQw014910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab0ICWCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 18:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org, tj@kernel.org


The patch titled
     m68knommu: fix missing linker segments
has been added to the -mm tree.  Its filename is
     m68knommu-fix-missing-linker-segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: fix missing linker segments
From: Greg Ungerer <gerg@snapgear.com>

Recent changes to linker segments that hold per-cpu data broke linking for
m68knommu targets:

  LD      vmlinux
/usr/local/bin/m68k-uclinux-ld.real: error: no memory region specified for loadable section `.data..shared_aligned'

Add missing segments into the m68knommu linker script.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/m68knommu/kernel/vmlinux.lds.S~m68knommu-fix-missing-linker-segments arch/m68knommu/kernel/vmlinux.lds.S
--- a/arch/m68knommu/kernel/vmlinux.lds.S~m68knommu-fix-missing-linker-segments
+++ a/arch/m68knommu/kernel/vmlinux.lds.S
@@ -150,6 +150,8 @@ SECTIONS {
 		_sdata = . ;
 		DATA_DATA
 		CACHELINE_ALIGNED_DATA(32)
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
+		*(.data..shared_aligned)
 		INIT_TASK_DATA(THREAD_SIZE)
 		_edata = . ;
 	} > DATA
_

Patches currently in -mm which might be from gerg@snapgear.com are

m68knommu-fix-missing-linker-segments.patch

