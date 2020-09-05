Return-Path: <SRS0=50af=CO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED3EC433E2
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AD5B208C7
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599338219;
	bh=g0QWYXD0p7lcJMc4SUpjZf0X2orW+vPoBQPNf+wzhnE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XNPR1eRI8nHtWXcupbE6ruOvhmtJoBxlWriUeciHtupsUhYzst/2+Zn20Ij6hSmYh
	 Up7DGyiaFmK35q3LO2TfoEpuFlrtcmNyhLKLvE1X8rTBUaMnYnY8Pw931EC4ML9pJR
	 biXjCe7/MsHlklG3eCczg/6wMWuw+6u+nSDzfloQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgIEUg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Sep 2020 16:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEUg6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 5 Sep 2020 16:36:58 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C91C20796;
        Sat,  5 Sep 2020 20:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599338217;
        bh=g0QWYXD0p7lcJMc4SUpjZf0X2orW+vPoBQPNf+wzhnE=;
        h=Date:From:To:Subject:From;
        b=eqjU1V4Ctbpifmv+ns8Z4ZNYIRydnn25UF9u1LLo+7Bw8WlI2x96AV7x2yMnaSppz
         Za3/92EfFi7HRtBIw0S6Q7gj3EavvJF5o51Ov2ZNL8SsbkJstFYmvBQ9jNaX7t01al
         fFwee2RNCSB9o4qZFpZ++70X4JHPUevDo+PI/4Gk=
Date:   Sat, 05 Sep 2020 13:36:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        julia.lawall@inria.fr, gustavoars@kernel.org, efremov@linux.com,
        joe@perches.com
Subject:  + checkpatch-warn-on-self-assignments.patch added to -mm
 tree
Message-ID: <20200905203655.jr40r%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on self-assignments
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-self-assignments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-self-assignments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-self-assignments.patch

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
Subject: checkpatch: warn on self-assignments

The uninitialized_var() macro was removed recently via commit 63a0895d960a
("compiler: Remove uninitialized_var() macro") as it's not a particularly
useful warning and its use can "paper over real bugs".

Add a checkpatch test to warn on self-assignments as a means to avoid
compiler warnings and as a back-door mechanism to reproduce the old
uninitialized_var macro behavior.

Link: https://lkml.kernel.org/r/afc2cffdd315d3e4394af149278df9e8af7f49f4.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Denis Efremov <efremov@linux.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-warn-on-self-assignments
+++ a/scripts/checkpatch.pl
@@ -3901,6 +3901,17 @@ sub process {
 #ignore lines not being added
 		next if ($line =~ /^[^\+]/);
 
+# check for self assigments used to avoid compiler warnings
+# e.g.:	int foo = foo, *bar = NULL;
+#	struct foo bar = *(&(bar));
+		if ($line =~ /^\+\s*(?:$Declare)?([A-Za-z_][A-Za-z\d_]*)\s*=/) {
+			my $var = $1;
+			if ($line =~ /^\+\s*(?:$Declare)?$var\s*=\s*(?:$var|\*\s*\(?\s*&\s*\(?\s*$var\s*\)?\s*\)?)\s*[;,]/) {
+				WARN("SELF_ASSIGNMENT",
+				     "Do not use self-assignments to avoid compiler warnings\n" . $herecurr);
+			}
+		}
+
 # check for dereferences that span multiple lines
 		if ($prevline =~ /^\+.*$Lval\s*(?:\.|->)\s*$/ &&
 		    $line =~ /^\+\s*(?!\#\s*(?!define\s+|if))\s*$Lval/) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
get_maintainer-add-test-for-file-in-vcs.patch
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch
checkpatch-warn-on-self-assignments.patch

