Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BA2C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiG3BIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3BIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3FD3B979
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AB93619EE
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939ECC433D7;
        Sat, 30 Jul 2022 01:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143289;
        bh=1SOiYh4NIAKzMLz7dX1pm7S56fx3IPM6usXqBgQjW3o=;
        h=Date:To:From:Subject:From;
        b=njvCjpIwcAgahAAc2aMxZyss92dNIlTA+qRrnv5cAlY8Bg5c8kHRBs8/TB9xGQYat
         YcGq6M1zJ3iLm94RWESoeHYH8sxtC2sCXyJXlapaeD4y+zYHu6q0A8RVz0SzszEzsm
         anMXVbSm2wLX2XkGJvXvx1wx9EgFZtLoVN5UgH2Y=
Date:   Fri, 29 Jul 2022 18:08:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, sj@kernel.org, Liam.Howlett@oracle.com,
        dhowells@redhat.com, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-rename-mt_init-to-mips_mt_init.patch removed from -mm tree
Message-Id: <20220730010809.939ECC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: rename mt_init to mips_mt_init
has been removed from the -mm tree.  Its filename was
     mips-rename-mt_init-to-mips_mt_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mips: rename mt_init to mips_mt_init

Move mt_init out of the way for the maple tree.  Use mips_mt prefix to
match the rest of the functions in the file.

Link: https://lkml.kernel.org/r/20220504002554.654642-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/mips-mt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/kernel/mips-mt.c~mips-rename-mt_init-to-mips_mt_init
+++ a/arch/mips/kernel/mips-mt.c
@@ -230,7 +230,7 @@ void mips_mt_set_cpuoptions(void)
 
 struct class *mt_class;
 
-static int __init mt_init(void)
+static int __init mips_mt_init(void)
 {
 	struct class *mtc;
 
@@ -243,4 +243,4 @@ static int __init mt_init(void)
 	return 0;
 }
 
-subsys_initcall(mt_init);
+subsys_initcall(mips_mt_init);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


