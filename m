From: akpm@linux-foundation.org
Subject: + printk-fix-parsing-of-brl=-option.patch added to -mm tree
Date: Tue, 23 Aug 2016 13:43:47 -0700
Message-ID: <57bcb583.VJATpVgeXJUwr4tf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbcHWUns (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Aug 2016 16:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix parsing of "brl=" option
has been added to the -mm tree.  Its filename is
     printk-fix-parsing-of-brl=-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-fix-parsing-of-brl%3D-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-fix-parsing-of-brl%3D-option.patch

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
Subject: printk: fix parsing of "brl=" option

Commit bbeddf52adc1 ("printk: move braille console support into separate
braille.[ch] files") moved the parsing of braille-related options into
_braille_console_setup(), changing the type of variable str from char* to
char**.  In this commit, memcmp(str, "brl,", 4) was correctly updated to
memcmp(*str, "brl,", 4) but not memcmp(str, "brl=", 4).

Update the code to make "brl=" option work again and replace memcmp() with
strncmp() to make the compiler able to detect such an issue.

Fixes: bbeddf52adc1 ("printk: move braille console support into separate braille.[ch] files")
Link: http://lkml.kernel.org/r/20160823165700.28952-1-nicolas.iooss_linux@m4x.org
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/braille.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk/braille.c~printk-fix-parsing-of-brl=-option kernel/printk/braille.c
--- a/kernel/printk/braille.c~printk-fix-parsing-of-brl=-option
+++ a/kernel/printk/braille.c
@@ -9,10 +9,10 @@
 
 char *_braille_console_setup(char **str, char **brl_options)
 {
-	if (!memcmp(*str, "brl,", 4)) {
+	if (!strncmp(*str, "brl,", 4)) {
 		*brl_options = "";
 		*str += 4;
-	} else if (!memcmp(str, "brl=", 4)) {
+	} else if (!strncmp(*str, "brl=", 4)) {
 		*brl_options = *str + 4;
 		*str = strchr(*brl_options, ',');
 		if (!*str)
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

printk-fix-parsing-of-brl=-option.patch

