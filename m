From: akpm@linux-foundation.org
Subject: + vsprintf-bug-on-%n.patch added to -mm tree
Date: Mon, 27 Jan 2014 15:10:45 -0800
Message-ID: <52e6e775.9StRb6a9FXD0P/pN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaA0XKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 18:10:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org

Subject: + vsprintf-bug-on-%n.patch added to -mm tree
To: keescook@chromium.org
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 15:10:45 -0800


The patch titled
     Subject: vsprintf: BUG on %n
has been added to the -mm tree.  Its filename is
     vsprintf-bug-on-%n.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vsprintf-bug-on-%n.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vsprintf-bug-on-%n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
