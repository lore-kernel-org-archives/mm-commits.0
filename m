From: akpm@linux-foundation.org
Subject: [merged]
 sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv.patch
 removed from -mm tree
Date: Wed, 04 Oct 2017 12:41:37 -0700
Message-ID: <20171004194137.W0ASNrPvH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33666 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTli (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcb314@hotmail.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: remove duplicate UINT_MAX check on do_proc_douintvec_conv()
has been removed from the -mm tree.  Its filename was
     sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kernel/sysctl.c: remove duplicate UINT_MAX check on do_proc_douintvec_conv()

do_proc_douintvec_conv() has two UINT_MAX checks, we can remove one.  This
has no functional changes other than fixing a compiler warning:

kernel/sysctl.c:2190]: (warning) Identical condition '*lvalp>UINT_MAX', second condition is always false

Fixes: 4f2fec00afa60 ("sysctl: simplify unsigned int support")
Link: http://lkml.kernel.org/r/20170919072918.12066-1-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reported-by: David Binderman <dcb314@hotmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/sysctl.c~sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-duplicate-uint_max-check-on-do_proc_douintvec_conv
+++ a/kernel/sysctl.c
@@ -2188,8 +2188,6 @@ static int do_proc_douintvec_conv(unsign
 	if (write) {
 		if (*lvalp > UINT_MAX)
 			return -EINVAL;
-		if (*lvalp > UINT_MAX)
-			return -EINVAL;
 		*valp = *lvalp;
 	} else {
 		unsigned int val = *valp;
_

Patches currently in -mm which might be from mcgrof@kernel.org are


