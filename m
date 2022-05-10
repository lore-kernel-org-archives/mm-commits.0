Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675C3C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiEJEXi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236273AbiEJEVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B543C1AF8D8
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52CBE6176B
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2DFC385C5;
        Tue, 10 May 2022 04:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156244;
        bh=h/P/CwkbgVI4A9eWB2fD9K8GSCfQ8fe3u8KtHDnzLjo=;
        h=Date:To:From:Subject:From;
        b=wxRB2isv42oZh4tH3yyvQpCcxHXIgVhr20xOu1oDADQz7r4IDB/dR9WiIIhMya/Iw
         3mhaXKdNqADslI3z2w4N3reLR7ydRpduYk7EuKGtpYLL3i/hY/MnZJvvjvoFbTXqbN
         1flbiRGXZkKRIQxZUJH9HacRD2sv8pih9dnjwqX8=
Date:   Mon, 09 May 2022 21:17:24 -0700
To:     mm-commits@vger.kernel.org, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant.patch removed from -mm tree
Message-Id: <20220510041724.AA2DFC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/bloat-o-meter: filter out vermagic as it is not relevant
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: scripts/bloat-o-meter: filter out vermagic as it is not relevant

Seeing it as a false positive increase at the top is just noise:

   linux-head$./scripts/bloat-o-meter ../pre/vmlinux ../post/vmlinux
   add/remove: 0/571 grow/shrink: 1/9 up/down: 20/-64662 (-64642)
   Function                                     old     new   delta
   vermagic                                      49      69     +20

Since it really doesn't "grow", it makes sense to filter it out.

Link: https://lkml.kernel.org/r/20220428035824.7934-1-paul.gortmaker@windriver.com
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-filter-out-vermagic-as-it-is-not-relevant
+++ a/scripts/bloat-o-meter
@@ -36,6 +36,7 @@ def getsizes(file, format):
                 if name.startswith("__se_compat_sys"): continue
                 if name.startswith("__addressable_"): continue
                 if name == "linux_banner": continue
+                if name == "vermagic": continue
                 # statics and some other optimizations adds random .NUMBER
                 name = re_NUMBER.sub('', name)
                 sym[name] = sym.get(name, 0) + int(size, 16)
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are


