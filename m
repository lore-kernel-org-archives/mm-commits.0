From: akpm@linux-foundation.org
Subject: + coredump-add-__printf-attribute-to-cn_printf-functions.patch
 added to -mm tree
Date: Mon, 04 May 2015 15:41:02 -0700
Message-ID: <5547f57e.A7YJJHf2aWvlxr7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbEDWlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 18:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, ebiederm@xmission.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: add __printf attribute to cn_*printf functions
has been added to the -mm tree.  Its filename is
     coredump-add-__printf-attribute-to-cn_printf-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-add-__printf-attribute-to-cn_printf-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-add-__printf-attribute-to-cn_printf-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: coredump: add __printf attribute to cn_*printf functions

This allows detecting improper format string at build time, like:

  fs/coredump.c:225:5: warning: format '%ld' expects argument of type
  'long int', but argument 3 has type 'int' [-Wformat=]
       err = cn_printf(cn, "%ld", cprm->siginfo->si_signo);
       ^

As si_signo is always an int, the format should be %d here.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/coredump.c~coredump-add-__printf-attribute-to-cn_printf-functions fs/coredump.c
--- a/fs/coredump.c~coredump-add-__printf-attribute-to-cn_printf-functions
+++ a/fs/coredump.c
@@ -70,7 +70,8 @@ static int expand_corename(struct core_n
 	return 0;
 }
 
-static int cn_vprintf(struct core_name *cn, const char *fmt, va_list arg)
+static __printf(2, 0) int cn_vprintf(struct core_name *cn, const char *fmt,
+				     va_list arg)
 {
 	int free, need;
 	va_list arg_copy;
@@ -93,7 +94,7 @@ again:
 	return -ENOMEM;
 }
 
-static int cn_printf(struct core_name *cn, const char *fmt, ...)
+static __printf(2, 3) int cn_printf(struct core_name *cn, const char *fmt, ...)
 {
 	va_list arg;
 	int ret;
@@ -105,7 +106,8 @@ static int cn_printf(struct core_name *c
 	return ret;
 }
 
-static int cn_esc_printf(struct core_name *cn, const char *fmt, ...)
+static __printf(2, 3)
+int cn_esc_printf(struct core_name *cn, const char *fmt, ...)
 {
 	int cur = cn->used;
 	va_list arg;
@@ -225,7 +227,7 @@ static int format_corename(struct core_n
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				err = cn_printf(cn, "%ld", cprm->siginfo->si_signo);
+				err = cn_printf(cn, "%d", cprm->siginfo->si_signo);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

coredump-use-from_kuid-kgid_munged-when-formatting-corename.patch
coredump-add-__printf-attribute-to-cn_printf-functions.patch
linux-next.patch

