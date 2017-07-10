From: akpm@linux-foundation.org
Subject: [patch 097/115] checkpatch: improve the unnecessary OOM
 message test
Date: Mon, 10 Jul 2017 15:52:04 -0700
Message-ID: <20170710225204.L0D9fQmYO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43516 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754696AbdGJWwF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -5311,7 +5311,7 @@ sub process {
 			my ($s, $c) = ctx_statement_block($linenr - 3, $realcnt, 0);
 #			print("line: <$line>\nprevline: <$prevline>\ns: <$s>\nc: <$c>\n\n\n");
 
-			if ($c =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|(?:dev_)?alloc_skb)/) {
+			if ($s =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|kmemdup|(?:dev_)?alloc_skb)/) {
 				WARN("OOM_MESSAGE",
 				     "Possible unnecessary 'out of memory' message\n" . $hereprev);
 			}
_
