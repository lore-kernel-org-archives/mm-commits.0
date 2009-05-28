From: akpm@linux-foundation.org
Subject: + kbuild-fix-a-compile-warning.patch added to -mm tree
Date: Thu, 28 May 2009 00:41:04 -0700
Message-ID: <200905280741.n4S7f4Vw022723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760536AbZE1Hlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 03:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, sam@ravnborg.org


The patch titled
     kbuild: fix a compile warning
has been added to the -mm tree.  Its filename is
     kbuild-fix-a-compile-warning.patch

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
Subject: kbuild: fix a compile warning
From: Amerigo Wang <amwang@redhat.com>

 HOSTCC  scripts/basic/fixdep
scripts/basic/fixdep.c: In function 'traps':
scripts/basic/fixdep.c:377: warning: dereferencing type-punned pointer will break strict-aliasing rules
scripts/basic/fixdep.c:379: warning: dereferencing type-punned pointer will break strict-aliasing rules

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/fixdep.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/basic/fixdep.c~kbuild-fix-a-compile-warning scripts/basic/fixdep.c
--- a/scripts/basic/fixdep.c~kbuild-fix-a-compile-warning
+++ a/scripts/basic/fixdep.c
@@ -373,10 +373,11 @@ void print_deps(void)
 void traps(void)
 {
 	static char test[] __attribute__((aligned(sizeof(int)))) = "CONF";
+	int *p = (int *)test;
 
-	if (*(int *)test != INT_CONF) {
+	if (*p != INT_CONF) {
 		fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianess? %#x\n",
-			*(int *)test);
+			*p);
 		exit(2);
 	}
 }
_

Patches currently in -mm which might be from amwang@redhat.com are

kbuild-fix-a-compile-warning.patch
uml-fix-a-section-warning.patch
uml-bad-macro-expansion-parameter-is-member.patch
proc-merge-arrayc-into-basec.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch

