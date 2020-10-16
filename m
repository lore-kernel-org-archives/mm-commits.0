Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C147C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C512F2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817837;
	bh=Yxd1/wmlB+N+skJntfz8a6EIZ4FtD2ib1yOe1BIfJok=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nTM4HjcVCkBpvvz5T6mLa5wf4hCXhaybBGDXl5j3ZTkhm9VJfrr8c9lbSndcCEEGR
	 M2Eb07ym9jhHYJ4vTuVeWWNPnB9kfFjpAnqmpCaQvMpio2OiLTdL+VaHMy430wuRv0
	 nbcRU3BJWLhYFgDuUuqe/Q7RDFocQpAi2H5b1VaU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733115AbgJPDKh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732461AbgJPDKh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 500F220878;
        Fri, 16 Oct 2020 03:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817835;
        bh=Yxd1/wmlB+N+skJntfz8a6EIZ4FtD2ib1yOe1BIfJok=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ekfjygZD+g93PzorIZOQvgr1EERk4Zlep1GC5poXZ+cqNcH8lz4HTnRiq4EJTBspq
         Rg+TH4f1NH91GXQChdzHLztnwkxJoi5lYEhBFi/Cy4ghsinnZYNK41tH0sM6dAzRv9
         Yus1lxNmqPqN27bFvXNE1mFfHaY0lOtTwdHNg/nI=
Date:   Thu, 15 Oct 2020 20:10:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 100/156] get_maintainer: add test for file in VCS
Message-ID: <20201016031034.KFRrgl1iV%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: get_maintainer: add test for file in VCS

It's somewhat common for me to ask get_maintainer to tell me who maintains
a patch file rather than the files modified by the patch.

Emit a warning if using get_maintainer.pl -f <patchfile>

Link: https://lkml.kernel.org/r/f63229c051567041819f25e76f49d83c6e4c0f71.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/get_maintainer.pl~get_maintainer-add-test-for-file-in-vcs
+++ a/scripts/get_maintainer.pl
@@ -541,6 +541,9 @@ foreach my $file (@ARGV) {
 	    die "$P: file '${file}' not found\n";
 	}
     }
+    if ($from_filename && (vcs_exists() && !vcs_file_exists($file))) {
+	warn "$P: file '$file' not found in version control $!\n";
+    }
     if ($from_filename || ($file ne "&STDIN" && vcs_file_exists($file))) {
 	$file =~ s/^\Q${cur_path}\E//;	#strip any absolute path
 	$file =~ s/^\Q${lk_path}\E//;	#or the path to the lk tree
_
