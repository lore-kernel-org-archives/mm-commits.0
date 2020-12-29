Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13B3C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A509621D94
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgL2XPM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgL2XPM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:15:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D635F221F8;
        Tue, 29 Dec 2020 23:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283672;
        bh=3kbq/wv4FipxfOTJdR6Nt2mEvd8YBKv2wg2tDtqAu0g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cQaeJgX08+/Egwz52MbLoqj2iBGCpfN2o0p46gB4M2fDEenc22XbGfFJLC+01Lxx1
         ec1aHvaz70Otdxo+IvCObHFw9bsXIUsKty3eEEB2PJGNz+BQX2sbosQn4CCbtiaZ3h
         ZSfhiGV24ik++Y0R5tgJ6P1tjESTiidtS4CBhass=
Date:   Tue, 29 Dec 2020 15:14:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 04/16] checkpatch: prefer strscpy to strlcpy
Message-ID: <20201229231431.17XJD6-eN%akpm@linux-foundation.org>
In-Reply-To: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer strscpy to strlcpy

Prefer strscpy over the deprecated strlcpy function.

Link: https://lkml.kernel.org/r/19fe91084890e2c16fe56f960de6c570a93fa99b.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Requested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-prefer-strscpy-to-strlcpy
+++ a/scripts/checkpatch.pl
@@ -6646,6 +6646,12 @@ sub process {
 #			}
 #		}
 
+# strlcpy uses that should likely be strscpy
+		if ($line =~ /\bstrlcpy\s*\(/) {
+			WARN("STRLCPY",
+			     "Prefer strscpy over strlcpy - see: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw\@mail.gmail.com/\n" . $herecurr);
+		}
+
 # typecasts on min/max could be min_t/max_t
 		if ($perl_version_ok &&
 		    defined $stat &&
_
