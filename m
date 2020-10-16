Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC62C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0228D208E4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816544;
	bh=+zm8JEJDvdWTDvYHkQ5bHIwYYLcmpSp2CxNSfmGjWws=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fCYR/UtctRJXhs6vl9vq7zpemzRmp9Z/v5GwgIYU3wDXN61qX1I1HGEPKPwMDdfvh
	 IuHwpITAJnEWNaZIjWiy0yJP+R8dJCFyoTEBEoc5VtjqxklUaGdo1MbdEsWEsbBhsq
	 FaZ2Z/+ACE08TEP/nzNXX8m5TASvj/rqKaNnlBGM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404379AbgJPCtD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404364AbgJPCtD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:49:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 022352087D;
        Fri, 16 Oct 2020 02:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816541;
        bh=+zm8JEJDvdWTDvYHkQ5bHIwYYLcmpSp2CxNSfmGjWws=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kiXG9M5NrbbXRXdX9LveyBaWtLGecVydxaunLwI3St1a4IdpqVOl/VA5CK5p09S1N
         emLqiax+hZWviK1o3ZfnMW00nd0iNIn66GnkACH4TlddqdVVsHImhSp0lZX8kBEx5M
         cLCNTzOkS0GVkIJ5K9nwCUQ1pJ1CKV3vk4WXoHPA=
Date:   Thu, 15 Oct 2020 19:49:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, efremov@linux.com,
        gustavoars@kernel.org, joe@perches.com, julia.lawall@inria.fr,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 127/156] checkpatch: warn on self-assignments
Message-ID: <20201016024900.rKnqH0xK7%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
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
