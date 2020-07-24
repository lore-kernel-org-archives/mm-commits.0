Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07139C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEBF4206E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633922;
	bh=WpKwu90EQcQelSso1y5IFZ/8flz1Es7URrSkEYI7hF8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PvICeU+Ub7Pgw/q4s82nl4TVTBRxyrjHDj6CKgWEx2E2n21ZmJgoI5pqX4eEIUyft
	 vgdwMtAzyNd6If5Pd60tKMHNU4AwfoRUwQ7v9cnrMOtGlmSiaqkwSJCChDsuTR9oR9
	 JpMgsK681wACitJHSeQyX5ENj1qYP9LWbcj3cEiY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgGXXim (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgGXXim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FEF2070E;
        Fri, 24 Jul 2020 23:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633921;
        bh=WpKwu90EQcQelSso1y5IFZ/8flz1Es7URrSkEYI7hF8=;
        h=Date:From:To:Subject:From;
        b=0Myg8XA2A5Sf0ojKmAFkinzxhMaV/F8NqU4xn1ppTXtNySvJn9N/vOrytFCbmq6WJ
         Ee9h7MVpPHn05Ge4KMFMr6TsTEfm+lLSyBv9nAE/3y/V9HnYQ2EVglFyU1lxHKxvLH
         727DWSiS9qlUVmdQDYyRAGItZCBO29wMSMPW7d9A=
Date:   Fri, 24 Jul 2020 16:38:41 -0700
From:   akpm@linux-foundation.org
To:     drinkcat@chromium.org, jslaby@suse.cz, mm-commits@vger.kernel.org,
        pihsun@chromium.org, sashal@kernel.org, shik@chromium.org,
        swboyd@chromium.org
Subject:  [merged]
 scripts-decode_stacktrace-strip-basepath-from-all-paths.patch removed from
 -mm tree
Message-ID: <20200724233841.tD4JjXYJa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace: strip basepath from all paths
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktrace-strip-basepath-from-all-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from pihsun@chromium.org are


