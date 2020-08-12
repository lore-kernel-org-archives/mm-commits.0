Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A091C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3604A2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266266;
	bh=GGhyBLSrOgE9uUM5rokFvmk397+Qky0BvmK2R5p+Ej4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VcujnxONL2skjiy4Oe1dmn5KjfUIS8SuQiUaB3Ip4XCIpM+M5GREQFLWPChzk/cAz
	 fhC3XCz4XofHsKI5usztnf2yy42yu2v6NCGPpMvK3la85NLHaVTjqR5buKLLJ+Evdz
	 Rd8fHNhuXTJLFPMuBPi39GeZL40H4sGviwNXjd3s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLVEZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgHLVEZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FB5820774;
        Wed, 12 Aug 2020 21:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266265;
        bh=GGhyBLSrOgE9uUM5rokFvmk397+Qky0BvmK2R5p+Ej4=;
        h=Date:From:To:Subject:From;
        b=zgBNjLyv65KOzovycmPPLV2nNReSIWhgGzdgXf/WtwyLP/UvKPeTgaunBqX9UalPU
         bQNDfAKBipNQw44hA+x64NuPKIC0eHyuWXsases/LZ/d+jeVW4pfaMzLSysYYBqnSr
         esZM64cBSDy5d73YuCYRkw4Ao+cQ+Uxc6B+mf3uA=
Date:   Wed, 12 Aug 2020 14:04:25 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-add-fix-option-for-assign_in_if.patch
 removed from -mm tree
Message-ID: <20200812210425.b-YakWVuz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --fix option for ASSIGN_IN_IF
has been removed from the -mm tree.  Its filename was
     checkpatch-add-fix-option-for-assign_in_if.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --fix option for ASSIGN_IN_IF

Add a --fix option for 2 types of single-line assignment in if statements

	if ((foo = bar(...)) < BAZ) {
expands to:
	foo = bar(..);
	if (foo < BAZ) {
and
	if ((foo = bar(...)) {
expands to:
	foo = bar(...);
	if (foo) {

if statements with assignments spanning multiple lines are
not converted with the --fix option.

if statements with additional logic are also not converted.

e.g.:	if ((foo = bar(...)) & BAZ == BAZ) {

Link: http://lkml.kernel.org/r/9bc7c782516f37948f202deba511bc95ed279bbd.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-fix-option-for-assign_in_if
+++ a/scripts/checkpatch.pl
@@ -5020,8 +5020,30 @@ sub process {
 			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
-				ERROR("ASSIGN_IN_IF",
-				      "do not use assignment in if condition\n" . $herecurr);
+				if (ERROR("ASSIGN_IN_IF",
+					  "do not use assignment in if condition\n" . $herecurr) &&
+				    $fix && $perl_version_ok) {
+					if ($rawline =~ /^\+(\s+)if\s*\(\s*(\!)?\s*\(\s*(($Lval)\s*=\s*$LvalOrFunc)\s*\)\s*(?:($Compare)\s*($FuncArg))?\s*\)\s*(\{)?\s*$/) {
+						my $space = $1;
+						my $not = $2;
+						my $statement = $3;
+						my $assigned = $4;
+						my $test = $8;
+						my $against = $9;
+						my $brace = $15;
+						fix_delete_line($fixlinenr, $rawline);
+						fix_insert_line($fixlinenr, "$space$statement;");
+						my $newline = "${space}if (";
+						$newline .= '!' if defined($not);
+						$newline .= '(' if (defined $not && defined($test) && defined($against));
+						$newline .= "$assigned";
+						$newline .= " $test $against" if (defined($test) && defined($against));
+						$newline .= ')' if (defined $not && defined($test) && defined($against));
+						$newline .= ')';
+						$newline .= " {" if (defined($brace));
+						fix_insert_line($fixlinenr + 1, $newline);
+					}
+				}
 			}
 
 			# Find out what is on the end of the line after the
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch

