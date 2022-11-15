Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824D3C4321E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbiKOWck (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKOWcT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F555E9F
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D695CE1998
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EE4C433C1;
        Tue, 15 Nov 2022 22:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551534;
        bh=EUaqSEA8hVXBerNVlg3nef5eFKn8zW8HMr9s+YY19Kc=;
        h=Date:To:From:Subject:From;
        b=Qs1UOI6RhXd1YbKdYwck76zQjjHM9kLZs4Dalm6RwBeFUsjVP4TXiNCEsIpE3fVWL
         c8myD78wkBDVd1hQ7AVyft9Y0/HO+bQsjtmESZ6Pk8E6s4WmT+DN/XaDnxeny17Fyq
         96+zLRNeQiRLplNNe1cz1FUODQbi+3p3HsNaralU=
Date:   Tue, 15 Nov 2022 14:32:14 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, pcc@google.com,
        lukas.bulwahn@gmail.com, keescook@chromium.org, joe@perches.com,
        dwaipayanray1@gmail.com, apw@canonical.com, bhelgaas@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-warning-for-non-lore-mailing-list-urls.patch removed from -mm tree
Message-Id: <20221115223214.B2EE4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: add warning for non-lore mailing list URLs
has been removed from the -mm tree.  Its filename was
     checkpatch-add-warning-for-non-lore-mailing-list-urls.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: checkpatch: add warning for non-lore mailing list URLs
Date: Wed, 19 Oct 2022 15:28:43 -0500

The lkml.org, marc.info, spinics.net, etc archives are not quite as useful
as lore.kernel.org because they use different styles, add advertising, and
may disappear in the future.  The lore archives are more consistent and
more likely to stick around, so prefer https://lore.kernel.org URLs when
they exist.

[bhelgaas@google.com: only warn if we see "http" before the archive hostname]
  Link: https://lkml.kernel.org/r/20221114224315.GA939630@bhelgaas
Link: https://lkml.kernel.org/r/20221019202843.40810-1-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Peter Collingbourne <pcc@google.com>
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
+		if ($rawline =~ m{http.*\b$obsolete_archives}) {
+			WARN("PREFER_LORE_ARCHIVE",
+			     "Use lore.kernel.org archive links when possible - see https://lore.kernel.org/lists.html\n" . $herecurr);
+		}
+
 # Check for added, moved or deleted files
 		if (!$reported_maintainer_file && !$in_commit_log &&
 		    ($line =~ /^(?:new|deleted) file mode\s*\d+\s*$/ ||
_

Patches currently in -mm which might be from bhelgaas@google.com are


