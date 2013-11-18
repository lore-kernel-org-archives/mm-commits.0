From: akpm@linux-foundation.org
Subject: +
 checkpatchpl-check-for-function-declarations-without-arguments.patch added
 to -mm tree
Date: Mon, 18 Nov 2013 15:40:41 -0800
Message-ID: <528aa579.BO7mHlfUq9YnK1/K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KRXkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 18:40:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at, bp@alien8.de, joe@perches.com

Subject: + checkpatchpl-check-for-function-declarations-without-arguments.patch added to -mm tree
To: joe@perches.com,bp@alien8.de,richard@nod.at
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 15:40:41 -0800


The patch titled
     Subject: checkpatch.pl: check for function declarations without arguments
has been added to the -mm tree.  Its filename is
     checkpatchpl-check-for-function-declarations-without-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-check-for-function-declarations-without-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-check-for-function-declarations-without-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch.pl: check for function declarations without arguments

Functions like this one are evil:

void foo()
{
	...
}

Because these functions allow variadic arguments without
checking the arguments at all.

Original patch by Richard Weinberger.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-check-for-function-declarations-without-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-check-for-function-declarations-without-arguments
+++ a/scripts/checkpatch.pl
@@ -2634,6 +2634,15 @@ sub process {
 				$herecurr);
                }
 
+# check for function declarations without arguments like "int foo()"
+		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
+			if (ERROR("FUNCTION_WITHOUT_ARGS",
+				  "Bad function definition - $1() should probably be $1(void)\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/(\b($Type)\s+($Ident))\s*\(\s*\)/$2 $3(void)/;
+			}
+		}
+
 # check for declarations of struct pci_device_id
 		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
 			WARN("DEFINE_PCI_DEVICE_TABLE",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-fix-use-of-uninitialized-value-warnings.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainerpl-incomplete-output.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch
linux-next.patch

