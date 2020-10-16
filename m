Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A7AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91AE92087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817917;
	bh=UQtxO27mP7LnnB9J3mHTWveaJm6JyhxyLXNoFOud3wE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bLb+Qm4ZFm2r95fu1jpwjluNpJiMKQdHxpIE/Eys8CyR1+tXeBPidfHKkuWP/WSGF
	 mij2Lv8V9q0gevGkDHksLqNOCTqez0B27Ys62cfgvxD/tUskAXCPduENywkI3ET6fe
	 zCSYxI2dVBwQoXnh9JdRUt6UqoZZQc/O12uDELnA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbgJPDL5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDL5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8911220789;
        Fri, 16 Oct 2020 03:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817916;
        bh=UQtxO27mP7LnnB9J3mHTWveaJm6JyhxyLXNoFOud3wE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1YeLJ1cgwJaILxYjPYOmcQyVQ4gQPQclk/n0EDRhWAcLj3bxD0NEZdBeIAIAFXoms
         g42OsOg+LKYJldVVlo1lZZ7aVqe5dWENyBilN0mB2DuAy2+SilwnuOJLHbvrW1kk1J
         8QgPy3W2niJNNAWLdHfXX+2WPQaHUaUpZmwfFICI=
Date:   Thu, 15 Oct 2020 20:11:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 123/156] checkpatch: add test for comma use that
 should be semicolon
Message-ID: <20201016031156.b6_TCfSc-%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
