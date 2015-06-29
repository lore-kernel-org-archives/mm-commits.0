From: akpm@linux-foundation.org
Subject: [merged]
 coredump-add-__printf-attribute-to-cn_printf-functions.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:49:21 -0700
Message-ID: <5591af51.eRty9j1+odlt9y49%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbbF2UtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: add __printf attribute to cn_*printf functions
has been removed from the -mm tree.  Its filename was
     coredump-add-__printf-attribute-to-cn_printf-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

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
@@ -225,7 +227,8 @@ static int format_corename(struct core_n
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				err = cn_printf(cn, "%ld", cprm->siginfo->si_signo);
+				err = cn_printf(cn, "%d",
+						cprm->siginfo->si_signo);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

origin.patch
linux-next.patch

