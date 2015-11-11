From: akpm@linux-foundation.org
Subject: [merged]
 selftests-mlock2-add-ull-prefix-to-64-bit-constants.patch removed from -mm
 tree
Date: Wed, 11 Nov 2015 11:48:07 -0800
Message-ID: <56439b77.jJtmgWD0F4a3v3Qk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbKKTsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, emunson@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mlock2: add ULL suffix to 64-bit constants
has been removed from the -mm tree.  Its filename was
     selftests-mlock2-add-ull-prefix-to-64-bit-constants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: selftests/mlock2: add ULL suffix to 64-bit constants

On 32-bit (e.g. m68k):

mlock2-tests.c: In function 'lock_check':
mlock2-tests.c:293: warning: integer constant is too large for 'long' type
mlock2-tests.c:294: warning: integer constant is too large for 'long' type
mlock2-tests.c:299: warning: integer constant is too large for 'long' type
mlock2-tests.c:300: warning: integer constant is too large for 'long' type
mlock2-tests.c: In function 'unlock_lock_check':
mlock2-tests.c:329: warning: integer constant is too large for 'long' type
mlock2-tests.c:330: warning: integer constant is too large for 'long' type
mlock2-tests.c: In function 'onfault_check':
mlock2-tests.c:398: warning: integer constant is too large for 'long' type
mlock2-tests.c:398: warning: integer constant is too large for 'long' type
mlock2-tests.c:408: warning: integer constant is too large for 'long' type
mlock2-tests.c:411: warning: integer constant is too large for 'long' type
mlock2-tests.c:416: warning: integer constant is too large for 'long' type
mlock2-tests.c: In function 'unlock_onfault_check':
mlock2-tests.c:443: warning: integer constant is too large for 'long' type
mlock2-tests.c: In function 'test_lock_onfault_of_present':
mlock2-tests.c:528: warning: integer constant is too large for 'long' type
mlock2-tests.c:529: warning: integer constant is too large for 'long' type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftests-mlock2-add-ull-prefix-to-64-bit-constants tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftests-mlock2-add-ull-prefix-to-64-bit-constants
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -277,8 +277,8 @@ out:
 	return ret;
 }
 
-#define PRESENT_BIT     0x8000000000000000
-#define PFN_MASK        0x007FFFFFFFFFFFFF
+#define PRESENT_BIT     0x8000000000000000ULL
+#define PFN_MASK        0x007FFFFFFFFFFFFFULL
 #define UNEVICTABLE_BIT (1UL << 18)
 
 static int lock_check(char *map)
_

Patches currently in -mm which might be from geert@linux-m68k.org are


