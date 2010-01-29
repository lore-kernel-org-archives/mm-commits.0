From: akpm@linux-foundation.org
Subject: [merged] scripts-kallsyms-suppress-build-warning.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:16:41 -0800
Message-ID: <201001292016.o0TKGffo003255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980Ab0A2URT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hschauhan@nulltrace.org, mmarek@suse.cz, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scripts/kallsyms: suppress build warning
has been removed from the -mm tree.  Its filename was
     scripts-kallsyms-suppress-build-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/kallsyms: suppress build warning
From: Himanshu Chauhan <hschauhan@nulltrace.org>

Suppress a warn_unused_result warning.

fgets is called as a part of error handling.  It is called just to drop a
line and return immediately.  read_map is reading the file in a loop and
read_symbol reads line by line.  So I think there is no point in using
return value for useful checking.  Other checks like 3 items were returned
or !EOF have already been done.

Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/kallsyms.c~scripts-kallsyms-suppress-build-warning scripts/kallsyms.c
--- a/scripts/kallsyms.c~scripts-kallsyms-suppress-build-warning
+++ a/scripts/kallsyms.c
@@ -108,8 +108,10 @@ static int read_symbol(FILE *in, struct 
 	rc = fscanf(in, "%llx %c %499s\n", &s->addr, &stype, str);
 	if (rc != 3) {
 		if (rc != EOF) {
-			/* skip line */
-			fgets(str, 500, in);
+			/* skip line. sym is used as dummy to
+			 * shut of "warn_unused_result" warning.
+			 */
+			sym = fgets(str, 500, in);
 		}
 		return -1;
 	}
_

Patches currently in -mm which might be from hschauhan@nulltrace.org are

linux-next.patch

