From: akpm@linux-foundation.org
Subject: [merged] ima-use-%pu-to-output-uuid-in-printable-format.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:48:46 -0700
Message-ID: <57435e9e.tyJ05bjjs5949JjN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbcEWTsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, axboe@kernel.dk, dmitry.kasatkin@gmail.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: security/integrity/ima/ima_policy.c: use %pU to output UUID in printable format
has been removed from the -mm tree.  Its filename was
     ima-use-%pu-to-output-uuid-in-printable-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-uuid-move-generate_random_uuid-to-uuidc.patch
lib-uuid-introduce-few-more-generic-helpers-for-uuid.patch
lib-uuid-remove-fsf-address.patch
sysctl-use-generic-uuid-library.patch
efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch
genhd-move-to-use-generic-uuid-library.patch
ldm-use-generic-uuid-library.patch
wmi-use-generic-uuid-library.patch

