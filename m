From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 15/54] kernel/sysctl.c: ignore out-of-range taint
 bits introduced via kernel.tainted
Date: Sun, 07 Jun 2020 21:40:51 -0700
Message-ID: <20200608044051.A6fYnLhbQ%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEkx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:40:53 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, keescook@chromium.org, linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, tytso@mit.edu, yzaikin@google.com

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
