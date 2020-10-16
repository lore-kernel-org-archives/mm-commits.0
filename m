Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3F6C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD4B208E4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814803;
	bh=ohGgnc9a4B23BeAIP+OBrx5mYmUFo7i7+IX43IbI1Gs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=El8QfcvPTfXNn+zMYtGq7L5hlTiWWTsWBmFzzI1FqFEg3jdjbtoK4sbpCbiRUoY9b
	 opIvNoo6Mrt1m4l8SFgNHGH2tY4ePgLgzwwk5QOMdAqvxx8T1wPeUyEtaYlzWq1iAJ
	 5r7+6xeMyGBlxuiE5efYR9G4SPRMQpFvAAP/bijw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbgJPCUD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbgJPCUD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:20:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F4520878;
        Fri, 16 Oct 2020 02:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814802;
        bh=ohGgnc9a4B23BeAIP+OBrx5mYmUFo7i7+IX43IbI1Gs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xCnm4M3OcynHVYz28TSgsTrtULDqMj3E8dUzDpAX3/fvBdfFWjCqrZIoyTbQ+dVL3
         lHg4Nl1MPWKtjDnH+SpTuPuHaZUapjeu/daMXTZc0b5ZB0dmqrxQ7/nhkn7eqaTrMk
         AdOG5HyjPofBb6lPJxPlDY6GrOLaZUx5eINgrckA=
Date:   Thu, 15 Oct 2020 19:20:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     joe@perches.com, julia.lawall@inria.fr, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 checkpatch-allow-not-using-f-with-files-that-are-in-git-fix.patch removed
 from -mm tree
Message-ID: <20201016022001.QfKFrPIWG%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix git "fatal" warning if file argument outside kernel tree
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-not-using-f-with-files-that-are-in-git-fix.patch

This patch was dropped because it was folded into checkpatch-allow-not-using-f-with-files-that-are-in-git.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: fix git "fatal" warning if file argument outside kernel tree

commit bcf4271d4bc3 ("checkpatch: allow not using -f with files that are
in git") in linux-next causes checkpatch to emit a fatal message:

fatal: <file>: '<file>' is outside repository at '<kernel_dir>'

Fix that by sending git's error output to /dev/null instead.

Link: https://lkml.kernel.org/r/b6afa04112d450c2fc120a308d706acd60cee294.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Reviewed-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-allow-not-using-f-with-files-that-are-in-git-fix
+++ a/scripts/checkpatch.pl
@@ -979,7 +979,7 @@ sub git_is_single_file {
 
 	return 0 if ((which("git") eq "") || !(-e "$gitroot"));
 
-	my $output = `${git_command} ls-files -- $filename`;
+	my $output = `${git_command} ls-files -- $filename 2>/dev/null`;
 	my $count = $output =~ tr/\n//;
 	return $count eq 1 && $output =~ m{^${filename}$};
 }
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-add-test-for-file-in-vcs.patch
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch
checkpatch-warn-on-self-assignments.patch
checkpatch-allow-not-using-f-with-files-that-are-in-git.patch
checkpatch-emit-a-warning-on-embedded-filenames.patch
checkpatch-test-git_dir-changes.patch

