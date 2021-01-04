Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90FAC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A564A22512
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbhADWRd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 17:17:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhADWRd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 17:17:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FED522515;
        Mon,  4 Jan 2021 22:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609798612;
        bh=UMfD+GjqnnBiHnnSVni5BHJZXAap4Nmbix75qHbIs64=;
        h=Date:From:To:Subject:From;
        b=RvPX04lCZO4t1Ns3HIS5jgAht15QFypI50dx8y9Rffy5nt3/AVnGdO5r+ZE/cPwVy
         jtONt8eZ/+6RYSIWpPOdY0MpVZ3PJ7+UDFnbGzwtE6JvX5CunJ4wzixm856bYOAh23
         AmeqIjeKH6TIQy94epzWMSMkZ99auNEtNe5NgKd4=
Date:   Mon, 04 Jan 2021 14:16:52 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, johannes.czekay@fau.de,
        mm-commits@vger.kernel.org, nicolai.fischer@fau.de
Subject:  [to-be-updated]
 checkpatch-kconfig-add-missing-types-to-regex.patch removed from -mm tree
Message-ID: <20210104221652.ExT53E7Mt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: kconfig: add missing types to regex
has been removed from the -mm tree.  Its filename was
     checkpatch-kconfig-add-missing-types-to-regex.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nicolai Fischer <nicolai.fischer@fau.de>
Subject: checkpatch: kconfig: add missing types to regex

Kconfig parsing does not recognise all type attributes.
This adds the missing 'int', 'string' and 'hex' types.

Link: https://lkml.kernel.org/r/20210103075015.23946-3-nicolai.fischer@fau.de
Co-developed-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Nicolai Fischer <nicolai.fischer@fau.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-kconfig-add-missing-types-to-regex
+++ a/scripts/checkpatch.pl
@@ -3321,7 +3321,7 @@ sub process {
 				next if ($f =~ /^-/);
 				last if (!$file && $f =~ /^\@\@/);
 
-				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|prompt)\s*["']/) {
+				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|int|hex|string|prompt)\s*(?:["'].*)?$/) {
 					$is_start = 1;
 				} elsif ($lines[$ln - 1] =~ /^\+\s*help$/) {
 					$length = -1;
_

Patches currently in -mm which might be from nicolai.fischer@fau.de are

checkpatch-kconfig-enforce-help-text-indentation.patch
checkpatch-kconfig-clarify-warning-for-paragraph-length.patch
checkpatch-kconfig-enforce-block-indentation.patch

