From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:37 -0700
Message-ID: <543d6939.AeQFzThqhZY9nTXE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbaJNSTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryazanov.s.a@gmail.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: update $allowed_asm_includes macros, add reboot.h and time.h
has been removed from the -mm tree.  Its filename was
     checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

