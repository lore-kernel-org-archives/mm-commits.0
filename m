Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38546C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjBCGwo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbjBCGvt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7484FAE6
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1DE361DB3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A0CC4339E;
        Fri,  3 Feb 2023 06:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407095;
        bh=z8KFWxUETxxGwkpFejjw065lGYe1Un8SEfgmZKDu/OE=;
        h=Date:To:From:Subject:From;
        b=bALKQL3V4MGA1MUqfhdzUS3gDOF5JBuerP7PzDVWJA6bUCwES74tN1CIUMomJbqfu
         opkjDSQhIhmxwOzGdZscqnLY6gqGHJ6p3BypekTNtcwiflx2sz43FyfPaPCALdtS2r
         iH4Ohx6e5MIxqJb8qm7m7ViQlRQb9miNS1eohrKE=
Date:   Thu, 02 Feb 2023 22:51:34 -0800
To:     mm-commits@vger.kernel.org, vipinsh@google.com,
        paulo.miguel.almeida.rodenas@gmail.com, nicolas@fjasle.eu,
        masahiroy@kernel.org, gregkh@linuxfoundation.org,
        cristian.ciocaltea@collabora.com, haokexin@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-tagssh-fix-the-kconfig-tags-generation-when-using-latest-ctags.patch removed from -mm tree
Message-Id: <20230203065135.06A0CC4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/tags.sh: fix the Kconfig tags generation when using latest ctags
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-fix-the-kconfig-tags-generation-when-using-latest-ctags.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: scripts/tags.sh: fix the Kconfig tags generation when using latest ctags
Date: Sat, 28 Jan 2023 14:49:16 +0800

The Kconfig language has already been built-in in the latest ctags, so it
would error exit if we try to define it as an user-defined language via
'--langdef=kconfig'.  This results that there is no Kconfig tags in the
final tag file.  Fix this by skipping the user Kconfig definition for the
latest ctags.

Link: https://lkml.kernel.org/r/20230128064916.912744-1-haokexin@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Cc: Vipin Sharma <vipinsh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/tags.sh~scripts-tagssh-fix-the-kconfig-tags-generation-when-using-latest-ctags
+++ a/scripts/tags.sh
@@ -264,10 +264,12 @@ exuberant()
 	--$CTAGS_EXTRA=+fq --c-kinds=+px --fields=+iaS --langmap=c:+.h \
 	"${regex[@]}"
 
-	setup_regex exuberant kconfig
-	all_kconfigs | xargs $1 -a                              \
-	--langdef=kconfig --language-force=kconfig "${regex[@]}"
-
+	KCONFIG_ARGS=()
+	if ! $1 --list-languages | grep -iq kconfig; then
+		setup_regex exuberant kconfig
+		KCONFIG_ARGS=(--langdef=kconfig --language-force=kconfig "${regex[@]}")
+	fi
+	all_kconfigs | xargs $1 -a "${KCONFIG_ARGS[@]}"
 }
 
 emacs()
_

Patches currently in -mm which might be from haokexin@gmail.com are


