From: akpm@linux-foundation.org
Subject: [patch 06/12] printk: fix parsing of "brl=" option
Date: Thu, 25 Aug 2016 15:17:00 -0700
Message-ID: <57bf6e5c.1s7ivkc99ZNm1yNr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59251 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932724AbcHYWmQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 18:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, nicolas.iooss_linux@m4x.org, joe@perches.com

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
