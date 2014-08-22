From: akpm@linux-foundation.org
Subject: + build-trivia-scripts-headers_installsh.patch added to -mm tree
Date: Fri, 22 Aug 2014 15:30:44 -0700
Message-ID: <53f7c494.wENTs/JYU6YJ230u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:64812 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaHVWaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Aug 2014 18:30:46 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1332115vcb.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2014 15:30:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.barrio.mart@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/headers_install.sh: fix error handling
has been added to the -mm tree.  Its filename is
     build-trivia-scripts-headers_installsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/build-trivia-scripts-headers_installsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/build-trivia-scripts-headers_installsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javier Barrio <javier.barrio.mart@gmail.com>
Subject: scripts/headers_install.sh: fix error handling

- headers_install requires at least two arguments

- missed closing quote

Signed-off-by: Javier Barrio <javier.barrio.mart@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_install.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/headers_install.sh~build-trivia-scripts-headers_installsh scripts/headers_install.sh
--- a/scripts/headers_install.sh~build-trivia-scripts-headers_installsh
+++ a/scripts/headers_install.sh
@@ -1,8 +1,8 @@
 #!/bin/sh
 
-if [ $# -lt 1 ]
+if [ $# -lt 2 ]
 then
-	echo "Usage: headers_install.sh OUTDIR SRCDIR [FILES...]
+	echo "Usage: headers_install.sh OUTDIR SRCDIR [FILES...]"
 	echo
 	echo "Prepares kernel header files for use by user space, by removing"
 	echo "all compiler.h definitions and #includes, removing any"
_

Patches currently in -mm which might be from javier.barrio.mart@gmail.com are

build-trivia-scripts-headers_installsh.patch

