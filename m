From: akpm@linux-foundation.org
Subject: +
 checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch added
 to -mm tree
Date: Tue, 10 Jun 2014 15:44:09 -0700
Message-ID: <53978a39.3ZwWLGjxcN1UDD1P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaFJWoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:44:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:44:09 -0700


The patch titled
     Subject: checkpatch: attempt to find unnecessary 'out of memory' messages
has been added to the -mm tree.  Its filename is
     checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch

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
Subject: checkpatch: attempt to find unnecessary 'out of memory' messages

Logging messages that show some type of "out of memory" error
are generally unnecessary as there is a generic message and
a stack dump done by the memory subsystem.

These messages generally increase kernel size without much
added value.

Emit a warning on these types of messages.

This test looks for any inserted message function, then looks
at the previous line for an "if (!foo)" or "if (foo == NULL)"
test and then looks at the preceding statement for an allocation
function like "foo = kmalloc()"

ie: this code matches:

	foo = kmalloc();
	if (foo == NULL) {
		printk("Out of memory\n");
		return -ENOMEM;
	}

This test is very crude and incomplete.

This test can miss quite a lot of of OOM messages that do not
have this specific form.

ie: this code does not match:

	foo = kmalloc();
	if (!foo) {
		rtn = -ENOMEM;
		printk("Out of memory!\n");
		goto out;
	}

This test could also be a false positive when the logging
message itself does not specify anything about memory, but
I did not find any false positives in my limited testing.

spatch could be a better solution but correctness seems
non-trivial for that tool too.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-attempt-to-find-unnecessary-out-of-memory-messages scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-attempt-to-find-unnecessary-out-of-memory-messages
+++ a/scripts/checkpatch.pl
@@ -4017,6 +4017,23 @@ sub process {
 			}
 		}
 
+# check for unnecessary "Out of Memory" messages
+		if ($line =~ /^\+.*\b$logFunctions\s*\(/ &&
+		    $prevline =~ /^[ \+]\s*if\s*\(\s*(\!\s*|NULL\s*==\s*)?($Lval)(\s*==\s*NULL\s*)?\s*\)/ &&
+		    (defined $1 || defined $3) &&
+		    $linenr > 3) {
+			my $testval = $2;
+			my $testline = $lines[$linenr - 3];
+
+			my ($s, $c) = ctx_statement_block($linenr - 3, $realcnt, 0);
+#			print("line: <$line>\nprevline: <$prevline>\ns: <$s>\nc: <$c>\n\n\n");
+
+			if ($c =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|(?:dev_)?alloc_skb)/) {
+				WARN("OOM_MESSAGE",
+				     "Possible unnecessary 'out of memory' message\n" . $hereprev);
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

