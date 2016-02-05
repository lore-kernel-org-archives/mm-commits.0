From: akpm@linux-foundation.org
Subject: [to-be-updated]
 lib-update-single-char-callers-of-strtobool-fix.patch removed from -mm tree
Date: Fri, 05 Feb 2016 15:00:07 -0800
Message-ID: <56b52977.UthxXjHJEllwFOZa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbcBEXAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 18:00:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, andy.shevchenko@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-update-single-char-callers-of-strtobool fix
has been removed from the -mm tree.  Its filename was
     lib-update-single-char-callers-of-strtobool-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib-update-single-char-callers-of-strtobool fix

Drop needless buffer usage.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifs_debug.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/cifs/cifs_debug.c~lib-update-single-char-callers-of-strtobool-fix fs/cifs/cifs_debug.c
--- a/fs/cifs/cifs_debug.c~lib-update-single-char-callers-of-strtobool-fix
+++ a/fs/cifs/cifs_debug.c
@@ -596,7 +596,6 @@ static ssize_t cifs_security_flags_proc_
 	int rc;
 	unsigned int flags;
 	char flags_string[12];
-	char c[2] = { '\0' };
 	bool bv;
 
 	if ((count < 1) || (count > 11))
@@ -609,11 +608,10 @@ static ssize_t cifs_security_flags_proc_
 
 	if (count < 3) {
 		/* single char or single char followed by null */
-		c[0] = flags_string[0];
-		if (strtobool(c, &bv) == 0) {
+		if (strtobool(flags_string, &bv) == 0) {
 			global_secflags = bv ? CIFSSEC_MAX : CIFSSEC_DEF;
 			return count;
-		} else if (!isdigit(c[0])) {
+		} else if (!isdigit(flags_string[0])) {
 			cifs_dbg(VFS, "Invalid SecurityFlags: %s\n",
 					flags_string);
 			return -EINVAL;
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-add-on-off-support-to-kstrtobool.patch
lib-add-on-off-support-to-kstrtobool-fix.patch
param-convert-some-on-off-users-to-strtobool.patch

