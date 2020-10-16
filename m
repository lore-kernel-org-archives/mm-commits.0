Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEB8C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5EB820658
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881567;
	bh=jWynN2i2Vz6exsxuKqInTCMQVpwRL58LboR8hTsV1HU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mFjM4IHv9KhMMVVSBkmISYru3Bqnn3wPQCVK4GCfPAw6DQMJhcjJYou7uVHHwYUP2
	 oUHjYVeLlxrFnCFBUIBb5yOcAiFj7Cp+sK26f4kMLgb7H0IujuBg6lHTmCG4X6C4Yj
	 vNABw0MjDpVJ2fk50E9JZ8R4CM0NCvlEyZ8wNXaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408909AbgJPUwr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUwn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA4682064B;
        Fri, 16 Oct 2020 20:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881562;
        bh=jWynN2i2Vz6exsxuKqInTCMQVpwRL58LboR8hTsV1HU=;
        h=Date:From:To:Subject:From;
        b=aWAbgWRf6M0TAJtPgNm1OMsT5SIYUIc4fE47Q97Z4GgTlRhETFW0LmuzHP4xZHx7W
         RhosR5sSjN4k08AOzA9btHoD8Sc49XjSVJPg66HW+5382ZTHGVlF2nMlA99Xq/r14V
         OA1hgEnuE+ALXK4CEY2bnB4/Aviib8cx7Eb9ek+o=
Date:   Fri, 16 Oct 2020 13:52:42 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged] get_maintainer-add-test-for-file-in-vcs.patch
 removed from -mm tree
Message-ID: <20201016205242.MvoRkmHhl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: add test for file in VCS
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-test-for-file-in-vcs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch

