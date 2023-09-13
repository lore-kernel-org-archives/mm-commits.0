Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389CFEE0204
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 21:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjIMVWO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjIMVWN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 17:22:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F0F1724
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 14:22:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46DCC433C7;
        Wed, 13 Sep 2023 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694640129;
        bh=mCCGeIjd9nqrumKroiI/KNm8akbZAGgwaXufFQS+Yvc=;
        h=Date:To:From:Subject:From;
        b=UXit0AIaUY+uUs3W1Wgbv2/FdIa2BeKhgnh03mrGp0eJOfs1TNCbRoaaRkBYXptvc
         LifJKTosv7RJtb+ZQODqaAL6m9PYTRfd1KA8KgLf/Sf7izWxKGVraPhn+MXPTF+F0i
         MDJPBhFHYeggF+dYSU505LmYrb8IDJtqYSbYnFv0=
Date:   Wed, 13 Sep 2023 14:22:08 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        gustavoars@kernel.org, dwaipayanray1@gmail.com, apw@canonical.com,
        joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-simplify-creating-search-strings.patch added to mm-nonmm-unstable branch
Message-Id: <20230913212208.D46DCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: simplify creating search strings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-simplify-creating-search-strings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-simplify-creating-search-strings.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: simplify creating search strings
Date: Wed, 13 Sep 2023 13:37:51 -0700

Patch series "checkpatch: refactor and add new alloc w/ multiply tests".

Original alloc function patch by Gustavo Silva.


This patch (of 2):

Use join and map instead of loops.

Link: https://lkml.kernel.org/r/cover.1694636817.git.joe@perches.com
Link: https://lkml.kernel.org/r/ef2ab1a00367e201879d9bff44a2e7e936b87a7e.1694636817.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com> (maintainer:CHECKPATCH)
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com> (reviewer:CHECKPATCH)
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-simplify-creating-search-strings
+++ a/scripts/checkpatch.pl
@@ -625,18 +625,8 @@ our $signature_tags = qr{(?xi:
 our @link_tags = qw(Link Closes);
 
 #Create a search and print patterns for all these strings to be used directly below
-our $link_tags_search = "";
-our $link_tags_print = "";
-foreach my $entry (@link_tags) {
-	if ($link_tags_search ne "") {
-		$link_tags_search .= '|';
-		$link_tags_print .= ' or ';
-	}
-	$entry .= ':';
-	$link_tags_search .= $entry;
-	$link_tags_print .= "'$entry'";
-}
-$link_tags_search = "(?:${link_tags_search})";
+our $link_tags_search = '(?:' . join('|', @link_tags) . ')';
+our $link_tags_print = "'" . join("' or '", @link_tags) . "'";
 
 our $tracing_logging_tags = qr{(?xi:
 	[=-]*> |
@@ -819,15 +809,10 @@ our @mode_permission_funcs = (
 	["__ATTR", 2],
 );
 
-my $word_pattern = '\b[A-Z]?[a-z]{2,}\b';
-
 #Create a search pattern for all these functions to speed up a loop below
-our $mode_perms_search = "";
-foreach my $entry (@mode_permission_funcs) {
-	$mode_perms_search .= '|' if ($mode_perms_search ne "");
-	$mode_perms_search .= $entry->[0];
-}
-$mode_perms_search = "(?:${mode_perms_search})";
+our $mode_perms_search = '(?:' . join('|', map{$_->[0]} @mode_permission_funcs) . ')';
+
+my $word_pattern = '\b[A-Z]?[a-z]{2,}\b';
 
 our %deprecated_apis = (
 	"synchronize_rcu_bh"			=> "synchronize_rcu",
@@ -847,12 +832,7 @@ our %deprecated_apis = (
 );
 
 #Create a search pattern for all these strings to speed up a loop below
-our $deprecated_apis_search = "";
-foreach my $entry (keys %deprecated_apis) {
-	$deprecated_apis_search .= '|' if ($deprecated_apis_search ne "");
-	$deprecated_apis_search .= $entry;
-}
-$deprecated_apis_search = "(?:${deprecated_apis_search})";
+our $deprecated_apis_search = '(?:' . join('|', keys %deprecated_apis) . ')';
 
 our $mode_perms_world_writable = qr{
 	S_IWUGO		|
@@ -887,7 +867,7 @@ foreach my $entry (keys %mode_permission
 	$mode_perms_string_search .= '|' if ($mode_perms_string_search ne "");
 	$mode_perms_string_search .= $entry;
 }
-our $single_mode_perms_string_search = "(?:${mode_perms_string_search})";
+our $single_mode_perms_string_search = '(?:' . join('|', keys %mode_permission_string_types) . ')';
 our $multi_mode_perms_string_search = qr{
 	${single_mode_perms_string_search}
 	(?:\s*\|\s*${single_mode_perms_string_search})*
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-simplify-creating-search-strings.patch
checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch

