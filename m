From: akpm@linux-foundation.org
Subject: + lib-add-on-off-support-to-kstrtobool-fix.patch added to -mm
 tree
Date: Thu, 04 Feb 2016 15:45:00 -0800
Message-ID: <56b3e27c.c6Q+ALvFsqq5ESeF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbcBDXpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, andy.shevchenko@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-add-on-off-support-to-kstrtobool fix
has been added to the -mm tree.  Its filename is
     lib-add-on-off-support-to-kstrtobool-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-on-off-support-to-kstrtobool-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-on-off-support-to-kstrtobool-fix.patch

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
Subject: lib-add-on-off-support-to-kstrtobool fix

Accidentally dropped description update when shuffling strtobool around.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/kstrtox.c~lib-add-on-off-support-to-kstrtobool-fix lib/kstrtox.c
--- a/lib/kstrtox.c~lib-add-on-off-support-to-kstrtobool-fix
+++ a/lib/kstrtox.c
@@ -327,9 +327,9 @@ EXPORT_SYMBOL(kstrtos8);
  * @base: ignored
  * @res: result
  *
- * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
- * Otherwise it will return -EINVAL.  Value pointed to by res is
- * updated upon finding a match.
+ * This routine returns 0 iff the first character is one of 'Yy1Nn0', or
+ * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
+ * pointed to by res is updated upon finding a match.
  */
 int kstrtobool(const char *s, unsigned int base, bool *res)
 {
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-move-strtobool-to-kstrtobool.patch
lib-update-single-char-callers-of-strtobool.patch
lib-update-single-char-callers-of-strtobool-fix.patch
lib-add-on-off-support-to-kstrtobool.patch
lib-add-on-off-support-to-kstrtobool-fix.patch
param-convert-some-on-off-users-to-strtobool.patch

