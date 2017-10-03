From: akpm@linux-foundation.org
Subject: [patch 20/51] mm: fix RODATA_TEST failure "rodata_test: test data was not read only"
Date: Tue, 03 Oct 2017 16:15:16 -0700
Message-ID: <59d41a04.WcsfY5dXF4q00E/W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, christophe.leroy@c-s.fr, David.Laight@ACULAB.COM, jinb.park7@gmail.com, keescook@chromium.org, segher@kernel.crashing.org, stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: mm: fix RODATA_TEST failure "rodata_test: test data was not read only"

On powerpc, RODATA_TEST fails with message the following messages:

[    6.199505] Freeing unused kernel memory: 528K
[    6.203935] rodata_test: test data was not read only

This is because GCC allocates it to .data section:

c0695034 g     O .data	00000004 rodata_test_data

Since 056b9d8a76924 ("mm: remove rodata_test_data export, add pr_fmt"),
rodata_test_data is used only inside rodata_test.c By declaring it static,
it gets properly allocated into .rodata section instead of .data:

c04df710 l     O .rodata	00000004 rodata_test_data

Fixes: 056b9d8a76924 ("mm: remove rodata_test_data export, add pr_fmt")
Link: http://lkml.kernel.org/r/20170921093729.1080368AC1@po15668-vm-win7.idsi0.si.c-s.fr
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jinbum Park <jinb.park7@gmail.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rodata_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rodata_test.c~mm-fix-rodata_test-failure-rodata_test-test-data-was-not-read-only mm/rodata_test.c
--- a/mm/rodata_test.c~mm-fix-rodata_test-failure-rodata_test-test-data-was-not-read-only
+++ a/mm/rodata_test.c
@@ -14,7 +14,7 @@
 #include <linux/uaccess.h>
 #include <asm/sections.h>
 
-const int rodata_test_data = 0xC3;
+static const int rodata_test_data = 0xC3;
 
 void rodata_test(void)
 {
_
