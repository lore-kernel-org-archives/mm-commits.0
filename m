From: akpm@linux-foundation.org
Subject: + checkpatch-improve-the-unnecessary-oom-message-test.patch added to -mm tree
Date: Thu, 01 Jun 2017 14:19:27 -0700
Message-ID: <593084df.3aziOI0XphQte/VP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdFAVT2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 17:19:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the unnecessary OOM message test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-the-unnecessary-oom-message-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-the-unnecessary-oom-message-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-the-unnecessary-oom-message-test.patch

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
Subject: checkpatch: improve the unnecessary OOM message test

Use the context around a patch to avoid missing some candidates.

Link: http://lkml.kernel.org/r/865e874fbae5decc331a849bd8d71c325db6bc80.1496343345.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-unnecessary-oom-message-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-unnecessary-oom-message-test
+++ a/scripts/checkpatch.pl
@@ -5310,7 +5310,7 @@ sub process {
 			my ($s, $c) = ctx_statement_block($linenr - 3, $realcnt, 0);
 #			print("line: <$line>\nprevline: <$prevline>\ns: <$s>\nc: <$c>\n\n\n");
 
-			if ($c =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|(?:dev_)?alloc_skb)/) {
+			if ($s =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|kmemdup|(?:dev_)?alloc_skb)/) {
 				WARN("OOM_MESSAGE",
 				     "Possible unnecessary 'out of memory' message\n" . $hereprev);
 			}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch

