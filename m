From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-mm-percpuc.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:27 -0700
Message-ID: <20121005201328.13C5C5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:32830 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab2JEUN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:29 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so139530wey.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in mm/percpu.c
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-mm-percpuc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in mm/percpu.c

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    2 +-
 mm/percpu.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/percpu.h~sections-fix-section-conflicts-in-mm-percpuc include/linux/percpu.h
--- a/include/linux/percpu.h~sections-fix-section-conflicts-in-mm-percpuc
+++ a/include/linux/percpu.h
@@ -107,7 +107,7 @@ enum pcpu_fc {
 
 	PCPU_FC_NR,
 };
-extern const char *pcpu_fc_names[PCPU_FC_NR];
+extern const char * const pcpu_fc_names[PCPU_FC_NR];
 
 extern enum pcpu_fc pcpu_chosen_fc;
 
diff -puN mm/percpu.c~sections-fix-section-conflicts-in-mm-percpuc mm/percpu.c
--- a/mm/percpu.c~sections-fix-section-conflicts-in-mm-percpuc
+++ a/mm/percpu.c
@@ -1370,7 +1370,7 @@ int __init pcpu_setup_first_chunk(const 
 
 #ifdef CONFIG_SMP
 
-const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
+const char * const pcpu_fc_names[PCPU_FC_NR] __initconst = {
 	[PCPU_FC_AUTO]	= "auto",
 	[PCPU_FC_EMBED]	= "embed",
 	[PCPU_FC_PAGE]	= "page",
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

