From: akpm@linux-foundation.org
Subject: +
 checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
 added to -mm tree
Date: Tue, 26 Aug 2014 16:17:56 -0700
Message-ID: <53fd15a4.oGF/eCz7DHXhDoIP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:50588 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbaHZXR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:17:57 -0400
Received: by mail-ob0-f201.google.com with SMTP id va2so2489935obc.4
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:17:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryazanov.s.a@gmail.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: update $allowed_asm_includes macros, add reboot.h and time.h
has been added to the -mm tree.  Its filename is
     checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: checkpatch: update $allowed_asm_includes macros, add reboot.h and time.h

Several architectures (e.g.  x86, MIPS, Blackfin) have asm/reboot.h and
asm/time.h header files, which are not included in linux/reboot.h and
linux/time.h headers.  This lead to generation of false positive errors.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh
+++ a/scripts/checkpatch.pl
@@ -425,7 +425,9 @@ foreach my $entry (@mode_permission_func
 
 our $allowed_asm_includes = qr{(?x:
 	irq|
-	memory
+	memory|
+	time|
+	reboot
 )};
 # memory.h: ARM has a custom one
 
_

Patches currently in -mm which might be from ryazanov.s.a@gmail.com are

checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
linux-next.patch

