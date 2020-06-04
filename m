From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 085/127] checkpatch: disallow --git and
 --file/--fix
Date: Thu, 04 Jun 2020 16:50:40 -0700
Message-ID: <20200604235040.YyqaVpcWe%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXul (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:50:41 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: disallow --git and --file/--fix

Don't allow these options to be combined.

Miscellanea:

o Add missing $P: to some die("reason message") output

Link: http://lkml.kernel.org/r/3dc7bdaa58490f5906efc11a4d6113e42a087723.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-disallow-git-and-file-fix
+++ a/scripts/checkpatch.pl
@@ -246,6 +246,8 @@ list_types(0) if ($list_types);
 $fix = 1 if ($fix_inplace);
 $check_orig = $check;
 
+die "$P: --git cannot be used with --file or --fix\n" if ($git && ($file || $fix));
+
 my $exit = 0;
 
 my $perl_version_ok = 1;
@@ -269,11 +271,11 @@ if ($color =~ /^[01]$/) {
 } elsif ($color =~ /^auto$/i) {
 	$color = (-t STDOUT);
 } else {
-	die "Invalid color mode: $color\n";
+	die "$P: Invalid color mode: $color\n";
 }
 
 # skip TAB size 1 to avoid additional checks on $tabsize - 1
-die "Invalid TAB size: $tabsize\n" if ($tabsize < 2);
+die "$P: Invalid TAB size: $tabsize\n" if ($tabsize < 2);
 
 sub hash_save_array_words {
 	my ($hashRef, $arrayRef) = @_;
_
