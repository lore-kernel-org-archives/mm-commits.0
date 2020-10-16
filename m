Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE9DC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C318620658
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881568;
	bh=1Hf/dKeYX0NKm2RLCGj4KZZesaV50EUpsVqcuTRKS1w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HyFSJpgxKY1oLJ8cBoYyZqGysaREQRMj9cgsY2x0Fcc++fDgIerugtRVhIlYK/1D7
	 Dje30dfdwfIvYE9rr//nlToLB/GSkUtcpayMVfs0N/Po/f6cgdcO1TGWzkrv4JmVpy
	 //LzWPHALkcROwSFNV91wzyjziSyWko3LBc1qj9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409050AbgJPUws (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUwr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DB420657;
        Fri, 16 Oct 2020 20:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881566;
        bh=1Hf/dKeYX0NKm2RLCGj4KZZesaV50EUpsVqcuTRKS1w=;
        h=Date:From:To:Subject:From;
        b=0lEap290RXaCvP1+yHVLRowt4nTB/zpIR3EHs4pKJaMVctL27B/N4/5s0BvWt7O6Q
         7DBSlRM9EDhUAAQ/+bv3eAQvOw23Z/K4LCOxA2vv19eTR9jq8px51t7uEZ/e3E4vLT
         xQYmZVPbGl3pxQm1QNxP4K/vJFW0xve1+xpPGo1o=
Date:   Fri, 16 Oct 2020 13:52:45 -0700
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, joe@perches.com, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, robh@kernel.org
Subject:  [merged]
 get_maintainer-exclude-maintainers-files-from-git-fallback.patch removed
 from -mm tree
Message-ID: <20201016205245.g2kZbPB2s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: exclude MAINTAINERS file(s) from --git-fallback
has been removed from the -mm tree.  Its filename was
     get_maintainer-exclude-maintainers-files-from-git-fallback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: exclude MAINTAINERS file(s) from --git-fallback

MAINTAINERS files generally have no specific maintainer but are updated by
individuals for subsystems all over the source tree.

Exclude MAINTAINERS file(s) from --git-fallback searches so the unlucky
individuals that update the files the most are not shown by default.

Link: https://lkml.kernel.org/r/2bacb0a9c06fbb6d56a43bf930e808c74243c908.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-exclude-maintainers-files-from-git-fallback
+++ a/scripts/get_maintainer.pl
@@ -957,8 +957,10 @@ sub get_maintainers {
 
     foreach my $file (@files) {
 	if ($email &&
-	    ($email_git || ($email_git_fallback &&
-			    !$exact_pattern_match_hash{$file}))) {
+	    ($email_git ||
+	     ($email_git_fallback &&
+	      $file !~ /MAINTAINERS$/ &&
+	      !$exact_pattern_match_hash{$file}))) {
 	    vcs_file_signoffs($file);
 	}
 	if ($email && $email_git_blame) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch

