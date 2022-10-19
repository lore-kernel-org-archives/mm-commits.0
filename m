Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAF6C43217
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiJSXAh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiJSXAa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:00:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD3F24BCF
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39A0E619E8
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD26C433C1;
        Wed, 19 Oct 2022 22:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666220399;
        bh=+tZocC0t0opEX7DO3MBj555V3sXoDnPWsUBIoU5GISA=;
        h=Date:To:From:Subject:From;
        b=Ugzcs2tPWZMLJs6OMIGxlR1SbNgzhwHp/EXcnhK5NljnFPbTdUN1aRzjEBx+q/0Ms
         EkDliKc7o9z0CrvMHIz4oxUUdZbzWGmfBVzYKnRLB4te9DTrQ/jpt+LdO76xVGJGsr
         CuSqhBoDLja7oQoVSeZW0N6bstdg8mqBkN2kiL0o=
Date:   Wed, 19 Oct 2022 15:59:58 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        lukas.bulwahn@gmail.com, keescook@chromium.org, joe@perches.com,
        dwaipayanray1@gmail.com, apw@canonical.com, bhelgaas@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-warning-for-non-lore-mailing-list-urls.patch added to mm-nonmm-unstable branch
Message-Id: <20221019225959.8BD26C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add warning for non-lore mailing list URLs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-warning-for-non-lore-mailing-list-urls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-warning-for-non-lore-mailing-list-urls.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: checkpatch: add warning for non-lore mailing list URLs
Date: Wed, 19 Oct 2022 15:28:43 -0500

The lkml.org, marc.info, spinics.net, etc archives are not quite as useful
as lore.kernel.org because they use different styles, add advertising, and
may disappear in the future.  The lore archives are more consistent and
more likely to stick around, so prefer https://lore.kernel.org URLs when
they exist.

Link: https://lkml.kernel.org/r/20221019202843.40810-1-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org> # build-tested
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-non-lore-mailing-list-urls
+++ a/scripts/checkpatch.pl
@@ -702,6 +702,17 @@ sub find_standard_signature {
 	return "";
 }
 
+our $obsolete_archives = qr{(?xi:
+	\Qfreedesktop.org/archives/dri-devel\E |
+	\Qlists.infradead.org\E |
+	\Qlkml.org\E |
+	\Qmail-archive.com\E |
+	\Qmailman.alsa-project.org/pipermail\E |
+	\Qmarc.info\E |
+	\Qozlabs.org/pipermail\E |
+	\Qspinics.net\E
+)};
+
 our @typeListMisordered = (
 	qr{char\s+(?:un)?signed},
 	qr{int\s+(?:(?:un)?signed\s+)?short\s},
@@ -3324,6 +3335,12 @@ sub process {
 			$last_git_commit_id_linenr = $linenr if ($line =~ /\bcommit\s*$/i);
 		}
 
+# Check for mailing list archives other than lore.kernel.org
+		if ($rawline =~ m{\b$obsolete_archives}) {
+			WARN("PREFER_LORE_ARCHIVE",
+			     "Use lore.kernel.org archive links when possible - see https://lore.kernel.org/lists.html\n" . $herecurr);
+		}
+
 # Check for added, moved or deleted files
 		if (!$reported_maintainer_file && !$in_commit_log &&
 		    ($line =~ /^(?:new|deleted) file mode\s*\d+\s*$/ ||
_

Patches currently in -mm which might be from bhelgaas@google.com are

checkpatch-add-warning-for-non-lore-mailing-list-urls.patch

