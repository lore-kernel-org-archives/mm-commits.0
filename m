From: akpm@linux-foundation.org
Subject: + selftests-mlock2-add-missing-define-_gnu_source.patch added to
 -mm tree
Date: Mon, 09 Nov 2015 13:05:23 -0800
Message-ID: <56410a93.vmNwwZpNJSaIjlWs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbKIVFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:05:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, emunson@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mlock2: add missing #define _GNU_SOURCE
has been added to the -mm tree.  Its filename is
     selftests-mlock2-add-missing-define-_gnu_source.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-mlock2-add-missing-define-_gnu_source.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-mlock2-add-missing-define-_gnu_source.patch

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
Subject: selftests/mlock2: add missing #define _GNU_SOURCE

On glibc 2.3.6:

    mlock2-tests.c: In function 'seek_to_smaps_entry':
    mlock2-tests.c:158: warning: implicit declaration of function 'getline'

According to the manpage of getline(), it needs _GNU_SOURCE before glibc
2.10.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftests-mlock2-add-missing-define-_gnu_source tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftests-mlock2-add-missing-define-_gnu_source
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -1,3 +1,4 @@
+#define _GNU_SOURCE
 #include <sys/mman.h>
 #include <stdint.h>
 #include <stdio.h>
_

Patches currently in -mm which might be from geert@linux-m68k.org are

selftests-mlock2-add-missing-define-_gnu_source.patch
selftests-mlock2-add-ull-prefix-to-64-bit-constants.patch

