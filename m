Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5B0C001DD
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjFSUUZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjFSUUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAE2E68;
        Mon, 19 Jun 2023 13:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C680260EBA;
        Mon, 19 Jun 2023 20:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E0EC433C8;
        Mon, 19 Jun 2023 20:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206012;
        bh=P0bGxem5483Qyc71JVvHxLawsj19LQKPB6MCO4onMO4=;
        h=Date:To:From:Subject:From;
        b=NuvWlJV7rok0v/nKEQDaqahjAsSP5QLj9N1xK4ZzwzXKVcF1exH9NAM8i8Wxa5mef
         VmfV3xb6XdvTGOAAEk3NtcEywIXqGhBEwJJSLkvCrGN7VjB8Irf+Nlzk48S61TV2ZQ
         HPMu7V5EU8DPDW+pVvwsmxI4B4+T7Ufah5Hwejwk=
Date:   Mon, 19 Jun 2023 13:20:11 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        stable@vger.kernel.org, nicolas@fjasle.eu, ndesaulniers@google.com,
        nathan@kernel.org, mingo@kernel.org, masahiroy@kernel.org,
        david@redhat.com, prathubaronia2011@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-fix-the-gfp-flags-header-path-in-gfp-translate.patch removed from -mm tree
Message-Id: <20230619202012.24E0EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts: fix the gfp flags header path in gfp-translate
has been removed from the -mm tree.  Its filename was
     scripts-fix-the-gfp-flags-header-path-in-gfp-translate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Prathu Baronia <prathubaronia2011@gmail.com>
Subject: scripts: fix the gfp flags header path in gfp-translate
Date: Thu, 8 Jun 2023 21:14:49 +0530

Since gfp flags have been shifted to gfp_types.h so update the path in
the gfp-translate script.

Link: https://lkml.kernel.org/r/20230608154450.21758-1-prathubaronia2011@gmail.com
Fixes: cb5a065b4ea9c ("headers/deps: mm: Split <linux/gfp_types.h> out of <linux/gfp.h>")
Signed-off-by: Prathu Baronia <prathubaronia2011@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gfp-translate |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/gfp-translate~scripts-fix-the-gfp-flags-header-path-in-gfp-translate
+++ a/scripts/gfp-translate
@@ -63,11 +63,11 @@ fi
 
 # Extract GFP flags from the kernel source
 TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
-grep -q ___GFP $SOURCE/include/linux/gfp.h
+grep -q ___GFP $SOURCE/include/linux/gfp_types.h
 if [ $? -eq 0 ]; then
-	grep "^#define ___GFP" $SOURCE/include/linux/gfp.h | sed -e 's/u$//' | grep -v GFP_BITS > $TMPFILE
+	grep "^#define ___GFP" $SOURCE/include/linux/gfp_types.h | sed -e 's/u$//' | grep -v GFP_BITS > $TMPFILE
 else
-	grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
+	grep "^#define __GFP" $SOURCE/include/linux/gfp_types.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
 fi
 
 # Parse the flags
_

Patches currently in -mm which might be from prathubaronia2011@gmail.com are


