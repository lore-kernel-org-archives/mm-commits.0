From: akpm@linux-foundation.org
Subject: + printk-improve-the-description-of-dev-kmsg-line-format.patch
 added to -mm tree
Date: Thu, 30 Apr 2015 14:32:48 -0700
Message-ID: <55429f80.rQJhaaMUM+7XoZ9N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbbD3Vct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Apr 2015 17:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ao2@ao2.it, corbet@lwn.net, joe@perches.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: improve the description of /dev/kmsg line format
has been added to the -mm tree.  Its filename is
     printk-improve-the-description-of-dev-kmsg-line-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-improve-the-description-of-dev-kmsg-line-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-improve-the-description-of-dev-kmsg-line-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Antonio Ospite <ao2@ao2.it>
Subject: printk: improve the description of /dev/kmsg line format

The comment about /dev/kmsg does not mention the additional values which
may actually be exported, fix that.

Also move up the part of the comment instructing the users to ignore these
additional values, this way the reading is more fluent and logically
compact.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/printk/printk.c~printk-improve-the-description-of-dev-kmsg-line-format kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-improve-the-description-of-dev-kmsg-line-format
+++ a/kernel/printk/printk.c
@@ -195,14 +195,14 @@ static int console_may_schedule;
  * need to be changed in the future, when the requirements change.
  *
  * /dev/kmsg exports the structured data in the following line format:
- *   "level,sequnum,timestamp;<message text>\n"
+ *   "level,sequnum,timestamp[,additional_values, ... ];<message text>\n"
+ *
+ * Users of the export format should ignore possible additional values
+ * separated by ',', and find the message after the ';' character.
  *
  * The optional key/value pairs are attached as continuation lines starting
  * with a space character and terminated by a newline. All possible
  * non-prinatable characters are escaped in the "\xff" notation.
- *
- * Users of the export format should ignore possible additional values
- * separated by ',', and find the message after the ';' character.
  */
 
 enum log_flags {
_

Patches currently in -mm which might be from ao2@ao2.it are

linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

