From: akpm@linux-foundation.org
Subject: [merged] mm-kmemleakc-remove-obsolete-simple_strtoul.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:49 -0800
Message-ID: <20121219204250.059E720005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:42938 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2LSUmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:52 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so140200lbc.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abhi.c.pawar@gmail.com, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak.c: remove obsolete simple_strtoul
has been removed from the -mm tree.  Its filename was
     mm-kmemleakc-remove-obsolete-simple_strtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: mm/kmemleak.c: remove obsolete simple_strtoul

Replace the obsolete simple_strtoul() with kstrtoul().

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/kmemleak.c~mm-kmemleakc-remove-obsolete-simple_strtoul mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleakc-remove-obsolete-simple_strtoul
+++ a/mm/kmemleak.c
@@ -1556,7 +1556,8 @@ static int dump_str_object_info(const ch
 	struct kmemleak_object *object;
 	unsigned long addr;
 
-	addr= simple_strtoul(str, NULL, 0);
+	if (kstrtoul(str, 0, &addr))
+		return -EINVAL;
 	object = find_and_get_object(addr, 0);
 	if (!object) {
 		pr_info("Unknown object at 0x%08lx\n", addr);
_

Patches currently in -mm which might be from abhi.c.pawar@gmail.com are

origin.patch

