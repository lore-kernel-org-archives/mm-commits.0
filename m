From: akpm@linux-foundation.org
Subject: + selftests-mlock2-add-ull-prefix-to-64-bit-constants.patch added to -mm tree
Date: Mon, 09 Nov 2015 13:05:25 -0800
Message-ID: <56410a95.t+qO3af+S7iJwEd/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbKIVF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, emunson@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mlock2: add ULL suffix to 64-bit constants
has been added to the -mm tree.  Its filename is
     selftests-mlock2-add-ull-prefix-to-64-bit-constants.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-mlock2-add-ull-prefix-to-64-bit-constants.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-mlock2-add-ull-prefix-to-64-bit-constants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

selftests-mlock2-add-missing-define-_gnu_source.patch
selftests-mlock2-add-ull-prefix-to-64-bit-constants.patch

