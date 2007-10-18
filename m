From: akpm@linux-foundation.org
Subject: - add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:03 -0700
Message-ID: <200710180657.l9I6v3rR030757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761881AbXJRHPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oomichi@mxs.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     add-vmcore: add nodemask_t's size and NR_FREE_PAGES's value to vmcoreinfo_data
has been removed from the -mm tree.  Its filename was
     add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add-vmcore: add nodemask_t's size and NR_FREE_PAGES's value to vmcoreinfo_data
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

[2/3] Add nodemask_t's size and NR_FREE_PAGES's value to vmcoreinfo_data.
  The dump filetering command 'makedumpfile'(v1.1.6 or before) had assumed
  the above values, and it was not good from the reliability viewpoint.
  So makedumpfile v1.2.0 came to need these values and I created the patch
  to let the kernel output them.
  makedumpfile site:
  https://sourceforge.net/projects/makedumpfile/

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    5 +++++
 kernel/kexec.c        |    2 ++
 2 files changed, 7 insertions(+)

diff -puN include/linux/kexec.h~add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data include/linux/kexec.h
--- a/include/linux/kexec.h~add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data
+++ a/include/linux/kexec.h
@@ -132,11 +132,16 @@ unsigned long paddr_vmcoreinfo_note(void
 #define SIZE(name) \
 	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
 			      (unsigned long)sizeof(struct name))
+#define TYPEDEF_SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+			      (unsigned long)sizeof(name))
 #define OFFSET(name, field) \
 	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
 			      (unsigned long)&(((struct name *)0)->field))
 #define LENGTH(name, value) \
 	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
+#define NUMBER(name) \
+	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
 #define CONFIG(name) \
 	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
 
diff -puN kernel/kexec.c~add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data kernel/kexec.c
--- a/kernel/kexec.c~add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data
+++ a/kernel/kexec.c
@@ -1218,6 +1218,7 @@ static int __init crash_save_vmcoreinfo_
 	SIZE(zone);
 	SIZE(free_area);
 	SIZE(list_head);
+	TYPEDEF_SIZE(nodemask_t);
 	OFFSET(page, flags);
 	OFFSET(page, _count);
 	OFFSET(page, mapping);
@@ -1237,6 +1238,7 @@ static int __init crash_save_vmcoreinfo_
 	OFFSET(list_head, next);
 	OFFSET(list_head, prev);
 	LENGTH(zone.free_area, MAX_ORDER);
+	NUMBER(NR_FREE_PAGES);
 
 	arch_crash_save_vmcoreinfo();
 
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

origin.patch
