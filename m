Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14249C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABBD2218AC
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881633;
	bh=j+nzllbmBwoJBxxWj0ScXC6RxIoHP37K2lj0TO8+YV4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SgbaBhe/8CEWtORdRtwuH5jIxaqmyFq1JBnKnQLNRdceBOyg4gIZ6qipA8Ad6b8qW
	 XdpCEZ78wEwBJYEvnQHoMzrhzsSh/nwOqjAceny8+zyG58MjqqHAxBBMlg6uNZ8GMY
	 VcQSku3UlqrfbT5a+hkwo75rHBNqM6zSupik+47U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409148AbgJPUxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409212AbgJPUxv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABAF9216C4;
        Fri, 16 Oct 2020 20:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881630;
        bh=j+nzllbmBwoJBxxWj0ScXC6RxIoHP37K2lj0TO8+YV4=;
        h=Date:From:To:Subject:From;
        b=K00WRlg3HUBLpKWm6wUBhG+NM/Ltbwyq69YSMyh8E4BBHui7vWlLjwYC4FVYebnJS
         wcNYWMYOyxI2GguowZMDjY40Hb+fCbzk38WeInJWyJZAuYuSb3Oz7P18waSXz0nSBG
         u8RlELe3kM784Zo8Ovs4YgfOdvsNGZp+KNrGTfK8=
Date:   Fri, 16 Oct 2020 13:53:50 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch removed
 from -mm tree
Message-ID: <20201016205350.YahQgLg1U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for comma use that should be semicolon
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for comma use that should be semicolon

There are commas used as statement terminations that should typically have
used semicolons instead.  Only direct assignments or use of a single
function or value on a single line are detected by this test.

e.g.:
	foo = bar(),		/* typical use is semicolon not comma */
	bar = baz();

Add an imperfect test to detect these comma uses.

No false positives were found in testing, but many types of false
negatives are possible.

e.g.:
	foo = bar() + 1,	/* comma use, but not direct assignment */
	bar = baz();

Link: https://lkml.kernel.org/r/3bf27caf462007dfa75647b040ab3191374a59de.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-test-for-comma-use-that-should-be-semicolon
+++ a/scripts/checkpatch.pl
@@ -4940,6 +4940,17 @@ sub process {
 			}
 		}
 
+# check if a statement with a comma should be two statements like:
+#	foo = bar(),	/* comma should be semicolon */
+#	bar = baz();
+		if (defined($stat) &&
+		    $stat =~ /^\+\s*(?:$Lval\s*$Assignment\s*)?$FuncArg\s*,\s*(?:$Lval\s*$Assignment\s*)?$FuncArg\s*;\s*$/) {
+			my $cnt = statement_rawlines($stat);
+			my $herectx = get_stat_here($linenr, $cnt, $here);
+			WARN("SUSPECT_COMMA_SEMICOLON",
+			     "Possible comma where semicolon could be used\n" . $herectx);
+		}
+
 # return is not a function
 		if (defined($stat) && $stat =~ /^.\s*return(\s*)\(/s) {
 			my $spacing = $1;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch

