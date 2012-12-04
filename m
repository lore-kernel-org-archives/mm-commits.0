From: akpm@linux-foundation.org
Subject: + cris-use-int-for-ssize_t-to-match-size_t.patch added to -mm tree
Date: Tue, 04 Dec 2012 12:00:09 -0800
Message-ID: <20121204200010.823092000A8@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39235 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2LDUAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 15:00:15 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so143643lbc.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 12:00:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, hans-peter.nilsson@axis.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     Subject: cris: Use "int" for ssize_t to match size_t
has been added to the -mm tree.  Its filename is
     cris-use-int-for-ssize_t-to-match-size_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: cris: Use "int" for ssize_t to match size_t

On cris-linux-gcc, __SIZE_TYPE__ expands to "unsigned int", as
gcc-4.6.3-nolibc/cris-linux/lib/gcc/cris-linux/4.6.3/plugin/include/config/cris/linux.h
has

    #define SIZE_TYPE "unsigned int"

Hence __kernel_size_t is also "unsigned int".  But __kernel_ssize_t is
"long", which has a different base type, causing compiler warnings like:

    fs/quota/quota_tree.c:372:4: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]

To fix this, __kernel_ssize_t should be changed to "int". Hence cris can
just use the generic 32-bit versions from include/asm-generic/posix_types.h
for all size-related types.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/uapi/asm/posix_types.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/cris/include/uapi/asm/posix_types.h~cris-use-int-for-ssize_t-to-match-size_t arch/cris/include/uapi/asm/posix_types.h
--- a/arch/cris/include/uapi/asm/posix_types.h~cris-use-int-for-ssize_t-to-match-size_t
+++ a/arch/cris/include/uapi/asm/posix_types.h
@@ -22,11 +22,6 @@ typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 #define __kernel_uid_t __kernel_uid_t
 
-typedef __SIZE_TYPE__	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-#define __kernel_size_t __kernel_size_t
