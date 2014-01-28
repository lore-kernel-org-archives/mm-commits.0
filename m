From: akpm@linux-foundation.org
Subject: [alternative-merged] vsprintf-bug-on-%n.patch removed from -mm
 tree
Date: Tue, 28 Jan 2014 12:05:37 -0800
Message-ID: <52e80d91.K6LpL7Oi7XLvyzA9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1UFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 15:05:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org

Subject: [alternative-merged] vsprintf-bug-on-%n.patch removed from -mm tree
To: keescook@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 12:05:37 -0800


The patch titled
     Subject: vsprintf: BUG on %n
has been removed from the -mm tree.  Its filename was
     vsprintf-bug-on-%n.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: vsprintf: BUG on %n

Now that there has been a full release of the kernel, and all users of %n
have been dropped, switch to %n use triggering a BUG.  Ignoring arguments
could be used to assist in information leaks if an arbitrary format string
was under the control of an attacker.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-bug-on-%n lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-bug-on-%n
+++ a/lib/vsprintf.c
@@ -1735,15 +1735,12 @@ int vsnprintf(char *buf, size_t size, co
 		case FORMAT_TYPE_NRCHARS: {
 			/*
 			 * Since %n poses a greater security risk than
-			 * utility, ignore %n and skip its argument.
+			 * utility, it should not be implemented. Instead,
+			 * BUG when encountering %n, since there are no
+			 * legitimate users and skipping arguments could
+			 * assist information leak attacks.
 			 */
-			void *skip_arg;
-
-			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
-					old_fmt);
