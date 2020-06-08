From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via?=
 =?US-ASCII?Q?-kerneltainted.patch?= removed from -mm tree
Date: Mon, 08 Jun 2020 15:32:05 -0700
Message-ID: <20200608223205.PLw48Dy6e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgFHWcG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, tytso@mit.edu, yzaikin@google.com


The patch titled
     Subject: kernel/sysctl.c: ignore out-of-range taint bits introduced via kernel.tainted
has been removed from the -mm tree.  Its filename was
     kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via-kerneltainted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: kernel/sysctl.c: ignore out-of-range taint bits introduced via kernel.tainted

Users with SYS_ADMIN capability can add arbitrary taint flags to the
running kernel by writing to /proc/sys/kernel/tainted or issuing the
command 'sysctl -w kernel.tainted=...'.  This interface, however, is open
for any integer value and this might cause an invalid set of flags being
committed to the tainted_mask bitset.

This patch introduces a simple way for proc_taint() to ignore any eventual
invalid bit coming from the user input before committing those bits to the
kernel tainted_mask.

Link: http://lkml.kernel.org/r/20200512223946.888020-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/sysctl.c~kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via-kerneltainted
+++ a/kernel/sysctl.c
@@ -880,10 +880,9 @@ static int proc_taint(struct ctl_table *
 		 * Poor man's atomic or. Not worth adding a primitive
 		 * to everyone's atomic.h for this
 		 */
-		for (i = 0; i < BITS_PER_LONG && tmptaint >> i; i++) {
-			if ((tmptaint >> i) & 1)
+		for (i = 0; i < TAINT_FLAGS_COUNT; i++)
+			if ((1UL << i) & tmptaint)
 				add_taint(i, LOCKDEP_STILL_OK);
-		}
 	}
 
 	return err;
_

Patches currently in -mm which might be from aquini@redhat.com are
