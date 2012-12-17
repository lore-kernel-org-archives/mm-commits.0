From: akpm@linux-foundation.org
Subject: + mm-kmemleakc-remove-obsolete-simple_strtoul.patch added to -mm tree
Date: Mon, 17 Dec 2012 13:40:48 -0800
Message-ID: <20121217214049.1EA5D200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:49579 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2LQVkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 16:40:51 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so349785lag.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 13:40:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: abhi.c.pawar@gmail.com, catalin.marinas@arm.com


The patch titled
     Subject: mm/kmemleak.c: remove obsolete simple_strtoul
has been added to the -mm tree.  Its filename is
     mm-kmemleakc-remove-obsolete-simple_strtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-kmemleakc-remove-obsolete-simple_strtoul.patch

