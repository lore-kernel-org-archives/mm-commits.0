From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-add-pmd_-for-thp.patch removed from -mm tree
Date: Mon, 02 Nov 2015 15:13:07 -0800
Message-ID: <5637ee03.VWAVPcc2gBqAteF0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbKBXNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 18:13:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: add pmd_[dirty|mkclean] for THP
has been removed from the -mm tree.  Its filename was
     x86-add-pmd_-for-thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: x86: add pmd_[dirty|mkclean] for THP

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent overwrite
of the contents since MADV_FREE syscall is called for THP page.

This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
support.

[akpm@linux-foundation.org: mm-fix-huge-zero-page-accounting-in-smaps-report.patch also added pmd_dirty()]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~x86-add-pmd_-for-thp arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-add-pmd_-for-thp
+++ a/arch/x86/include/asm/pgtable.h
@@ -262,6 +262,11 @@ static inline pmd_t pmd_mkold(pmd_t pmd)
 	return pmd_clear_flags(pmd, _PAGE_ACCESSED);
 }
 
+static inline pmd_t pmd_mkclean(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_DIRTY);
+}
+
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
 	return pmd_clear_flags(pmd, _PAGE_RW);
_

Patches currently in -mm which might be from minchan@kernel.org are

sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch

