Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD68EEAA6E
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 19:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjINT7x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 15:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjINT7x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 15:59:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686AD26B8
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 12:59:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA2DC433C8;
        Thu, 14 Sep 2023 19:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694721589;
        bh=aIoUGbQiobDGbvpCwvlxldFwo4vQOhnHQihZS3SmdI8=;
        h=Date:To:From:Subject:From;
        b=RxfEVu/APkW4f22Lb3zsp8nJ5bJ6g6Iqi2dfeaPqSjf1drzwClmfK8SF7H1ni9Y+d
         tuZ5G8CDmst0GLRkjsBBrb6QdoPlMpDDjPpw4dgsJVTllOqxdvi1/2kCU7c1v1mqyx
         EMyJPVpEJ+hmqmi4cDf5+ACQfZFyi4LeuaoycJtg=
Date:   Thu, 14 Sep 2023 12:59:48 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        gustavoars@kernel.org, dwaipayanray1@gmail.com, apw@canonical.com,
        joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] checkpatch-simplify-creating-search-strings.patch removed from -mm tree
Message-Id: <20230914195948.EBA2DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: simplify creating search strings
has been removed from the -mm tree.  Its filename was
     checkpatch-simplify-creating-search-strings.patch

This patch was dropped because an updated version will be merged

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

checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch

