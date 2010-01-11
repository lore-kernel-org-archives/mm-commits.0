From: akpm@linux-foundation.org
Subject: + checkpatchpl-add-union-and-struct-to-the-exceptions-list.patch added to -mm tree
Date: Mon, 11 Jan 2010 14:42:47 -0800
Message-ID: <201001112242.o0BMgl8v000363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558Ab0AKWnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 17:43:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, apw@shadowen.org


The patch titled
     checkpatch.pl: add union and struct to the exceptions list
has been added to the -mm tree.  Its filename is
     checkpatchpl-add-union-and-struct-to-the-exceptions-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch.pl: add union and struct to the exceptions list
From: Stefani Seibold <stefani@seibold.net>

Add the `struct' and `union' keywords to the exceptions list of the
checkpatch.pl script, to prevent error message "Macros with multiple
statements should be enclosed in a do - while loop".  Otherwise it is not
possible to build a struct or union with a macro.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-add-union-and-struct-to-the-exceptions-list scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-add-union-and-struct-to-the-exceptions-list
+++ a/scripts/checkpatch.pl
@@ -2361,6 +2361,8 @@ sub process {
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
 				__typeof__\(|
+				union|
+				struct|
 				\.$Ident\s*=\s*|
 				^\"|\"$
 			}x;
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
kfifo-fix-kfifo_out_locked-race-bug.patch
kfifo-use-void-pointers-for-user-buffers.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
linux-next.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
checkpatchpl-add-union-and-struct-to-the-exceptions-list.patch

