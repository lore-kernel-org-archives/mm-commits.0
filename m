From: akpm@linux-foundation.org
Subject: +
 x86-mm-avoid-allocating-struct-mm_struct-on-the-stack-fix.patch added to
 -mm tree
Date: Fri, 10 Jan 2020 13:05:49 -0800
Message-ID: <20200110210549.32SMSqvbP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgAJVFv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jan 2020 16:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anders.roxell@linaro.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, steven.price@arm.com


The patch titled
     Subject: x86-mm-avoid-allocating-struct-mm_struct-on-the-stack-fix
has been added to the -mm tree.  Its filename is
     x86-mm-avoid-allocating-struct-mm_struct-on-the-stack-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-avoid-allocating-struct-mm_struct-on-the-stack-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-avoid-allocating-struct-mm_struct-on-the-stack-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: x86-mm-avoid-allocating-struct-mm_struct-on-the-stack-fix

restore missed arm64 changes

Link: http://lkml.kernel.org/r/20200108145710.34314-1-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/dump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/dump.c~x86-mm-avoid-allocating-struct-mm_struct-on-the-stack-fix
+++ a/arch/arm64/mm/dump.c
@@ -323,7 +323,7 @@ void ptdump_walk(struct seq_file *s, str
 		}
 	};
 
-	ptdump_walk_pgd(&st.ptdump, info->mm);
+	ptdump_walk_pgd(&st.ptdump, info->mm, NULL);
 }
 
 static void ptdump_initialize(void)
@@ -361,7 +361,7 @@ void ptdump_check_wx(void)
 		}
 	};
 
-	ptdump_walk_pgd(&st.ptdump, &init_mm);
+	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 
 	if (st.wx_pages || st.uxn_pages)
 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
_

Patches currently in -mm which might be from steven.price@arm.com are

mm-add-generic-pd_leaf-macros.patch
arc-mm-add-pd_leaf-definitions.patch
arm-mm-add-pd_leaf-definitions.patch
arm64-mm-add-pd_leaf-definitions.patch
mips-mm-add-pd_leaf-definitions.patch
powerpc-mm-add-pd_leaf-definitions.patch
riscv-mm-add-pd_leaf-definitions.patch
s390-mm-add-pd_leaf-definitions.patch
sparc-mm-add-pd_leaf-definitions.patch
x86-mm-add-pd_leaf-definitions.patch
mm-pagewalk-add-p4d_entry-and-pgd_entry.patch
mm-pagewalk-allow-walking-without-vma.patch
mm-pagewalk-dont-lock-ptes-for-walk_page_range_novma.patch
mm-pagewalk-fix-termination-condition-in-walk_pte_range.patch
mm-pagewalk-add-depth-parameter-to-pte_hole.patch
x86-mm-point-to-struct-seq_file-from-struct-pg_state.patch
x86-mmefi-convert-ptdump_walk_pgd_level-to-take-a-mm_struct.patch
x86-mm-convert-ptdump_walk_pgd_level_debugfs-to-take-an-mm_struct.patch
mm-add-generic-ptdump.patch
x86-mm-convert-dump_pagetables-to-use-walk_page_range.patch
arm64-mm-convert-mm-dumpc-to-use-walk_page_range.patch
arm64-mm-display-non-present-entries-in-ptdump.patch
mm-ptdump-reduce-level-numbers-by-1-in-note_page.patch
x86-mm-avoid-allocating-struct-mm_struct-on-the-stack.patch
x86-mm-avoid-allocating-struct-mm_struct-on-the-stack-fix.patch
