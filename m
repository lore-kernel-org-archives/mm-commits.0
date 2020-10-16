Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14114C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42CE20B1F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817839;
	bh=xRUZigBHrfuIsGY6ipPFWnnqQIehsmMqBmwrXsT2So8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=sw8yPpcAqN7rDH0637nX6qnWpBjfn9I1PnpqPpn71BcHsExyoBXrk64iwccSWsDw8
	 3NiSomcFeBbNnPbFHf96wU4OdCGOYaRKEQ47rqHM1uZlIMuO1nvpEho8Po5cdKfxTq
	 KAGoIM6/Ag4UYxC8/sI9WGQ6HVZHjEaerjn/+rmA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733143AbgJPDKj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733127AbgJPDKj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB7820878;
        Fri, 16 Oct 2020 03:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817838;
        bh=xRUZigBHrfuIsGY6ipPFWnnqQIehsmMqBmwrXsT2So8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Xcsj5mtq9YQPioWGaoyEGpBbcDGwYBvTQq3DolXywvKDR4ZY+YOTA0JgZ++pze1w2
         iq6taO/CoTiqcSw70iSX5x9QM2EfLPhElABpMnQLrr3V4RDILzbnKgrmoamaSoIcLF
         IhY+wUjPQ9HPErpL1gvL3/ktzNdXiC8xJnGIZP84=
Date:   Thu, 15 Oct 2020 20:10:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davem@davemloft.net, joe@perches.com,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        robh@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 101/156] get_maintainer: exclude MAINTAINERS
 file(s) from --git-fallback
Message-ID: <20201016031037.BE1xBhkMj%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
