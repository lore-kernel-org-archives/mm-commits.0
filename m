From: akpm@linux-foundation.org
Subject: + tools-lib-subcmd-do-not-alias-select-params.patch added to -mm
 tree
Date: Tue, 02 Jan 2018 15:36:51 -0800
Message-ID: <5a4c1793.DQ79zw07jQvNzLUn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbeABXgw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 18:36:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, acme@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/lib/subcmd/pager.c: do not alias select() params
has been added to the -mm tree.  Its filename is
     tools-lib-subcmd-do-not-alias-select-params.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-lib-subcmd-do-not-alias-select-params.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-lib-subcmd-do-not-alias-select-params.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: tools/lib/subcmd/pager.c: do not alias select() params

Use a separate fd set for select()-s exception fds param to fix the
following gcc warning:

pager.c:36:12: error: passing argument 2 to restrict-qualified
               parameter aliases with argument 4 [-Werror=restrict]
  select(1, &in, NULL, &in, NULL);
            ^~~        ~~~

Link: http://lkml.kernel.org/r/20180101105626.7168-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/lib/subcmd/pager.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN tools/lib/subcmd/pager.c~tools-lib-subcmd-do-not-alias-select-params tools/lib/subcmd/pager.c
--- a/tools/lib/subcmd/pager.c~tools-lib-subcmd-do-not-alias-select-params
+++ a/tools/lib/subcmd/pager.c
@@ -30,10 +30,13 @@ static void pager_preexec(void)
 	 * have real input
 	 */
 	fd_set in;
+	fd_set exception;
 
 	FD_ZERO(&in);
+	FD_ZERO(&exception);
 	FD_SET(0, &in);
-	select(1, &in, NULL, &in, NULL);
+	FD_SET(0, &exception);
+	select(1, &in, NULL, &exception, NULL);
 
 	setenv("LESS", "FRSX", 0);
 }
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

tools-lib-subcmd-do-not-alias-select-params.patch

