From: akpm@linux-foundation.org
Subject: + simple_strto-annotate-function-as-obsolete.patch added to -mm tree
Date: Mon, 01 Oct 2012 15:15:33 -0700
Message-ID: <20121001221533.79BA71E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51961 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2JAWPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 18:15:34 -0400
Received: by vbis24 with SMTP id s24so713972vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 15:15:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eldad@fogrefinery.com, adobriyan@gmail.com, bfields@fieldses.org, joe@perches.com, rdunlap@xenotime.net, rob@landley.net


The patch titled
     Subject: simple_strto*: annotate function as obsolete
has been added to the -mm tree.  Its filename is
     simple_strto-annotate-function-as-obsolete.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eldad Zack <eldad@fogrefinery.com>
Subject: simple_strto*: annotate function as obsolete

Update the documentation for simple_strto* to reflect that it has been
obsoleted and advise the usage of kstrto*.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN lib/vsprintf.c~simple_strto-annotate-function-as-obsolete lib/vsprintf.c
--- a/lib/vsprintf.c~simple_strto-annotate-function-as-obsolete
+++ a/lib/vsprintf.c
@@ -38,6 +38,8 @@
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoull instead.
  */
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
@@ -61,6 +63,8 @@ EXPORT_SYMBOL(simple_strtoull);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoul instead.
  */
 unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
@@ -73,6 +77,8 @@ EXPORT_SYMBOL(simple_strtoul);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtol instead.
  */
 long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
@@ -88,6 +94,8 @@ EXPORT_SYMBOL(simple_strtol);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoll instead.
  */
 long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
_

Patches currently in -mm which might be from eldad@fogrefinery.com are

kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

