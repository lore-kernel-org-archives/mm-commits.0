Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52774C4167B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiKOWdD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238176AbiKOWcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D3F13EBF
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4003AB81B79
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC9AC433B5;
        Tue, 15 Nov 2022 22:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551543;
        bh=qtD/cQXd2/Qad84wXmqG1mnn9SHM3pAPSh89g+A4TPg=;
        h=Date:To:From:Subject:From;
        b=uE85QEhRhJ56LCaXxrd3dOPR+h+X0R1RXF4DR0iDeb/+y52/zT2o3Otjgc5BnXsBQ
         Py1A3QJkcifoNGlV0DkKdNN9Qm5CWNcPIrI7OamB2HXYyH+xOr6wOrt3tTy3SzE0Gg
         qorQyx7u3BE9aBbiRkJgd75KUmwSqlMnmQe/Z9Yk=
Date:   Tue, 15 Nov 2022 14:32:22 -0800
To:     mm-commits@vger.kernel.org, joe@perches.com, stf_xl@wp.pl,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-checkpatch-allow-case-macros.patch removed from -mm tree
Message-Id: <20221115223222.DDC9AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts: checkpatch: allow "case" macros
has been removed from the -mm tree.  Its filename was
     scripts-checkpatch-allow-case-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: scripts: checkpatch: allow "case" macros
Date: Thu, 27 Oct 2022 15:43:34 +0200

Do not report errors like below:

./scripts/checkpatch.pl -f drivers/net/wireless/ath/ath10k/wmi.h

ERROR: Macros with complex values should be enclosed in parentheses
+#define C2S(x) case x: return #x

since many "case ..." macros are already used by some in-kernel drivers.

Link: https://lkml.kernel.org/r/20221027134334.164301-1-stf_xl@wp.pl
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/checkpatch.pl~scripts-checkpatch-allow-case-macros
+++ a/scripts/checkpatch.pl
@@ -5918,6 +5918,7 @@ sub process {
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
 			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringification #foo
+			    $dstat !~ /^case\b/ &&					# case ...
 			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
 			    $dstat !~ /^while\s*$Constant\s*$Constant\s*$/ &&		# while (...) {...}
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
_

Patches currently in -mm which might be from stf_xl@wp.pl are


