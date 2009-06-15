From: akpm@linux-foundation.org
Subject: [merged] kbuild-fix-a-compile-warning.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:37 -0700
Message-ID: <200906151901.n5FJ1bM9023011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758703AbZFOTB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: fix a compile warning
has been removed from the -mm tree.  Its filename was
     kbuild-fix-a-compile-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: fix a compile warning
From: Amerigo Wang <amwang@redhat.com>

gcc-4.4.1:

 HOSTCC  scripts/basic/fixdep
scripts/basic/fixdep.c: In function 'traps':
scripts/basic/fixdep.c:377: warning: dereferencing type-punned pointer will break strict-aliasing rules
scripts/basic/fixdep.c:379: warning: dereferencing type-punned pointer will break strict-aliasing rules

(Apparently -fno-strict-aliasing will fix this too)

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

origin.patch
uml-fix-a-section-warning.patch
uml-bad-macro-expansion-parameter-is-member.patch
proc-merge-arrayc-into-basec.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch

