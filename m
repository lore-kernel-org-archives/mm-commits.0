Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B58AC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A994D2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816452;
	bh=Yxd1/wmlB+N+skJntfz8a6EIZ4FtD2ib1yOe1BIfJok=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LSjGEmjOGNUMz7kjF9A8/n9b5D0/trBWvfAXWLyJxQ9YDowKpEgbnEI76AnIf3+WV
	 mf1q7ZC6oXTZDN9MUXVTz0EYwONLQhqS/oO0LrITd9NhEEsbmKUe/cildb1edfaqWB
	 1erbkSDT3TbJvbwAy852fr3Em7VosNtIe8qtVcOo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404348AbgJPCrc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404339AbgJPCrc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF342087D;
        Fri, 16 Oct 2020 02:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816450;
        bh=Yxd1/wmlB+N+skJntfz8a6EIZ4FtD2ib1yOe1BIfJok=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CtX20eec73AeAdMPVPCr/R0j0HKUJHTpg8QzMItgMOSW8XBR/Svc4V4hy5aAd09Ru
         QyXACbg7qj/TBSyzicXXwJf8WvJKFLR4Q4USKbmQHHjg7XwwG/T4dityIDQPfuo8ia
         hIm8NMcP0l2Ns9Iq56zPOiV/zrFTeeDDl8ES8zC0=
Date:   Thu, 15 Oct 2020 19:47:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 100/156] get_maintainer: add test for file in VCS
Message-ID: <20201016024729.Sl2g6d9eP%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
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
