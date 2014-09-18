From: akpm@linux-foundation.org
Subject: + kdb-replace-strnicmp-with-strncasecmp.patch added to -mm tree
Date: Thu, 18 Sep 2014 14:36:26 -0700
Message-ID: <541b505a.V9lWEvouYU+XkwcM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbaIRVg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdb: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     kdb-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kdb-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kdb-replace-strnicmp-with-strncasecmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kdb: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/kdb/kdb_bp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/debug/kdb/kdb_bp.c~kdb-replace-strnicmp-with-strncasecmp kernel/debug/kdb/kdb_bp.c
--- a/kernel/debug/kdb/kdb_bp.c~kdb-replace-strnicmp-with-strncasecmp
+++ a/kernel/debug/kdb/kdb_bp.c
@@ -52,11 +52,11 @@ static int kdb_parsebp(int argc, const c
 
 	bp->bph_length = 1;
 	if ((argc + 1) != nextarg) {
-		if (strnicmp(argv[nextarg], "datar", sizeof("datar")) == 0)
+		if (strncasecmp(argv[nextarg], "datar", sizeof("datar")) == 0)
 			bp->bp_type = BP_ACCESS_WATCHPOINT;
-		else if (strnicmp(argv[nextarg], "dataw", sizeof("dataw")) == 0)
+		else if (strncasecmp(argv[nextarg], "dataw", sizeof("dataw")) == 0)
 			bp->bp_type = BP_WRITE_WATCHPOINT;
-		else if (strnicmp(argv[nextarg], "inst", sizeof("inst")) == 0)
+		else if (strncasecmp(argv[nextarg], "inst", sizeof("inst")) == 0)
 			bp->bp_type = BP_HARDWARE_BREAKPOINT;
 		else
 			return KDB_ARGCOUNT;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-next.patch
lib-string-remove-duplicated-function.patch
lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
arm-replace-strnicmp-with-strncasecmp.patch
block-replace-strnicmp-with-strncasecmp.patch
netfilter-replace-strnicmp-with-strncasecmp.patch
video-fbdev-replace-strnicmp-with-strncasecmp.patch
cifs-replace-strnicmp-with-strncasecmp.patch
ocfs2-replace-strnicmp-with-strncasecmp.patch
isofs-replace-strnicmp-with-strncasecmp.patch
batman-adv-replace-strnicmp-with-strncasecmp.patch
acpi-battery-replace-strnicmp-with-strncasecmp.patch
cpufreq-replace-strnicmp-with-strncasecmp.patch
cpuidle-replace-strnicmp-with-strncasecmp.patch
scsi-replace-strnicmp-with-strncasecmp.patch
ib_srpt-replace-strnicmp-with-strncasecmp.patch
input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch
altera-stapl-replace-strnicmp-with-strncasecmp.patch
thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
pnp-replace-strnicmp-with-strncasecmp.patch
s390-cio-replace-strnicmp-with-strncasecmp.patch
staging-r8188eu-replace-strnicmp-with-strncasecmp.patch
thermal-replace-strnicmp-with-strncasecmp.patch
kdb-replace-strnicmp-with-strncasecmp.patch

