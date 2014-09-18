From: akpm@linux-foundation.org
Subject: + cifs-replace-strnicmp-with-strncasecmp.patch added to -mm tree
Date: Thu, 18 Sep 2014 14:36:10 -0700
Message-ID: <541b504a.GXHfJ3Yio2z19oZX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235AbaIRVgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cifs: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     cifs-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cifs-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cifs-replace-strnicmp-with-strncasecmp.patch

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
Subject: cifs: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifs_dfs_ref.c |    6 +++---
 fs/cifs/connect.c      |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/cifs/cifs_dfs_ref.c~cifs-replace-strnicmp-with-strncasecmp fs/cifs/cifs_dfs_ref.c
--- a/fs/cifs/cifs_dfs_ref.c~cifs-replace-strnicmp-with-strncasecmp
+++ a/fs/cifs/cifs_dfs_ref.c
@@ -195,15 +195,15 @@ char *cifs_compose_mount_options(const c
 		else
 			noff = tkn_e - (sb_mountdata + off) + 1;
 
-		if (strnicmp(sb_mountdata + off, "unc=", 4) == 0) {
+		if (strncasecmp(sb_mountdata + off, "unc=", 4) == 0) {
 			off += noff;
 			continue;
 		}
-		if (strnicmp(sb_mountdata + off, "ip=", 3) == 0) {
+		if (strncasecmp(sb_mountdata + off, "ip=", 3) == 0) {
 			off += noff;
 			continue;
 		}
-		if (strnicmp(sb_mountdata + off, "prefixpath=", 11) == 0) {
+		if (strncasecmp(sb_mountdata + off, "prefixpath=", 11) == 0) {
 			off += noff;
 			continue;
 		}
diff -puN fs/cifs/connect.c~cifs-replace-strnicmp-with-strncasecmp fs/cifs/connect.c
--- a/fs/cifs/connect.c~cifs-replace-strnicmp-with-strncasecmp
+++ a/fs/cifs/connect.c
@@ -1718,7 +1718,7 @@ cifs_parse_mount_options(const char *mou
 				goto cifs_parse_mount_err;
 			}
 
-			 if (strnicmp(string, "default", 7) != 0) {
+			 if (strncasecmp(string, "default", 7) != 0) {
 				vol->iocharset = kstrdup(string,
 							 GFP_KERNEL);
 				if (!vol->iocharset) {
@@ -1790,7 +1790,7 @@ cifs_parse_mount_options(const char *mou
 			if (string == NULL)
 				goto out_nomem;
 
-			if (strnicmp(string, "1", 1) == 0) {
+			if (strncasecmp(string, "1", 1) == 0) {
 				/* This is the default */
 				break;
 			}
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

