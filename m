Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25313C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047C723403
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgLPRKZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgLPRKZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:25 -0500
Date:   Wed, 16 Dec 2020 09:09:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138584;
        bh=2pbjntCva1tP4emYOPA+cvTBAK+vYm4iTxpVjF0KLHk=;
        h=From:To:Subject:From;
        b=MZzm5IuZ+wW1XEZ1mtcZx3fMOmNvkT/dCj0kZIKJhUZIdU6vPPhCxZxqrCuTU2CR7
         3YEmyjM9ZTAj+sU+q0v5eJMJ7sRpnjmrnABmD1MqeUR4cx8Dxsp8DiflTNsXyK3w2H
         WdeqlfdGsl4uwlKpdtFWBYk4y6CAPkamyGbN5YBY=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  [merged]
 checkpatch-fix-false-positives-in-repeated_word-warning.patch removed from
 -mm tree
Message-ID: <20201216170944.p7Qu_NlQs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix false positives in REPEATED_WORD warning
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-false-positives-in-repeated_word-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aditya Srivastava <yashsri421@gmail.com>
Subject: checkpatch: fix false positives in REPEATED_WORD warning

Presence of hexadecimal address or symbol results in false warning
message by checkpatch.pl.

For example, running checkpatch on commit b8ad540dd4e4 ("mptcp: fix
memory leak in mptcp_subflow_create_socket()") results in warning:

WARNING:REPEATED_WORD: Possible repeated word: 'ff'
    00 00 00 00 00 00 00 00 00 2f 30 0a 81 88 ff ff  ........./0.....

Similarly, the presence of list command output in commit results in
an unnecessary warning.

For example, running checkpatch on commit 899e5ffbf246 ("perf record:
Introduce --switch-output-event") gives:

WARNING:REPEATED_WORD: Possible repeated word: 'root'
  dr-xr-x---. 12 root root    4096 Apr 27 17:46 ..

Here, it reports 'ff' and 'root' to be repeated, but it is in fact part
of some address or code, where it has to be repeated.

In these cases, the intent of the warning to find stylistic issues in
commit messages is not met and the warning is just completely wrong in
this case.

To avoid these warnings, add an additional regex check for the
directory permission pattern and avoid checking the line for this
class of warning. Similarly, to avoid hex pattern, check if the word
consists of hex symbols and skip this warning if it is not among the
common english words formed using hex letters.

A quick evaluation on v5.6..v5.8 showed that this fix reduces
REPEATED_WORD warnings by the frequency of 1890.

A quick manual check found all cases are related to hex output or
list command outputs in commit messages.

Link: https://lkml.kernel.org/r/20201024102253.13614-1-yashsri421@gmail.com
Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-false-positives-in-repeated_word-warning
+++ a/scripts/checkpatch.pl
@@ -853,6 +853,13 @@ our $declaration_macros = qr{(?x:
 	(?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(
 )};
 
+our %allow_repeated_words = (
+	add => '',
+	added => '',
+	bad => '',
+	be => '',
+);
+
 sub deparenthesize {
 	my ($string) = @_;
 	return "" if (!defined($string));
@@ -3049,7 +3056,9 @@ sub process {
 		}
 
 # check for repeated words separated by a single space
-		if ($rawline =~ /^\+/ || $in_commit_log) {
+# avoid false positive from list command eg, '-rw-r--r-- 1 root root'
+		if (($rawline =~ /^\+/ || $in_commit_log) &&
+		    $rawline !~ /[bcCdDlMnpPs\?-][rwxsStT-]{9}/) {
 			pos($rawline) = 1 if (!$in_commit_log);
 			while ($rawline =~ /\b($word_pattern) (?=($word_pattern))/g) {
 
@@ -3074,6 +3083,11 @@ sub process {
 				next if ($start_char =~ /^\S$/);
 				next if (index(" \t.,;?!", $end_char) == -1);
 
+                                # avoid repeating hex occurrences like 'ff ff fe 09 ...'
+                                if ($first =~ /\b[0-9a-f]{2,}\b/i) {
+                                        next if (!exists($allow_repeated_words{lc($first)}));
+                                }
+
 				if (WARN("REPEATED_WORD",
 					 "Possible repeated word: '$first'\n" . $herecurr) &&
 				    $fix) {
_

Patches currently in -mm which might be from yashsri421@gmail.com are


