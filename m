From: akpm@linux-foundation.org
Subject: + ima-use-%pu-to-output-uuid-in-printable-format.patch added to
 -mm tree
Date: Tue, 05 Apr 2016 15:16:57 -0700
Message-ID: <57043959.x0RYUeLubhgWyjvl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbcDEWQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 18:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, axboe@kernel.dk, dmitry.kasatkin@gmail.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: security/integrity/ima/ima_policy.c: use %pU to output UUID in printable format
has been added to the -mm tree.  Its filename is
     ima-use-%pu-to-output-uuid-in-printable-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-use-%25pu-to-output-uuid-in-printable-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-use-%25pu-to-output-uuid-in-printable-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: security/integrity/ima/ima_policy.c: use %pU to output UUID in printable format

Instead of open coded variant re-use extension that vsprintf.c provides us
for ages.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_policy.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN security/integrity/ima/ima_policy.c~ima-use-%pu-to-output-uuid-in-printable-format security/integrity/ima/ima_policy.c
--- a/security/integrity/ima/ima_policy.c~ima-use-%pu-to-output-uuid-in-printable-format
+++ a/security/integrity/ima/ima_policy.c
@@ -972,7 +972,7 @@ static void policy_func_show(struct seq_
 int ima_policy_show(struct seq_file *m, void *v)
 {
 	struct ima_rule_entry *entry = v;
-	int i = 0;
+	int i;
 	char tbuf[64] = {0,};
 
 	rcu_read_lock();
@@ -1012,17 +1012,7 @@ int ima_policy_show(struct seq_file *m,
 	}
 
 	if (entry->flags & IMA_FSUUID) {
-		seq_puts(m, "fsuuid=");
-		for (i = 0; i < ARRAY_SIZE(entry->fsuuid); ++i) {
-			switch (i) {
-			case 4:
-			case 6:
-			case 8:
-			case 10:
-				seq_puts(m, "-");
-			}
-			seq_printf(m, "%x", entry->fsuuid[i]);
-		}
+		seq_printf(m, "fsuuid=%pU", entry->fsuuid);
 		seq_puts(m, " ");
 	}
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-vsprintf-simplify-uuid-printing.patch
ima-use-%pu-to-output-uuid-in-printable-format.patch
lib-uuid-move-generate_random_uuid-to-uuidc.patch
lib-uuid-introduce-few-more-generic-helpers-for-uuid.patch
lib-uuid-remove-fsf-address.patch
sysctl-use-generic-uuid-library.patch
efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch
genhd-move-to-use-generic-uuid-library.patch

