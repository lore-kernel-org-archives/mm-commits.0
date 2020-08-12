Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818E4C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ECA5207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196224;
	bh=HwnkAPmO7+1OKKPmNTySFF02DUcARYfGP0oPpn7FFJw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Z/P+kk7K3urSDHXwTW7bjw3MRIRCK5xBPSADHhgI1+Qni3/bjTkzNid5DKDG/vUpO
	 XsPhknhLp5I97YKeI7hwjuP8AeoicuZsaH1xJY/B35TQaL8kIcwRIQVCCWuyvLDegD
	 nDROA4rXZxLKjv9DPbAs3o8oxIWVQFgA9yMW7ne0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHLBhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 882AB2054F;
        Wed, 12 Aug 2020 01:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196222;
        bh=HwnkAPmO7+1OKKPmNTySFF02DUcARYfGP0oPpn7FFJw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h+uTFp7FfRnfPRrxwNnPAvh2vz929Xwn9Svj/qpHqTAvsSOFjfRdVtkPUBOPEhn1/
         /LgHuqy72SML6OtAuLXPCWyDIQ8U8538lCmZ7hrb9IEZtURkfX6f0X0EkpH1ELs/eX
         zvvLdskmWrFituJgmMQvGdnjm0l/KyaZu2Lem57c=
Date:   Tue, 11 Aug 2020 18:37:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aymeric.agon@yandex.com,
        jan.kiszka@siemens.com, kbingham@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        swboyd@chromium.org, torvalds@linux-foundation.org
Subject:  [patch 128/165] scripts/gdb: fix python 3.8 SyntaxWarning
Message-ID: <20200812013702.CttNEN-O6%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
