From: akpm@linux-foundation.org
Subject: [to-be-updated] vsprintf-ignore-arguments-to-%n.patch removed
 from -mm tree
Date: Tue, 28 Jan 2014 13:30:21 -0800
Message-ID: <52e8216d.0dv4SKhGFacM8zwk%akpm__21849.499239079$1390944633$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaA1VaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 16:30:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, stepanm@codeaurora.org, stable@vger.kernel.org, rmallon@gmail.com, olof@lixom.net, joe@perches.com, jkosina@suse.cz, dborkman@redhat.com, keescook@chromium.org

Subject: [to-be-updated] vsprintf-ignore-arguments-to-%n.patch removed from -mm tree
To: keescook@chromium.org,dborkman@redhat.com,jkosina@suse.cz,joe@perches.com,olof@lixom.net,rmallon@gmail.com,stable@vger.kernel.org,stepanm@codeaurora.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 13:30:21 -0800


The patch titled
     Subject: vsprintf: ignore arguments to %n
has been removed from the -mm tree.  Its filename was
     vsprintf-ignore-arguments-to-%n.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: vsprintf: ignore arguments to %n

If arguments are consumed without output when encountering %n, it could be
used to benefit or improve information leak attacks that were exposed via
a limited size buffer.  Since %n is not used by the kernel, there is no
reason to make an info leak attack any easier.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: <stable@vger.kernel.org>	[3.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-ignore-arguments-to-%n lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-ignore-arguments-to-%n
+++ a/lib/vsprintf.c
@@ -1735,14 +1735,10 @@ int vsnprintf(char *buf, size_t size, co
 		case FORMAT_TYPE_NRCHARS: {
 			/*
 			 * Since %n poses a greater security risk than
-			 * utility, ignore %n and skip its argument.
+			 * utility, it should not be implemented. Instead,
+			 * when encountering %n, ignore the arguments.
 			 */
-			void *skip_arg;
-
-			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
-					old_fmt);
