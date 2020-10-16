Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0E7C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F0221D40
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881643;
	bh=ghMHWc6h0R52iyaT8W+dtgH9wFa8PRdgkX10qGHxmsI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SIUOtQ0bzwOjuKeFCz43MpIk8U6F45yz0cT6S01tp4DzQTuj+b7zQgJgIywiT44BR
	 oJk/6nbb7fQxyc324ibYwY/j6FJBmfK4ljkUUFya/Vue61yd4+nOa1djoIS7etIAuZ
	 +jlHNit0taNt2+eHKNa2DzaamtQRw1F0EOvDqh/I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409224AbgJPUyD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409219AbgJPUyD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A5F216C4;
        Fri, 16 Oct 2020 20:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881643;
        bh=ghMHWc6h0R52iyaT8W+dtgH9wFa8PRdgkX10qGHxmsI=;
        h=Date:From:To:Subject:From;
        b=cPe3L17N0Fv+PzZPTdjznX10yD4kDIkN6DJPS7RoZ9jLqj/h9ZCYo4qJ6bbHTWQFd
         F365oFJRES9oQRMAB3osx+g+Cg6Y5xRtaFr2yH+PdV50NjGevygRLGvAv28tmzkGza
         lGETnU8DZwXTne8PPpFS90I0eznWKSG7ZpGi+jwY=
Date:   Fri, 16 Oct 2020 13:54:02 -0700
From:   akpm@linux-foundation.org
To:     efremov@linux.com, gustavoars@kernel.org, joe@perches.com,
        julia.lawall@inria.fr, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-warn-on-self-assignments.patch
 removed from -mm tree
Message-ID: <20201016205402.mOho5CNUW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on self-assignments
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-self-assignments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on self-assignments

The uninitialized_var() macro was removed recently via commit 63a0895d960a
("compiler: Remove uninitialized_var() macro") as it's not a particularly
useful warning and its use can "paper over real bugs".

Add a checkpatch test to warn on self-assignments as a means to avoid
compiler warnings and as a back-door mechanism to reproduce the old
uninitialized_var macro behavior.

[akpm@linux-foundation.org: coding style fixes]
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
@@ -3899,6 +3899,17 @@ sub process {
 #ignore lines not being added
 		next if ($line =~ /^[^\+]/);
 
+# check for self assignments used to avoid compiler warnings
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

