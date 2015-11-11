From: akpm@linux-foundation.org
Subject: [merged] selftests-mlock2-add-missing-define-_gnu_source.patch
 removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:04 -0800
Message-ID: <56439b74.0w9i8N6sKjJDLdly%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbbKKTsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, emunson@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mlock2: add missing #define _GNU_SOURCE
has been removed from the -mm tree.  Its filename was
     selftests-mlock2-add-missing-define-_gnu_source.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


