Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03266C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4DF22078A
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817941;
	bh=brCt0qCHfkBhA9EqYNloJ/UWycXfoEpG9gxV2FQ2jrw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Z5x1ZxrkPHIFNz/TXrRnUJ9VS9cDrUCJlPZIRQld/edEbRgb6QfuvL1tyaKrft8pD
	 iZr4r24OKLcyQW+DYl8TZSM53CEFNAMMK81J1CC0rYvTiN3VpGCwIY6y2q6Ef5gEDl
	 bjj0y9hhZcz0TtUgSQ4Ejmwdlo3/1RrrVvSbpkiU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389745AbgJPDMV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDMU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F3B520789;
        Fri, 16 Oct 2020 03:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817939;
        bh=brCt0qCHfkBhA9EqYNloJ/UWycXfoEpG9gxV2FQ2jrw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=laJWBE7bV07PoADWE30mld5sqJYmLIv4cZ+ZQQmuRxsNsN5J+yrsl51+jKev9eUjk
         TJKcrvxxnxf4eUntArWrD7+5Z2zOoe1d65NOW2vWks//CXuH3NrXA8Vro1MqVk1BmX
         KOamFsDfTqNtvQU7nK55NFDYGfFcebK49R0zQ0XQ=
Date:   Thu, 15 Oct 2020 20:12:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 130/156] checkpatch: emit a warning on embedded
 filenames
Message-ID: <20201016031219.lTsbQlE1N%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: emit a warning on embedded filenames

Embedding the complete filename path inside the file isn't particularly
useful as often the path is moved around and becomes incorrect.

Emit a warning when the source contains the filename.

[akpm@linux-foundation.org: remove stray " di"]
Link: https://lkml.kernel.org/r/1fd5f9188a14acdca703ca00301ee323de672a8d.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-emit-a-warning-on-embedded-filenames
+++ a/scripts/checkpatch.pl
@@ -3271,6 +3271,12 @@ sub process {
 			}
 		}
 
+# check for embedded filenames
+		if ($rawline =~ /^\+.*\Q$realfile\E/) {
+			WARN("EMBEDDED_FILENAME",
+			     "It's generally not useful to have the filename in the file\n" . $herecurr);
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|sh|dtsi|dts)$/);
 
_
