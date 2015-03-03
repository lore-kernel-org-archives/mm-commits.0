From: akpm@linux-foundation.org
Subject: + kdb-fix-handling-of-kallsyms_symbol_next-return-value.patch
 added to -mm tree
Date: Mon, 02 Mar 2015 16:20:04 -0800
Message-ID: <54f4fe34.GpWBdvDH94m8Kdcv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbCCAUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:20:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, dan.carpenter@oracle.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdb: fix handling of kallsyms_symbol_next() return value
has been added to the -mm tree.  Its filename is
     kdb-fix-handling-of-kallsyms_symbol_next-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kdb-fix-handling-of-kallsyms_symbol_next-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kdb-fix-handling-of-kallsyms_symbol_next-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: kdb: fix handling of kallsyms_symbol_next() return value

kallsyms_symbol_next() returns a boolean (true on success). Currently
kdb_read() tests the return value with an inequality that
unconditionally evaluates to true.

This is fixed in the obvious way and, since the conditional branch is
supposed to be unreachable, we also add a WARN_ON().

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/kdb/kdb_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/debug/kdb/kdb_io.c~kdb-fix-handling-of-kallsyms_symbol_next-return-value kernel/debug/kdb/kdb_io.c
--- a/kernel/debug/kdb/kdb_io.c~kdb-fix-handling-of-kallsyms_symbol_next-return-value
+++ a/kernel/debug/kdb/kdb_io.c
@@ -349,7 +349,7 @@ poll_again:
 			}
 			kdb_printf("\n");
 			for (i = 0; i < count; i++) {
-				if (kallsyms_symbol_next(p_tmp, i) < 0)
+				if (WARN_ON(!kallsyms_symbol_next(p_tmp, i)))
 					break;
 				kdb_printf("%s ", p_tmp);
 				*(p_tmp + len) = '\0';
_

Patches currently in -mm which might be from daniel.thompson@linaro.org are

kdb-fix-handling-of-kallsyms_symbol_next-return-value.patch
linux-next.patch

