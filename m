From: akpm@linux-foundation.org
Subject: [merged]
 kdb-fix-handling-of-kallsyms_symbol_next-return-value.patch removed from
 -mm tree
Date: Wed, 04 Mar 2015 15:14:25 -0800
Message-ID: <54f791d1.VFRDRPh4ap/g30pL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbbCDXO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 18:14:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, dan.carpenter@oracle.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdb: fix handling of kallsyms_symbol_next() return value
has been removed from the -mm tree.  Its filename was
     kdb-fix-handling-of-kallsyms_symbol_next-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

