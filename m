Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E841C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 19:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiD0Trh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 15:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbiD0TrY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 15:47:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A414EA31
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 12:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3A1CB82987
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 19:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925CFC385A9;
        Wed, 27 Apr 2022 19:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651088520;
        bh=Z0vz/2W6qPtjAA116S7QHDmsmc8iimqdYnZa8QLU2dc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=DwdrLUSjCXZyjZVJvdB1mIGdieEPiFgF7uy9DuR8FLL58hiCZf+Lr/MVcCmguTsZH
         wpgdwjCoQsFHRUeEx4o68sasmGJk9VhHQJ9/wN8m/OZn9xkBinJVbXLjee1SaBniMH
         G83XrFDn0xBWzj2XNxqkfXNiv4twWfsSJquoQXnw=
Date:   Wed, 27 Apr 2022 12:41:59 -0700
To:     seakeel@gmail.com, hanshenghong2019@email.szu.edu.cn,
        corbet@lwn.net, baihaowen@meizu.com, akiyks@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220427124133.cc115bc8acb8de3dda921836@linux-foundation.org>
Subject: [patch 2/2] docs: vm/page_owner: use literal blocks for param description
Message-Id: <20220427194200.925CFC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Akira Yokosawa <akiyks@gmail.com>
Subject: docs: vm/page_owner: use literal blocks for param description

Sphinx generates hard-to-read lists of parameters at the bottom of the
page.  Fix them by putting literal-block markers of "::" in front of them.

Link: https://lkml.kernel.org/r/cfd3bcc0-b51d-0c68-c065-ca1c4c202447@gmail.com
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Fixes: 57f2b54a9379 ("Documentation/vm/page_owner.rst: update the documentation")
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alex Shi <seakeel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~docs-vm-page_owner-use-literal-blocks-for-param-description
+++ a/Documentation/vm/page_owner.rst
@@ -110,7 +110,7 @@ Usage
    If you want to sort by the page nums of buf, use the ``-m`` parameter.
    The detailed parameters are:
 
-   fundamental function:
+   fundamental function::
 
 	Sort:
 		-a		Sort by memory allocation time.
@@ -122,7 +122,7 @@ Usage
 		-s		Sort by stack trace.
 		-t		Sort by times (default).
 
-   additional function:
+   additional function::
 
 	Cull:
 		--cull <rules>
@@ -153,6 +153,7 @@ Usage
 
 STANDARD FORMAT SPECIFIERS
 ==========================
+::
 
 	KEY		LONG		DESCRIPTION
 	p		pid		process ID
_
