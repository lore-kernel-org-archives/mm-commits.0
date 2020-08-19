Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113AAC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E29BB207FF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597872675;
	bh=fMJOEQiH+gRtCnERcuyNuN8FEXz72qGvpivcHzg/fK8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=UQKEEieRFZstdMykHz58JMdIhapVWld+u64u9H0aVyIxY+mRxPXRtDD2b7/OSj4D0
	 +S6qw208w5sGp9TGRafO8KRouTcqbmxq5a0+y+K/R+LS1RLg07dDU1pfywYoOAHPM7
	 DTGtt/hasFn0hwIHBuwKx5ziEyCG81qBMR1k4f28=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHSVbP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHSVbP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 17:31:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C3A52078D;
        Wed, 19 Aug 2020 21:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597872674;
        bh=fMJOEQiH+gRtCnERcuyNuN8FEXz72qGvpivcHzg/fK8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R1QJVNzDsC70MHMvb7Ffg9epAXOVRruSkU/x5qQjIjQ9ggQTY7jhUHx1WLCci63Rl
         JHQIRw2gS5pXdV3XNCGniH5z45Dwf6uDk/uCKEhWl02H6MlRcDzXtd2iIyIlbAYONy
         KxnLHvq37Sdws8GemtY/0J3zCEUs88yWzHFtGU24=
Date:   Wed, 19 Aug 2020 14:31:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  +
 checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch added to
 -mm tree
Message-ID: <20200819213114.E5okrLNdZ%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for comma use that should be semicolon
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Joe Perches <joe@perches.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-test-for-comma-use-that-should-be-semicolon
+++ a/scripts/checkpatch.pl
@@ -4942,6 +4942,17 @@ sub process {
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
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch

