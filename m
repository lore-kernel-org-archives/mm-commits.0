From: akpm@linux-foundation.org
Subject: [merged] checkpatchpl-add-union-and-struct-to-the-exceptions-list.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:11 -0800
Message-ID: <201003091909.o29J9BrH031503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756037Ab0CITW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch.pl: add union and struct to the exceptions list
has been removed from the -mm tree.  Its filename was
     checkpatchpl-add-union-and-struct-to-the-exceptions-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch.pl: add union and struct to the exceptions list
From: Stefani Seibold <stefani@seibold.net>

Here is a small code snippet, which will be complained about by
checkpatch.pl:

#define __STRUCT_KFIFO_COMMON(recsize, ptrtype) \
	union { \
		struct { \
			unsigned int	in; \
			unsigned int	out; \
		}; \
		char		rectype[recsize]; \
		ptrtype		*ptr; \
		const ptrtype	*ptr_const; \
	};

This construct is legal and safe, so checkpatch.pl should accept this.  It
should be also true for struct defined in a macro.

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

drivers-media-video-cx23885-needs-kfifo-conversion.patch

