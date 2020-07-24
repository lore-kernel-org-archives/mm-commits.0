Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01C8C433EB
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5FFC2067D
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564144;
	bh=tn4COE53W16/XxMKkwrXnw5tw4euj0ZnE02c0kvAO+Y=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=w/gSPYTmKL5JZP0a0fttmWcQ4YF1QuYzywjPOR6Pv8wr92gYo6VaYslVc3ueUts2H
	 r2Haa+VNNcclYggfMPXn4iOwlhz8ewgcN4UwIcjvaym4KX06LAn66AiUizlvhPC7id
	 Y8ZoxgH1KNVcfAfY9+3N60NMYSgEqKODxoD63vso=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgGXEPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXEPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9295F20663;
        Fri, 24 Jul 2020 04:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564143;
        bh=tn4COE53W16/XxMKkwrXnw5tw4euj0ZnE02c0kvAO+Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VYwYtZ51NWfZ/JXqZNocqn3NlQ1n7eh0dTkR2hvnK576uAVaGBXrUvbjx6SDP5QVj
         5E6o3O/xaIXAterDzWtBflYbbtu2R+Qdg9EFLOSjlPFFqb98XGtvt2zbIFLPp6AOHJ
         RPDZV1Am/9euBUnCBdzWaCpq36eyj3b+FVkGxtOU=
Date:   Thu, 23 Jul 2020 21:15:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, drinkcat@chromium.org, jslaby@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        pihsun@chromium.org, sashal@kernel.org, shik@chromium.org,
        swboyd@chromium.org, torvalds@linux-foundation.org
Subject:  [patch 12/15] scripts/decode_stacktrace: strip basepath
 from all paths
Message-ID: <20200724041543.8ISaKhaGe%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Nicolas Boichat <drinkcat@chromium.org>
Cc: Jiri Slaby <jslaby@suse.cz>
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
