Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA29C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CE542072D
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598402808;
	bh=SDEROZu0f4j6wELpFzX42uVawjmAc/Ed7sHN3aHCPJM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jrNTWFO7FQr4xVMFOYsgTX9mi8lD+KB0U4Y1YIrlQcZsmTDwmCorB5cFuKeX/eW9Z
	 VdubOPQPa7wGcL5cDPRy2grZUNDQNBKRj54QEYAilZLUyPi+gJ8Twb19tphTO/0I2m
	 gpF1KAppnvUEl0bYCGNcgUQDB5EPgGqX1Ly4AV9w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHZAqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgHZAqr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:46:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A0A52072D;
        Wed, 26 Aug 2020 00:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598402806;
        bh=SDEROZu0f4j6wELpFzX42uVawjmAc/Ed7sHN3aHCPJM=;
        h=Date:From:To:Subject:From;
        b=AjWAUFjyN4TvQifHE2xRsbSnF2RpueQ3Ri1x509wJhnqeF9VfwFgj8Sx3y0hVvkRa
         6ahWXLCzgGJQjli6iZNYcTMPl4tmPXpNsspU++YnOioNzsbOzIUwRcY8vKKPNNX+Sb
         vaKB+2ueYp+6RbihPusWQU+w3fKicFd+I8uKKK7U=
Date:   Tue, 25 Aug 2020 17:46:46 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  + get_maintainer-add-test-for-file-in-vcs.patch added to
 -mm tree
Message-ID: <20200826004646.82f9ZMM27%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: add test for file in VCS
has been added to the -mm tree.  Its filename is
     get_maintainer-add-test-for-file-in-vcs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-add-test-for-file-in-vcs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-add-test-for-file-in-vcs.patch

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
get_maintainer-add-test-for-file-in-vcs.patch
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch

