From: akpm@linux-foundation.org
Subject: [patch 36/51] kernel/sysctl.c: remove duplicate UINT_MAX check on do_proc_douintvec_conv()
Date: Tue, 03 Oct 2017 16:16:07 -0700
Message-ID: <59d41a37.ZZBLdSMtQa5emmAM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org, dcb314@hotmail.com, keescook@chromium.org

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
