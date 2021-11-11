Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E411C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8741F61250
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhKKCzO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 810416103C;
        Thu, 11 Nov 2021 02:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599145;
        bh=9y9yE+LdKvi5x/bhwSvmxmGfSAtHSdOZfn7KnSEAia8=;
        h=Date:From:To:Subject:From;
        b=nZD2IlStEDfT/PavaTDuTUjCRe09bdUHlV6lkiGy5dQSNWYegdXf7LPkUjYObrRhp
         /mYh2ttsKXWc2Z+KVcdIFFQl9o+00xeckZXYQGiF2DxAddf6MKEnDfwaMYMsm5xSx9
         qCXfFx2UT7y7Ro3BZfEG9pbAGf+jGJRhGOq0HPaM=
Date:   Wed, 10 Nov 2021 18:52:25 -0800
From:   akpm@linux-foundation.org
To:     arequipeno@gmail.com, dwaipayanray1@gmail.com, joe@perches.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-improve-export_symbol-test-for-export_symbol_ns-uses.patch
 removed from -mm tree
Message-ID: <20211111025225.4izLJfRyn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve EXPORT_SYMBOL test for EXPORT_SYMBOL_NS uses
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-export_symbol-test-for-export_symbol_ns-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve EXPORT_SYMBOL test for EXPORT_SYMBOL_NS uses

The EXPORT_SYMBOL test expects a single argument but definitions of
EXPORT_SYMBOL_NS have multiple arguments.

Update the test to extract only the first argument from any
EXPORT_SYMBOL related definition.

Link: https://lkml.kernel.org/r/9e8f251b42e405f460f26a23ba9b33ef45a94adc.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Ian Pilcher <arequipeno@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/checkpatch.pl~checkpatch-improve-export_symbol-test-for-export_symbol_ns-uses
+++ a/scripts/checkpatch.pl
@@ -4449,6 +4449,7 @@ sub process {
 			#   XXX(foo);
 			#   EXPORT_SYMBOL(something_foo);
 			my $name = $1;
+			$name =~ s/^\s*($Ident).*/$1/;
 			if ($stat =~ /^(?:.\s*}\s*\n)?.([A-Z_]+)\s*\(\s*($Ident)/ &&
 			    $name =~ /^${Ident}_$2/) {
 #print "FOO C name<$name>\n";
_

Patches currently in -mm which might be from joe@perches.com are


