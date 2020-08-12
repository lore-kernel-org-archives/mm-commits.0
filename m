Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0F1C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F2CF2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266349;
	bh=P3+dqO6ZRXHvo+xOT1q25xS2p2qfrGZpRGGbBPnqXlE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=UTcEapOCdjOv48Jqh+CNZw+D5yasTrX6IIBdcAlRIDG6KdXoQVJwFYC5WyO/R42zY
	 NNIpnLHcZF9uQi6qluG+KTZ/kUWOYPjp2LL9J8PZBw75E41TX04neDrdenM9zZWEF5
	 jjfr8rkOAEhE1sJ1uyo90JJJ0wFdAdGn/lUmR+nU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLVFs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVFs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C0D0207F7;
        Wed, 12 Aug 2020 21:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266346;
        bh=P3+dqO6ZRXHvo+xOT1q25xS2p2qfrGZpRGGbBPnqXlE=;
        h=Date:From:To:Subject:From;
        b=HPmQkSP3abIobgjNs6K7v71xx6Q4odw2ROyD/6tLFabRfomAa4lAtK1T21tREWQh6
         WAdmCp1fTXx9dhNYdK6S7HEHGpnK75dXroaSxtSapchgDKHyeM11esGhXy3J9rBRw3
         OISg66qXvFpae60FXdpyuKUYLL7dr7P9JdWNTZGc=
Date:   Wed, 12 Aug 2020 14:05:46 -0700
From:   akpm@linux-foundation.org
To:     aymeric.agon@yandex.com, jan.kiszka@siemens.com,
        kbingham@kernel.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, swboyd@chromium.org
Subject:  [merged] scripts-gdb-fix-python-38-syntaxwarning.patch
 removed from -mm tree
Message-ID: <20200812210546.VF2imsZbL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix python 3.8 SyntaxWarning
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-python-38-syntaxwarning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: scripts/gdb: fix python 3.8 SyntaxWarning

Fixes the observed warnings:
scripts/gdb/linux/rbtree.py:20: SyntaxWarning: "is" with a literal. Did
you mean "=="?
  if node is 0:
scripts/gdb/linux/rbtree.py:36: SyntaxWarning: "is" with a literal. Did
you mean "=="?
  if node is 0:

It looks like this is a new warning added in Python 3.8. I've only seen
this once after adding the add-auto-load-safe-path rule to my ~/.gdbinit
for a new tree.

Link: http://lkml.kernel.org/r/20200805225015.2847624-1-ndesaulniers@google.com
Link: https://adamj.eu/tech/2020/01/21/why-does-python-3-8-syntaxwarning-for-is-literal/
Fixes: commit 449ca0c95ea2 ("scripts/gdb: add rb tree iterating utilities")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Aymeric Agon-Rambosson <aymeric.agon@yandex.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/rbtree.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/rbtree.py~scripts-gdb-fix-python-38-syntaxwarning
+++ a/scripts/gdb/linux/rbtree.py
@@ -17,7 +17,7 @@ def rb_first(root):
         raise gdb.GdbError("Must be struct rb_root not {}".format(root.type))
 
     node = root['rb_node']
-    if node is 0:
+    if node == 0:
         return None
 
     while node['rb_left']:
@@ -33,7 +33,7 @@ def rb_last(root):
         raise gdb.GdbError("Must be struct rb_root not {}".format(root.type))
 
     node = root['rb_node']
-    if node is 0:
+    if node == 0:
         return None
 
     while node['rb_right']:
_

Patches currently in -mm which might be from ndesaulniers@google.com are


