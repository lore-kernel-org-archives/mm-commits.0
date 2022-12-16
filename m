Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4D0C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLPAjG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLPAjD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:39:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7003C5D6B8
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:39:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8AD261FB9
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392D4C433EF;
        Fri, 16 Dec 2022 00:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151141;
        bh=4GdF3q9kQzxpo8ROcZM4G2y2/tIUIJSy0ejn6XcNKcw=;
        h=Date:To:From:Subject:From;
        b=Rw+kL2Y9XJi9cgaBN9HBvq60kJmsRNa3Cf+aoYIot6jef5I3XaEgnBDsGJoUy4k72
         6Dbo1NWRrBNXOd29iofMw3jyw3Tpug/eGFZxbjMsr6H1vqiS6RSvkUIk9brz0yWybp
         owqlw0TT9Vfq42JwZEChujQveBZxgp9EOPNCTrn0=
Date:   Thu, 15 Dec 2022 16:39:00 -0800
To:     mm-commits@vger.kernel.org, thomas.petazzoni@bootlin.com,
        catalin.marinas@arm.com, alexandre.belloni@bootlin.com,
        clement.leger@bootlin.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-use-%pk-to-display-kernel-pointers-in-backtrace.patch removed from -mm tree
Message-Id: <20221216003901.392D4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: use %pK to display kernel pointers in backtrace
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-use-%pk-to-display-kernel-pointers-in-backtrace.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Clément Léger <clement.leger@bootlin.com>
Subject: mm/kmemleak: use %pK to display kernel pointers in backtrace
Date: Tue, 8 Nov 2022 10:43:22 +0100

Currently, %p is used to display kernel pointers in backtrace which result
in a hashed value that is not usable to correlate the address for debug. 
Use %pK which will respect the kptr_restrict configuration value and thus
allow to extract meaningful information from the backtrace.

Link: https://lkml.kernel.org/r/20221108094322.73492-1-clement.leger@bootlin.com
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-%pk-to-display-kernel-pointers-in-backtrace
+++ a/mm/kmemleak.c
@@ -361,7 +361,7 @@ static void print_unreferenced(struct se
 
 	for (i = 0; i < nr_entries; i++) {
 		void *ptr = (void *)entries[i];
-		warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
+		warn_or_seq_printf(seq, "    [<%pK>] %pS\n", ptr, ptr);
 	}
 }
 
_

Patches currently in -mm which might be from clement.leger@bootlin.com are


