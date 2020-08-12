Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB185C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A7D20829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196076;
	bh=7yK4909hmiGXHPAljXzByNcfIcJarOUX4q5zZhY8Pgs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xE3k1MgTS2yNxlxWTAdNpmQstJ1gXQeF+82vsJxTh9b7Bel/87YxP0JGVC+GHWIIr
	 IKyO9tcVKVvUt19fL7cmCXeeIpkZSEhuGO3ukznW9XjQpew0l3uftzWlI21HhFD/cG
	 RgVTxsKjVDt3PF67c025AC4mVfBIJQIoGNyK6p0M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgHLBeg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBeg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE57206B2;
        Wed, 12 Aug 2020 01:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196075;
        bh=7yK4909hmiGXHPAljXzByNcfIcJarOUX4q5zZhY8Pgs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IH+6Vu/uUd09SChdHVYKQPtKBrZyh1K4gA8LSF0nn4eVXpFLqbdS/pX5GVDHvz2dc
         frBN0vMG7J/rZ86csg4k8uGBLW74bcy4dYOuTeuGNk1xj2zNZWZpyyUkZLMDU9HFXr
         zEOz6Y8+gmMFCj0MpuvVbiL9WMakQRnN8k4EuRHc=
Date:   Tue, 11 Aug 2020 18:34:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kent.overstreet@gmail.com,
        linux-mm@kvack.org, luc.vanoostenryck@gmail.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 082/165] lib/generic-radix-tree.c: remove unneeded
 __rcu
Message-ID: <20200812013435.qn4uVoFuk%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: lib/generic-radix-tree.c: remove unneeded __rcu

struct __genradix is defined as having its member 'root'
annotated as __rcu. But in the corresponding API RCU is not used.
Sparse reports this type mismatch as:
	lib/generic-radix-tree.c:56:35: warning: incorrect type in initializer (different address spaces)
	lib/generic-radix-tree.c:56:35:    expected struct genradix_root *r
	lib/generic-radix-tree.c:56:35:    got struct genradix_root [noderef] <asn:4> *__val
with 6 other ones.

So, correct root's type by removing this unneeded __rcu.

Link: http://lkml.kernel.org/r/20200621161745.55396-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/generic-radix-tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/generic-radix-tree.h~lib-generic-radix-treec-remove-unneeded-__rcu
+++ a/include/linux/generic-radix-tree.h
@@ -44,7 +44,7 @@
 struct genradix_root;
 
 struct __genradix {
-	struct genradix_root __rcu	*root;
+	struct genradix_root		*root;
 };
 
 /*
_
