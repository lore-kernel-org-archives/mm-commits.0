Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AD0C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C761361284
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhKICgS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235794AbhKICgQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9576E6134F;
        Tue,  9 Nov 2021 02:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425211;
        bh=j9sv+VqCsFmRPuxO0QCzqo249FXNQaf+H/JropyyBx4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hZt1YCpVH79Q9GbE0dxoUhNJfILwWPUAs5ceGn1DpGr/WXfYK4RnlqKCNa53zmK0Q
         /5xfIH4737WYP4eF8f1FFCp3rq1XbVKvw7gRTn0Omj0rMZJ+/FbhWM4zCYCL7PhURV
         JO6bp1QkofLErJ1Ld4BuQ/+x7RwStRxJGs1jxP+o=
Date:   Mon, 08 Nov 2021 18:33:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arequipeno@gmail.com,
        dwaipayanray1@gmail.com, joe@perches.com, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 40/87] checkpatch: improve EXPORT_SYMBOL test for
 EXPORT_SYMBOL_NS uses
Message-ID: <20211109023331.QLYxTOMOM%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
