From: akpm@linux-foundation.org
Subject: [patch 032/114] tools/lib/subcmd/pager.c: do not alias
 select() params
Date: Tue, 06 Feb 2018 15:37:52 -0800
Message-ID: <20180206233752.5wIkYaGds%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXhx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

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
