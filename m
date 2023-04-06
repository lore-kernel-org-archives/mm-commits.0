Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9396C77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDFCyZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbjDFCxb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EF39745
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABE6D62C7A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11260C433EF;
        Thu,  6 Apr 2023 02:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749588;
        bh=KnM9FicVw4boxOFRQ4W98VFYdFww/iIBU5czMSebwEo=;
        h=Date:To:From:Subject:From;
        b=dy07c/nnSvZFVP6+geAFwvlYvnRmVkFRuAAuVKjCb6ZyZzDtaCFo3rvAbWzq6HlbK
         2+UVe+7SpDx7nJ7s1G42AvKQjIts4N9b9Z0qiaflXnE53v1TEJbd8iKqgjHRYWbUwS
         SxGrdh71Wsaqywv2Oml7cJ1guPgLsevwhQK2wlb4=
Date:   Wed, 05 Apr 2023 19:53:07 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        gerhard@engleder-embedded.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-ignore-ethtool_link_mode_-enum-values.patch removed from -mm tree
Message-Id: <20230406025308.11260C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: ignore ETHTOOL_LINK_MODE_ enum values
has been removed from the -mm tree.  Its filename was
     checkpatch-ignore-ethtool_link_mode_-enum-values.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: checkpatch: ignore ETHTOOL_LINK_MODE_ enum values
Date: Wed, 4 Jan 2023 21:15:24 +0100

Since commit 4104a20646 ("checkpatch: ignore generated CamelCase defines
and enum values") enum values like ETHTOOL_LINK_MODE_Asym_Pause_BIT are
ignored.  But there are other enums like
ETHTOOL_LINK_MODE_1000baseT_Full_BIT, which are not ignored because of the
not matching '1000baseT' substring.

Add regex to match all ETHTOOL_LINK_MODE enums.

Link: https://lkml.kernel.org/r/20230104201524.28078-1-gerhard@engleder-embedded.com
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Gerhard Engleder <gerhard@engleder-embedded.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-ignore-ethtool_link_mode_-enum-values
+++ a/scripts/checkpatch.pl
@@ -5809,6 +5809,8 @@ sub process {
 			    $var !~ /^(?:[A-Z]+_){1,5}[A-Z]{1,3}[a-z]/ &&
 #Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+#Ignore ETHTOOL_LINK_MODE_<foo> variants
+			    $var !~ /^ETHTOOL_LINK_MODE_/ &&
 #Ignore SI style variants like nS, mV and dB
 #(ie: max_uV, regulator_min_uA_show, RANGE_mA_VALUE)
 			    $var !~ /^(?:[a-z0-9_]*|[A-Z0-9_]*)?_?[a-z][A-Z](?:_[a-z0-9_]+|_[A-Z0-9_]+)?$/ &&
_

Patches currently in -mm which might be from gerhard@engleder-embedded.com are


