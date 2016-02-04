From: akpm@linux-foundation.org
Subject: + lib-update-single-char-callers-of-strtobool-fix.patch added to
 -mm tree
Date: Thu, 04 Feb 2016 15:15:00 -0800
Message-ID: <56b3db74.Z/UkZudEfHxfSr6I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbcBDXPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:15:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, andy.shevchenko@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-update-single-char-callers-of-strtobool fix
has been added to the -mm tree.  Its filename is
     lib-update-single-char-callers-of-strtobool-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-update-single-char-callers-of-strtobool-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-update-single-char-callers-of-strtobool-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-move-strtobool-to-kstrtobool.patch
lib-update-single-char-callers-of-strtobool.patch
lib-update-single-char-callers-of-strtobool-fix.patch
lib-add-on-off-support-to-kstrtobool.patch
param-convert-some-on-off-users-to-strtobool.patch

