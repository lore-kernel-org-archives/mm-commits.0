Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33EEC2BBCF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEBBA23331
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgLPEok (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgLPEok (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:40 -0500
Date:   Tue, 15 Dec 2020 20:44:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093864;
        bh=bKPwOlYowbnrwnhanijuqzgijewMpqLOpPSab24p+8s=;
        h=From:To:Subject:In-Reply-To:From;
        b=hcGZmtZ9HuOvr/d7kYxfKEduqsk5nk1QCD4bCNNQMhpXDK34jLB8AuOm4QOr8+SEa
         ODZe3VgVWPCVZD9iGInuQFYyxh0BW/zXnf5+/lwgkL0rOs1YGx3F38oVbrX/iHnA+i
         3/pxHkj6ZfzdVP3vsN8WMpVSfoy/uUs2aG/RViBY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yashsri421@gmail.com
Subject:  [patch 38/95] checkpatch: fix false positives in
 REPEATED_WORD warning
Message-ID: <20201216044424.lPhYYVf4h%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
