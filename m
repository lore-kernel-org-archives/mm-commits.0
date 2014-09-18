From: akpm@linux-foundation.org
Subject: + altera-stapl-replace-strnicmp-with-strncasecmp.patch added to
 -mm tree
Date: Thu, 18 Sep 2014 14:36:20 -0700
Message-ID: <541b5054.83/0h25Sy83IrNMh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbaIRVgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, liplianin@netup.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: altera-stapl: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     altera-stapl-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/altera-stapl-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/altera-stapl-replace-strnicmp-with-strncasecmp.patch

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
Subject: altera-stapl: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Igor M. Liplianin" <liplianin@netup.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/altera-stapl/altera.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/altera-stapl/altera.c~altera-stapl-replace-strnicmp-with-strncasecmp drivers/misc/altera-stapl/altera.c
--- a/drivers/misc/altera-stapl/altera.c~altera-stapl-replace-strnicmp-with-strncasecmp
+++ a/drivers/misc/altera-stapl/altera.c
@@ -454,7 +454,7 @@ exit_done:
 
 				name = &p[str_table + name_id];
 
-				if (strnicmp(aconf->action, name, strlen(name)) == 0) {
+				if (strncasecmp(aconf->action, name, strlen(name)) == 0) {
 					action_found = 1;
 					current_proc =
 						get_unaligned_be32(&p[action_table +
@@ -2176,7 +2176,7 @@ static int altera_get_note(u8 *p, s32 pr
 			key_ptr = &p[note_strings +
 					get_unaligned_be32(
 					&p[note_table + (8 * i)])];
-			if ((strnicmp(key, key_ptr, strlen(key_ptr)) == 0) &&
+			if ((strncasecmp(key, key_ptr, strlen(key_ptr)) == 0) &&
 						(key != NULL)) {
 				status = 0;
 
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

