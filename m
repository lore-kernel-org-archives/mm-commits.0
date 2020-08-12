Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB57CC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BEA7206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196111;
	bh=V6q3nq83fvB4X5aFKEP0ixlL7cLNy5k2mA3ABKmSDVI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PHksTE4Cr9ZMgQwfxNJjMCwABAhq3mzR4G+MYaKxLyL4YbW31QbTmtyc4mmjv6mWP
	 YKHIxVJruTFbq3Wfr7CIkJ7/KyX9AkIUGA02eySNtEKpHmFi6irX/hfDzJ2Ryehg+G
	 CjpU131wLIh+YWAijtuTUq6NJmPnhmh+Etkovzp8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgHLBfL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgHLBfL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5E120829;
        Wed, 12 Aug 2020 01:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196110;
        bh=V6q3nq83fvB4X5aFKEP0ixlL7cLNy5k2mA3ABKmSDVI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dvVfGUPxvB6qe0IV1HjY33Uyv7yJxbnS14fILuujqmP30qPSE/vrdiLyfpKsdyDsd
         P4ESOcyUm7fCarQH65Gv91CvRgZU0yqnhJF/jEXz0NiVR1pyZ9ki8pdkt9CMXeV6I5
         QsFAM8CwTIVhUo02OzzkQDba90QgoWRvsC4DSqWM=
Date:   Tue, 11 Aug 2020 18:35:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, julia.lawall@lip6.fr,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 093/165] checkpatch: add --fix option for
 ASSIGN_IN_IF
Message-ID: <20200812013510.WrYI2jPeB%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
