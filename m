Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119AAC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB73461029
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhJGTiQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhJGTiP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 15:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4EA610C8;
        Thu,  7 Oct 2021 19:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633635381;
        bh=OxQ9rjRsqAVFIAOS95C4YGSSSIVg9aNmG45cwglHnnY=;
        h=Date:From:To:Subject:From;
        b=wZOFWg7e1Jgbm7dc3NTWdCrL0JBz2VdQxUfolq/qChOF/FQTVD0wBXqh2cc2SWBTv
         +UgU8tv49sAbB8AtwBcH/h/05+YfbA8kPZYHsQXtQIJKsx+ct1lGA43Nv2IkfYMCmv
         pF/ZrdKm1o480kJ1LDKa+Sr9QHEcTmk22pplS93E=
Date:   Thu, 07 Oct 2021 12:36:21 -0700
From:   akpm@linux-foundation.org
To:     arequipeno@gmail.com, dwaipayanray1@gmail.com, joe@perches.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org
Subject:  +
 checkpatch-improve-export_symbol-test-for-export_symbol_ns-uses.patch added
 to -mm tree
Message-ID: <20211007193621.5FLbdgWdh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve EXPORT_SYMBOL test for EXPORT_SYMBOL_NS uses
has been added to the -mm tree.  Its filename is
     checkpatch-improve-export_symbol-test-for-export_symbol_ns-uses.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-export_symbol-test-for-export_symbol_ns-uses.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-export_symbol-test-for-export_symbol_ns-uses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-improve-export_symbol-test-for-export_symbol_ns-uses.patch

