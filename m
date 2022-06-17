Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9973FCCA47A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379904AbiFQC7p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379909AbiFQC7Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB8166209
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 420AF61D46
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E7DC34114;
        Fri, 17 Jun 2022 02:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434753;
        bh=2ssj7erxMCFwXh+1HO/flp+VI8Ub5WlPWoW1/3+TlpA=;
        h=Date:To:From:Subject:From;
        b=2Cm+chHpo8uB3/vOElKiTGFwBG8U8+3yicKsbPvynXrycqCWX4wiZxHup7LLis8Ku
         7uXIlB5VapxO8k2hjMa9sBc8BITIh+aDYxL2FOLdqtLoiwIf0XvWerAEcVmKlTZe/g
         QuEwO6g3f7B/QELcDS68cCqmYQ9FcH74MC2NkkFQ=
Date:   Thu, 16 Jun 2022 19:59:13 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        borneo.antonio@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-fix-incorrect-camelcase-detection-on-numeric-constant.patch removed from -mm tree
Message-Id: <20220617025913.93E7DC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: fix incorrect camelcase detection on numeric constant
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-incorrect-camelcase-detection-on-numeric-constant.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Antonio Borneo <borneo.antonio@gmail.com>
Subject: checkpatch: fix incorrect camelcase detection on numeric constant
Date: Mon, 13 Jun 2022 12:00:55 +0200

The code fragment below

	int foo(int *array, int index)
	{
		return array[index & 0xFF];
	}

triggers an incorrect camelcase detection by checking a substring of the
hex constant:

	CHECK: Avoid CamelCase: <xFF>
	#3: FILE: test.c:3:
	+	return array[index & 0xFF];

This is caused by passing the whole string "array[index & 0xFF]" to the
inner loop that iterates over a "$Ident" match.  The numeric constant is
not a $Ident as it doesn't start with [A-Za-z_] and should be excluded
from the match.

Similar issue can be detected with other constants like "1uL", "0xffffU".

Force the match to start at word boundary so the $Ident will be properly
checked starting from its first char and the constants will be
filtered-out.

Link: https://lkml.kernel.org/r/20220613100055.77821-1-borneo.antonio@gmail.com
Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-incorrect-camelcase-detection-on-numeric-constant
+++ a/scripts/checkpatch.pl
@@ -5721,7 +5721,7 @@ sub process {
 			    $var !~ /^(?:[a-z0-9_]*|[A-Z0-9_]*)?_?[a-z][A-Z](?:_[a-z0-9_]+|_[A-Z0-9_]+)?$/ &&
 #Ignore some three character SI units explicitly, like MiB and KHz
 			    $var !~ /^(?:[a-z_]*?)_?(?:[KMGT]iB|[KMGT]?Hz)(?:_[a-z_]+)?$/) {
-				while ($var =~ m{($Ident)}g) {
+				while ($var =~ m{\b($Ident)}g) {
 					my $word = $1;
 					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
 					if ($check) {
_

Patches currently in -mm which might be from borneo.antonio@gmail.com are


