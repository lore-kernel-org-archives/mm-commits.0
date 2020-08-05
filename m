Return-Path: <SRS0=JYiv=BP=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1464AC433E0
	for <mm-commits@archiver.kernel.org>; Wed,  5 Aug 2020 23:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16DF22CAE
	for <mm-commits@archiver.kernel.org>; Wed,  5 Aug 2020 23:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596668592;
	bh=jXvSdWuKXlPtDa2eAKAWZup+qqBNoZXW1lgT4vT7nGU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=va4cWLvoyZLNeXqdIRLI/a0qsEulgnQY8wM+7BF7C9mLkW475SCpWNFYsyp9PXO4r
	 Ea/RvztBeDxbBFDr2nKryT0dqZ2jjfGxZKKndD82UvNdYFXtokTKnrFEOSCHLVr1Z2
	 QtcQUPAkMMIx7/pPmLeiI9nue3Bk4dPMLd1WZqqQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgHEXDM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Aug 2020 19:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgHEXDL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 5 Aug 2020 19:03:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC81E22CA1;
        Wed,  5 Aug 2020 23:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596668591;
        bh=jXvSdWuKXlPtDa2eAKAWZup+qqBNoZXW1lgT4vT7nGU=;
        h=Date:From:To:Subject:From;
        b=oQb60CobOFWAtNlL2Gyb3B/PiI4ZlOFUrS14cTC0MJ8a8nQF9jhXAkiInZMx043jG
         tRDxHPXcpExRASZ1GXe+WsKhcKKK1clDpZhcAy2RM03dMdKZQGNfhKI+SnfRrC1Efu
         R0eee/DAob0b4F18WERd3pAyKhSJ8qoX2l9fCXcc=
Date:   Wed, 05 Aug 2020 16:03:10 -0700
From:   akpm@linux-foundation.org
To:     aymeric.agon@yandex.com, jan.kiszka@siemens.com,
        kbingham@kernel.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, swboyd@chromium.org
Subject:  + scripts-gdb-fix-python-38-syntaxwarning.patch added to
 -mm tree
Message-ID: <20200805230310.DMqOKT_1A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix python 3.8 SyntaxWarning
has been added to the -mm tree.  Its filename is
     scripts-gdb-fix-python-38-syntaxwarning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-fix-python-38-syntaxwarning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-fix-python-38-syntaxwarning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Stephen Boyd <swboyd@chromium.org>
Fixes: commit 449ca0c95ea2 ("scripts/gdb: add rb tree iterating utilities")
Link: https://adamj.eu/tech/2020/01/21/why-does-python-3-8-syntaxwarning-for-is-literal/
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Aymeric Agon-Rambosson <aymeric.agon@yandex.com>
Cc: Stephen Boyd <swboyd@chromium.org>
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

scripts-gdb-fix-python-38-syntaxwarning.patch

