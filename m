Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D70DC61D97
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 20:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjA2UyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 15:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjA2UyR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 15:54:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780A814EA3
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 12:54:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 269A2B808CB
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 20:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF29C433D2;
        Sun, 29 Jan 2023 20:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675025653;
        bh=v7tDwaYZE9dgtPW1+6j1gr6sqy6LS4t932BEAmGUpSc=;
        h=Date:To:From:Subject:From;
        b=DNxkRZGtPIQwyzjtzNgdW1WLJxy8CdMlt6rw/sNAa0xD/AKrZfqBtaHu6RJ+bkYI4
         +YaLdbRTo0h+F+d3feBoyMPcL50xD8Zhu7vvCiYk/Lh9IJhdNpqpN8tSnK8Hl7UJ/1
         nJbqLbUUCoruC+Bhxe4zqVXonmRelv2HMe7DJduU=
Date:   Sun, 29 Jan 2023 12:54:13 -0800
To:     mm-commits@vger.kernel.org, vipinsh@google.com,
        paulo.miguel.almeida.rodenas@gmail.com, nicolas@fjasle.eu,
        masahiroy@kernel.org, gregkh@linuxfoundation.org,
        cristian.ciocaltea@collabora.com, haokexin@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-tagssh-fix-the-kconfig-tags-generation-when-using-latest-ctags.patch added to mm-nonmm-unstable branch
Message-Id: <20230129205413.AEF29C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: fix the Kconfig tags generation when using latest ctags
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-tagssh-fix-the-kconfig-tags-generation-when-using-latest-ctags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-tagssh-fix-the-kconfig-tags-generation-when-using-latest-ctags.patch

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

scripts-tagssh-fix-the-kconfig-tags-generation-when-using-latest-ctags.patch

