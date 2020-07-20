Return-Path: <SRS0=eezP=A7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1D6C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 22:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6915620773
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595285713;
	bh=I+zxy9n48WdfdxL6vUZkriKacDgluX9XkW2HJOOhT3g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=p37U2ExXdbHLXjEX/70tQqWtJm7KNEnctuYSim9QlI3ACgNpdL0AMVGfOsbgR//2L
	 9u0JCh9iO/dXhXQUqoSW4dnX7WXAsxrn5Xm1JIKp34OZiAGGXyh/hESqxZXDYBIs9Q
	 2gxbs/hER6sI4qpzBjBmMEHfCTQFm39ei1BxeoM4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgGTWzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 18:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgGTWzM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 18:55:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E370020773;
        Mon, 20 Jul 2020 22:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595285712;
        bh=I+zxy9n48WdfdxL6vUZkriKacDgluX9XkW2HJOOhT3g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bWtFujdA77OSueQInMddvnm5WvJOtoCSbugy4tHo3aGBDUO/L23WBPfu+k1+OxDTc
         drit+MrHKB/jfoJt4jiow23aZescIC28QlseyUdsqNbDNrxRalpUtwVh1Py162gxj7
         oyAQyhhYi+ocs77A2vDHR1ve6XkKFlwabSF5+P2c=
Date:   Mon, 20 Jul 2020 15:55:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     drinkcat@chromium.org, mm-commits@vger.kernel.org,
        pihsun@chromium.org, sashal@kernel.org, shik@chromium.org,
        swboyd@chromium.org
Subject:  +
 scripts-decode_stacktrace-strip-basepath-from-all-paths.patch added to -mm
 tree
Message-ID: <20200720225511.qoPCs0DY9%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace: strip basepath from all paths
has been added to the -mm tree.  Its filename is
     scripts-decode_stacktrace-strip-basepath-from-all-paths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-decode_stacktrace-strip-basepath-from-all-paths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-decode_stacktrace-strip-basepath-from-all-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pi-Hsun Shih <pihsun@chromium.org>
Subject: scripts/decode_stacktrace: strip basepath from all paths

Currently the basepath is removed only from the beginning of the string. 
When the symbol is inlined and there's multiple line outputs of addr2line,
only the first line would have basepath removed.

Change to remove the basepath prefix from all lines.

Link: http://lkml.kernel.org/r/20200720082709.252805-1-pihsun@chromium.org
Fixes: 31013836a71e ("scripts/decode_stacktrace: match basepath using shell prefix operator, not regex")
Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Signed-off-by: Shik Chen <shik@chromium.org>
Co-developed-by: Shik Chen <shik@chromium.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-strip-basepath-from-all-paths
+++ a/scripts/decode_stacktrace.sh
@@ -87,8 +87,8 @@ parse_symbol() {
 		return
 	fi
 
-	# Strip out the base of the path
-	code=${code#$basepath/}
+	# Strip out the base of the path on each line
+	code=$(while read -r line; do echo "${line#$basepath/}"; done <<< "$code")
 
 	# In the case of inlines, move everything to same line
 	code=${code//$'\n'/' '}
_

Patches currently in -mm which might be from pihsun@chromium.org are

scripts-decode_stacktrace-strip-basepath-from-all-paths.patch

