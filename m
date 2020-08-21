Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF483C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 19:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD3E20724
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598039910;
	bh=dW26U1FtWTIAQk4TF2tefXsMe7CukCntkE3wEro+vp8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=w5Mr0WTyfbAjHyVB875HiJRra94Uk0zp3+o2ruNTVg6hbJW9D1u8XhrkoKui+Zebq
	 6Jnio2/EM118SPp8nKyOufKZqx6WyP8nc28ekpwj3lztn7Ti2ClXjlTv5eGstrKBUL
	 c1/XiCuf7R66pTrJltjwoT+YFpalKFYZU40Q2CN8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHUT6a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 15:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:32890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgHUT63 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 15:58:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADDD420724;
        Fri, 21 Aug 2020 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598039909;
        bh=dW26U1FtWTIAQk4TF2tefXsMe7CukCntkE3wEro+vp8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oGia0tWLEypJ16TotvW3y4xOHh8/frG1nIEjv6imS7r39jeFCaCkZwBUaxsG78Mdi
         xZ6asE2Uyj3qzwNRmQ1cvwbzEHUCcYL65wbJuLaATjVPFGwbgftmlQSKjjWv4VsTPI
         Dl1Cf5L5wk0NjxtI+LnRXon7d8cjIN/u/Brrzw80=
Date:   Fri, 21 Aug 2020 12:58:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     davem@davemloft.net, joe@perches.com, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, robh@kernel.org
Subject:  +
 get_maintainer-exclude-maintainers-files-from-git-fallback.patch added to
 -mm tree
Message-ID: <20200821195828.8mZmSr0oO%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: exclude MAINTAINERS file(s) from --git-fallback
has been added to the -mm tree.  Its filename is
     get_maintainer-exclude-maintainers-files-from-git-fallback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-exclude-maintainers-files-from-git-fallback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-exclude-maintainers-files-from-git-fallback.patch

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
@@ -954,8 +954,10 @@ sub get_maintainers {
 
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
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch

