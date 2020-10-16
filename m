Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28C4C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C92208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817932;
	bh=+zm8JEJDvdWTDvYHkQ5bHIwYYLcmpSp2CxNSfmGjWws=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jLzJOpECB3uMAfs35ZA50jgfnVVAvvkzrXiBDpV7Dh418bgPVUTaU7b2NY8ZItc7z
	 BMF63mtFxElU7LGe625Y5nm0caqOyMvGyfzYzZizouplZjOif5mk0SH6AXeHVDqya3
	 M2FFmKDxWmXQrzBBtykBx1P7hB5EAN25VyiFlCGk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389654AbgJPDMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDML (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B70720878;
        Fri, 16 Oct 2020 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817930;
        bh=+zm8JEJDvdWTDvYHkQ5bHIwYYLcmpSp2CxNSfmGjWws=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TrBCbTM1gneFzdSEq7qPFgZXjMXZ9KQomsSvUO4xdCmwJA5F5Qpv2QTgY4+DMa8ZE
         JuEofmXsuFu+1olTGhQtbooOWQnoc0myefSHahFUIo2JnBZqmtRZdPxsEMSzx3NklM
         SSR3IQigpxWSsKIUzHB1PI2uYwqX4TRKjToW2zHM=
Date:   Thu, 15 Oct 2020 20:12:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, efremov@linux.com,
        gustavoars@kernel.org, joe@perches.com, julia.lawall@inria.fr,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 127/156] checkpatch: warn on self-assignments
Message-ID: <20201016031209.YKLzujvcn%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
